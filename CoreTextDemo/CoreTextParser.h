//
//  CoreTextParser.h
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreTextParser : NSObject

@property (strong, nonatomic) NSString* font;
@property (strong, nonatomic) UIColor* color;
@property (strong, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@property (strong, nonatomic) NSMutableArray* images;

-(NSAttributedString*)getAttrStringFromText:(NSString*)text;
@end
