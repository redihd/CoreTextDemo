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
#import "showWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x016655);
    __weak typeof(self) weakSelf = self;
    self.disPlayView.linkClickBlock = ^(NSString *url){
        
        showWebViewController *vc = [[showWebViewController alloc] init];
        vc.url = url;
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
    [YYViewHierarchy3D show];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CoreTextParser* parser = [[CoreTextParser alloc] init];
    
    DisPlayViewData *data = [parser getDisplayDataWithText:@"<img src=\"coreText_img.jpeg\" width=\"120\" height=\"182\"> Hello <font color=\"red\">core text <font color=\"blue\">world! <img src=\"coreText_img.jpeg\" width=\"120\" height=\"182\"> <link url=\"https://github.com/redihd/CoreTextDemo.git\" color=\"red\" content=\"link test\">"];
    
    [self.disPlayView setDataSourceWithDisPlayData:data];
    
    self.disPlayView.height = data.viewHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
