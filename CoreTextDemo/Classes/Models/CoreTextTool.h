//
//  CoreTextTool.h
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/31.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisPlayViewData.h"

@interface CoreTextTool : NSObject

+ (NSDictionary *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(DisPlayViewData *)data;

@end
