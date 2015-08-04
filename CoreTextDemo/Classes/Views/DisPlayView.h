//
//  DisPlayView.h
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisPlayViewData.h"

typedef void(^LinkClickBlock)(NSString *url);

@interface DisPlayView : UIView

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (strong, nonatomic) NSArray * drawImages;
@property (strong, nonatomic) NSAttributedString * attString;

@property (copy, nonatomic) LinkClickBlock linkClickBlock;

- (void)setDataSourceWithDisPlayData:(DisPlayViewData *)displayData;

@end
