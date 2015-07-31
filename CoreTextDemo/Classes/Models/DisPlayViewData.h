//
//  DisPlayViewData.h
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/24.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisPlayViewData : NSObject

@property (assign, nonatomic) CGFloat viewHeight;
@property (assign, nonatomic) CTFrameRef ctFrame;
@property (strong, nonatomic) NSAttributedString * content;
@property (strong, nonatomic) NSArray * imageArray;
@property (strong, nonatomic) NSArray * linkArray;

@end
