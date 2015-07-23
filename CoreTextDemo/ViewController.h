//
//  ViewController.h
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue)                                                                   \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                           \
                    green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                              \
                    blue:((float)(rgbValue & 0xFF)) / 255.0                                        \
                    alpha:1.0]
@interface ViewController : UIViewController


@end

