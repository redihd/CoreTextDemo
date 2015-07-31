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

#pragma mark -
#pragma mark life Cycle

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addGestureRecognizers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addGestureRecognizers];
    }
    return self;
}

#pragma mark -
#pragma mark gesture

- (void)addGestureRecognizers{
    UIGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tapRecognizer];
    self.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark action

- (void)userTapGestureDetected:(UITapGestureRecognizer *)gestureRecognize{
    CGPoint touchPoint = [gestureRecognize locationInView:self];
    for (NSDictionary * imageData in self.drawImages) {
        // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
        CGRect imgBounds = CGRectFromString([imageData objectForKey:@"rect"]);
        CGPoint imagePosition = imgBounds.origin;
        imagePosition.y = self.bounds.size.height - imgBounds.origin.y - imgBounds.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imgBounds.size.width, imgBounds.size.height);
        // 检测点击位置 Point 是否在rect之内
        if (CGRectContainsPoint(rect, touchPoint)) {
            NSLog(@"hint image");
            // 在这里处理点击后的逻辑
            return;
        }
    }
    
}

#pragma mark -
#pragma mark setdateSource

-(void)setDataSourceWithDisPlayData:(DisPlayViewData *)displayData{
    self.coreTextData = displayData;
    self.drawImages = [NSArray array];
    
    //设置数据
    self.ctFrame = self.coreTextData.ctFrame;
    self.drawImages = self.coreTextData.imageArray;
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

@end
