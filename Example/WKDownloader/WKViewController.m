//
//  WKViewController.m
//  WKDownloader
//
//  Created by wangkai_678@163.com on 08/14/2017.
//  Copyright (c) 2017 wangkai_678@163.com. All rights reserved.
//

#import "WKViewController.h"
#import "WKDownLoader.h"

@interface WKViewController ()

@property(nonatomic,strong)WKDownLoader *downLoader;

@end

@implementation WKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (WKDownLoader *)downLoader {
    if (!_downLoader) {
        _downLoader = [[WKDownLoader alloc] init];
    }
    return _downLoader;
}
- (IBAction)download:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://m5.pc6.com/xuh5/Keka1011.dmg"];
//    [self.downLoader downLoader:url];
    [self.downLoader downLoader:url downLoadInfo:^(long long totalSize) {
        NSLog(@"下载信息--%lld",totalSize);
    } progress:^(float progress) {
         NSLog(@"下载进度--%f",progress);
    } success:^(NSString *filePath) {
         NSLog(@"下载完成路径--%@",filePath);
    } failed:^{
         NSLog(@"下载失败");
    }];
    [self.downLoader setStateChange:^(WKDownLoadState state){
        NSLog(@"%lu",(unsigned long)state);
    }];
}

- (IBAction)pause:(id)sender {
    [self.downLoader pauseCurrentTask];
}

- (IBAction)cancel:(id)sender {
    [self.downLoader cancelCurrentTask];
}

- (IBAction)cancelAndClean:(id)sender {
    [self.downLoader cancelAndClean];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
