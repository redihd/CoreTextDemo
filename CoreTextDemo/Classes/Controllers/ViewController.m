//
//  ViewController.m
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "ViewController.h"
#import "CoreTextParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x016655);
    CoreTextParser* parser = [[CoreTextParser alloc] init];
    [self.disPlayView setDataSourceWithAttributedString:[parser getAttrStringFromText: @"<img src=\"coreText_img.jpeg\" width=\"120\" height=\"182\"> Hello <font color=\"red\">core text <font color=\"blue\">world!"] images:parser.images];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
