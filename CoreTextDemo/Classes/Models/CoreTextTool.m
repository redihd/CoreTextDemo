//
//  CoreTextTool.m
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/31.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "CoreTextTool.h"

@implementation CoreTextTool
+ (NSDictionary *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(DisPlayViewData *)data{
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return nil;
    }
    CFIndex count = CFArrayGetCount(lines);
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex idx = -1;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            // 获得当前点击坐标对应的字符串偏移
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }
    return [self linkAtIndex:idx linkArray:data.linkArray];
}

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}


+ (NSDictionary *)linkAtIndex:(CFIndex)i linkArray:(NSArray *)linkArray {
    NSDictionary *link = nil;
    for (NSDictionary *data in linkArray) {
        if (i>[[data objectForKey:@"location"] integerValue] && i< [[data objectForKey:@"location"] integerValue] + ((NSString *)[data objectForKey:@"urlString"]).length) {
            link = data;
            break;
        }
    }
    return link;
}
@end
