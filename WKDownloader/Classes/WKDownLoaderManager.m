//
//  WKDownLoaderManager.m
//  Pods
//
//  Created by wangkai on 2017/9/11.
//
//

#import "WKDownLoaderManager.h"
#import "NSString+WK.h"

@interface WKDownLoaderManager ()<NSCopying,NSMutableCopying>

@property (nonatomic, strong) NSMutableDictionary *downLoadInfo;

@end

@implementation WKDownLoaderManager

static WKDownLoaderManager *_shareInstance;
+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (NSMutableDictionary *)downLoadInfo {
    if (!_downLoadInfo) {
        _downLoadInfo = [NSMutableDictionary dictionary];
    }
    return _downLoadInfo;
}

- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlockType)progressBlock success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock {
    NSString *urlMD5 = [url.absoluteString md5];
    
    WKDownLoader *downLoader = self.downLoadInfo[urlMD5];
    if (!downLoader) {
        downLoader = [[WKDownLoader alloc] init];
        self.downLoadInfo[urlMD5] = downLoader;
    }
    
    [downLoader downLoader:url downLoadInfo:downLoadInfo progress:progressBlock success:^(NSString *filePath) {
        [self.downLoadInfo removeObjectForKey:urlMD5];
        if (successBlock) {
            successBlock(filePath);
        }
    } failed:failedBlock];
}

- (void)pauseWithURL:(NSURL *)url {
    NSString *urlMD5 = [url.absoluteString md5];
    WKDownLoader *downLoader = self.downLoadInfo[urlMD5];
    [downLoader pauseCurrentTask];
}

- (void)resumeWithURL:(NSURL *)url {
    NSString *urlMD5 = [url.absoluteString md5];
    WKDownLoader *downLoader = self.downLoadInfo[urlMD5];
    [downLoader resumeCurrentTask];
}

- (void)cancelWithURL:(NSURL *)url {
    NSString *urlMD5 = [url.absoluteString md5];
    WKDownLoader *downLoader = self.downLoadInfo[urlMD5];
    [downLoader cancelCurrentTask];
    [self.downLoadInfo removeObjectForKey:urlMD5];
}

- (void)pauseAll {
    [self.downLoadInfo.allValues performSelector:@selector(pauseCurrentTask) withObject:nil];
}

- (void)resumeAll {
    [self.downLoadInfo.allValues performSelector:@selector(resumeCurrentTask) withObject:nil];
}

@end
