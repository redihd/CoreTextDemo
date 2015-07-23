//
//  DisPlayView.h
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisPlayView : UIView

@property (strong, nonatomic) NSMutableArray * images;
@property (assign, nonatomic) CTFrameRef ctFrame;
@property (strong, nonatomic) NSMutableArray * drawImages;
@property (copy, nonatomic) NSAttributedString * attString;

- (void)setDataSourceWithAttributedString:(NSAttributedString *)attring images:(NSMutableArray *)images;

@end
