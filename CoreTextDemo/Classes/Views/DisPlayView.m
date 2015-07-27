//
//  DisPlayView.m
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "DisPlayView.h"

@interface DisPlayView ()

@property (strong, nonatomic) DisPlayViewData * coreTextData;

@end

@implementation DisPlayView

-(void)setDataSourceWithDisPlayData:(DisPlayViewData *)displayData{
    self.coreTextData = displayData;
    self.drawImages = [NSArray array];
    
    //设置数据
    self.ctFrame = self.coreTextData.ctFrame;
    self.drawImages = self.coreTextData.imageArray;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 得到当前绘制画布的上下文，用于后续将内容绘制在画布上
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 反转坐标系，如果将这部分的代码块注释掉，你会发现，整个界面将是上下翻转的
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // CTFrameDraw 将 frame 描述到设备上下文
    CTFrameDraw(self.ctFrame, context);
    
    for (NSDictionary* imageData in self.drawImages) {
        UIImage* img = [imageData objectForKey:@"img"];
        CGRect imgBounds = CGRectFromString([imageData objectForKey:@"rect"]);
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }
}

@end
