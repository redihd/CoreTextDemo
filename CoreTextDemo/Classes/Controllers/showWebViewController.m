//
//  showWebViewController.m
//  CoreTextDemo
//
//  Created by 朱泉伟 on 15/8/4.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "showWebViewController.h"

@interface showWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation showWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView.delegate = self;
    UIBarButtonItem * backBarItem= [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPressed:)];
    [self.navigationBar.topItem setLeftBarButtonItem:backBarItem];
    [self.navigationBar.topItem setTitle:@"loading..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
}


- (void)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_loadingIndicator startAnimating];
    _loadingIndicator.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_loadingIndicator stopAnimating];
    _loadingIndicator.hidden = YES;
    [self setViewControllerTitleFromWebView:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_loadingIndicator stopAnimating];
    _loadingIndicator.hidden = YES;

}

#pragma mark -
#pragma mark setTitle

- (void)setViewControllerTitleFromWebView:(UIWebView *)webView {
    NSString *webPageTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.navigationBar.topItem setTitle:webPageTitle];
}

@end
