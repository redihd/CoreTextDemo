//
//  CoreTextParser.m
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "CoreTextParser.h"

@implementation CoreTextParser

#pragma mark -
#pragma mark life cycle

-(id)init
{
    self = [super init];
    if (self) {
        self.font = @"ArialMT";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark setCallBack

/* Callbacks */
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

#pragma mark -
#pragma mark setAttributedString

- (DisPlayViewData*)getDisplayDataWithText:(NSString*)text
{
    NSMutableAttributedString* aString =
    [[NSMutableAttributedString alloc] initWithString:@""];
    
    //创建一个匹配文本与标签的正则表达式。 这个正则表达式将匹配一段文本跟着一个标签。 这个正则表达式基本上可以说是“查找任何数量的字符，直到你遇到一个左括号。然后匹配任何数量的字符，直到你找到一个右括号， 或当你到了结束的字符串则停止处理。
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    
    //将文本和格式化标签分块 放入chunks数组
    NSArray* chunks = [regex matchesInString:text options:0
                                       range:NSMakeRange(0, [text length])];
    
    for (NSTextCheckingResult* b in chunks) {
        //遍历由之前的正则表达式匹配的块，用 “<"字符（标签开始）分割块。在返回的 parts[0]中是你需要的的文本内容，在parts[1]中包括了接下去的文字格式标签
        NSArray* parts = [[text substringWithRange:b.range]
                          componentsSeparatedByString:@"<"];
        
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,
                                                 24.0f, NULL);
        
        //为 NSAttributedString 设置格式化属性
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               (id)self.color.CGColor, kCTForegroundColorAttributeName,
                               (__bridge id)fontRef, kCTFontAttributeName,
                               (id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                               (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                               (id)[NSNumber numberWithFloat: 1], (NSString *)kCTUnderlineStyleAttributeName,
                               nil];
        [aString appendAttributedString:[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs]];
        
        CFRelease(fontRef);
        
        //处理parts[1]中所含的标签
        if ([parts count]>1) {
            NSString* tag = (NSString*)[parts objectAtIndex:1];
            [self addFontPartWithTag:tag];
            [self addImagePartWithTag:tag AttributedString:aString];
        }
    }
    return [self setDisPlayDataWithAttributedString:aString];
}

- (void)addFontPartWithTag:(NSString *)tag{
    if ([tag hasPrefix:@"font"]) {
        //画笔颜色
        NSRegularExpression* scolorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:NULL];
        [scolorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            if ([[tag substringWithRange:match.range] isEqualToString:@"none"]) {
                self.strokeWidth = 0.0;
            } else {
                self.strokeWidth = -3.0;
                SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                self.strokeColor = [UIColor performSelector:colorSel];
            }
        }];
        
        // 字体颜色
        NSRegularExpression* colorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")\\w+" options:0 error:NULL];
        [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
            self.color = [UIColor performSelector:colorSel];
        }];
        
        //字体大小
        NSRegularExpression* faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=face=\")[^\"]+" options:0 error:NULL];
        [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            self.font = [tag substringWithRange:match.range];
        }];
    }
}

- (void)addImagePartWithTag:(NSString *)tag AttributedString:(NSMutableAttributedString *)aString{
    if ([tag hasPrefix:@"img"]) {
        
        __block NSNumber* width = [NSNumber numberWithInt:0];
        __block NSNumber* height = [NSNumber numberWithInt:0];
        __block NSString* fileName = @"";
        
        //宽度
        NSRegularExpression* widthRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=width=\")[^\"]+" options:0 error:NULL];
        [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            width = [NSNumber numberWithInt: [[tag substringWithRange: match.range] intValue] ];
        }];
        
        //高度
        NSRegularExpression* faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=height=\")[^\"]+" options:0 error:NULL];
        [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            height = [NSNumber numberWithInt: [[tag substringWithRange:match.range] intValue]];
        }];
        
        //图片名
        NSRegularExpression* srcRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL];
        [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            fileName = [tag substringWithRange: match.range];
        }];
        
        //添加到数组中等待之后的绘制
        [self.images addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          width, @"width",
          height, @"height",
          fileName, @"fileName",
          [NSNumber numberWithInt: (int)[aString length]], @"location",
          nil]
         ];
        
        //设置CTRun的callBacks 和图片相关信息 来得到 CTRunDelegateRef
        CTRunDelegateCallbacks callbacks;
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getDescent = descentCallback;
        callbacks.getWidth = widthCallback;
        
        NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 width, @"width",
                                 height, @"height",
                                 nil];
        
        CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr));
        NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                //set the delegate
                                                (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                nil];
        
        //添加一个空白占位符 让它能够调用 callBacks 最后给生成的图片留下位置来做绘制操作
        // 使用0xFFFC作为空白的占位符
        unichar objectReplacementChar = 0xFFFC;
        NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
        [aString appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:attrDictionaryDelegate]];
    }
}

#pragma mark -
#pragma mark set disPlayData

- (DisPlayViewData *)setDisPlayDataWithAttributedString:(NSAttributedString *)aString{
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)aString);
    //     获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, textHeight));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    DisPlayViewData *data = [[DisPlayViewData alloc] init];
    data.content = aString;
    data.ctFrame = frame;
    data.viewHeight = textHeight;
    data.imageArray = self.images;
    
    CFRelease(framesetter);
    return data;
}

@end
