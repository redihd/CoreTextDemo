//
//  DisPlayView.m
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "DisPlayView.h"

@implementation DisPlayView

-(void)setDataSourceWithAttributedString:(NSAttributedString *)attring images:(NSMutableArray *)images{
    self.attString = attring;
    self.images = images;
    self.drawImages = [NSMutableArray array];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 得到当前绘制画布的上下文，用于后续将内容绘制在画布上
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attString);
//     获得要缓制的区域的高度
//    CGSize restrictSize = CGSizeMake(335, CGFLOAT_MAX);
//    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
//    CGFloat textHeight = coreTextSize.height;
//    CGRect viewFrame = self.frame;
//    viewFrame.size.height = textHeight;
//    self.frame = viewFrame;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, self.frame.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRetain(frame);
    self.ctFrame = frame;
    CFRelease(path);
    
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    int imgIndex = 0; //3
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //
    CFRange frameRange = CTFrameGetVisibleStringRange(self.ctFrame);
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) return;
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) {
        CTLineRef line = (__bridge CTLineRef)lineObj;
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            NSDictionary * metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) {
                CGRect runBounds;
                CGFloat ascent;
                CGFloat descent;
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                runBounds.origin.x = lineOrigins[lineIndex].x + xOffset;
                runBounds.origin.y = lineOrigins[lineIndex].y;
                runBounds.origin.y -= descent;
                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
                [self.drawImages addObject:[NSArray arrayWithObjects:img, NSStringFromCGRect(delegateBounds) , nil]];
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
            }
        }
        lineIndex++;
    }
    
    
    CFRelease(frame);
    CFRelease(framesetter);
    
    
    // 反转坐标系，如果将这部分的代码块注释掉，你会发现，整个界面将是上下翻转的
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // CTFrameDraw 将 frame 描述到设备上下文
    CTFrameDraw(self.ctFrame, context);
    
    for (NSArray* imageData in self.drawImages) {
        UIImage* img = [imageData objectAtIndex:0];
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }
}

@end
