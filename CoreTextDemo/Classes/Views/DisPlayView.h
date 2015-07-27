//
//  DisPlayView.h
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisPlayViewData.h"

@interface DisPlayView : UIView

@property (strong, nonatomic) NSMutableArray * images;
@property (assign, nonatomic) CTFrameRef ctFrame;
@property (strong, nonatomic) NSArray * drawImages;
@property (strong, nonatomic) NSAttributedString * attString;

- (void)setDataSourceWithAttributedString:(NSAttributedString *)attring images:(NSMutableArray *)images;
- (void)setDataSourceWithDisPlayData:(DisPlayViewData *)displayData;

@end
