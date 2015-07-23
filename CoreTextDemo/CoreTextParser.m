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
        self.font = @"Arial";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark

-(NSAttributedString*)getAttrStringFromText:(NSString*)text
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
    }
    
    return aString;
}

@end
