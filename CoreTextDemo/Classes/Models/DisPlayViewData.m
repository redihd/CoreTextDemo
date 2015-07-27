//
//  DisPlayViewData.m
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/24.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "DisPlayViewData.h"


@implementation DisPlayViewData

- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)dealloc {
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    [self addPositionDataToImageArray];
}

- (void)addPositionDataToImageArray{
    //取一个临时变量 可使用替换obj方法 replaceObjectAtIndex
    NSMutableArray *tempImageArray = [NSMutableArray arrayWithArray:self.imageArray];
    //得到cflines
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    // 拿到image所在位置（到时候需要设置位置，好画图）
    int imgIndex = 0; 
    NSDictionary* nextImage = [self.imageArray objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    CFRange frameRange = CTFrameGetVisibleStringRange(self.ctFrame);
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.imageArray count]) return;
        nextImage = [self.imageArray objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    // 遍历 line
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) {
        CTLineRef line = (__bridge CTLineRef)lineObj;
        // 遍历line 中得cfrun 得到image 的大小，位置等，重新对imageArray赋值
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
                NSDictionary* newImage = @{@"img":img,@"rect":NSStringFromCGRect(delegateBounds)};
                if (newImage!=nil) {
                    [tempImageArray replaceObjectAtIndex:imgIndex withObject:newImage];
                }
                imgIndex++;
                if (imgIndex < [self.imageArray count]) {
                    nextImage = [self.imageArray objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
            }
        }
        lineIndex++;
    }
    _imageArray = tempImageArray;
}

@end
