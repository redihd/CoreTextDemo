//
//  DisPlayView.m
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "DisPlayView.h"
#import "CoreTextParser.h"

@implementation DisPlayView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 得到当前绘制画布的上下文，用于后续将内容绘制在画布上
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 反转坐标系，如果将这部分的代码块注释掉，你会发现，整个界面将是上下翻转的
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 创建绘制的区域，CoreText 本身支持各种文字排版的区域，我们这里简单地将 UIView 的整个界面作为排版的区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    // CTFramesetter 是使用 Core Text 绘制时最重要的类。它管理你的字体引用和文本绘制帧, CTFramesetterCreateWithAttributedString 通过应用属性化文本创建 CTFramesetter 。
    CoreTextParser* parser = [[CoreTextParser alloc] init];
    NSAttributedString* attString = [parser getAttrStringFromText: @"Hello <font color=\"red\">core text <font color=\"blue\">world!"];
 //   NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Hello World!"];
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    
    // CTFrameDraw 将 frame 描述到设备上下文
    CTFrameDraw(frame, context);
    
    // 最后，释放所有使用的对象
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
