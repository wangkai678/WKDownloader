//
//  WKDownLoaderManager.h
//  Pods
//
//  Created by wangkai on 2017/9/11.
//
//

#import <Foundation/Foundation.h>
#import "WKDownloader.h"

@interface WKDownLoaderManager : NSObject

+ (instancetype)shareInstance;

- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlockType)progressBlock success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

- (void)pauseWithURL:(NSURL *)url;
- (void)resumeWithURL:(NSURL *)url;
- (void)cancelWithURL:(NSURL *)url;

- (void)pauseAll;
- (void)resumeAll;

@end
