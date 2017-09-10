//
//  WKViewController.m
//  WKDownloader
//
//  Created by wangkai_678@163.com on 08/14/2017.
//  Copyright (c) 2017 wangkai_678@163.com. All rights reserved.
//

#import "WKViewController.h"
#import <WKDownloader/WKDownloader.h>

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
    NSURL *url = [NSURL URLWithString:@"http://free2.macx.cn:8281/tools/photo/SnapNDragPro418.dmg"];
    [self.downLoader downLoader:url];
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
