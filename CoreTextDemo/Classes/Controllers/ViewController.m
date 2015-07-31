//
//  ViewController.m
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/7/22.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "ViewController.h"
#import "CoreTextParser.h"
#import "DisPlayViewData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x016655);
    [YYViewHierarchy3D show];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CoreTextParser* parser = [[CoreTextParser alloc] init];
    
    DisPlayViewData *data = [parser getDisplayDataWithText:@"<img src=\"coreText_img.jpeg\" width=\"120\" height=\"182\"> Hello <font color=\"red\">core text <font color=\"blue\">world! <img src=\"coreText_img.jpeg\" width=\"120\" height=\"182\"> <link url=\"http://blog.devtang.com\" color=\"red\" content=\"link test\">"];
    
    [self.disPlayView setDataSourceWithDisPlayData:data];
    
    self.disPlayView.height = data.viewHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
