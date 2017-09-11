//
//  rr.m
//  Pods
//
//  Created by wangkai on 2017/9/4.
//
//

#import "WKDownLoader.h"
#import "WKFileTool.h"

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTmpPath   NSTemporaryDirectory()

@interface WKDownLoader ()<NSURLSessionDataDelegate>
{
    long long _tmpSize;
    long long _totalSize;
}

@property (nonatomic, strong)NSURLSession *session;
@property (nonatomic, copy)NSString *downLoadedPath;
@property (nonatomic, copy)NSString *downLoadingPath;
@property (nonatomic, strong)NSOutputStream *outputStream;
@property (nonatomic,weak)NSURLSessionDataTask *dataTask;
@end

@implementation WKDownLoader

- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlockType)progressBlock success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock {
    self.downLoadInfo = downLoadInfo;
    self.progressChange = progressBlock;
    self.successBlock = successBlock;
    self.faildBlock = failedBlock;
    [self downLoader:url];
}

- (void)downLoader:(NSURL *)url {
    //如果任务已经存在则继续下载，否则从头开始下载
    if ([url isEqual:self.dataTask.originalRequest.URL]) {
        if(self.state == WKDownLoadStatePause){
            //任务存在
            [self resumeCurrentTask];
            return;
        }
    }
    
    //能到这里两种情况：1.任务不存在。2.任务存在但是任务的url地址不同
    [self cancelCurrentTask];
    
    //1. 文件的存放
    //下载中 =>temp + 名称
    //MD5 + URL 防止重复资源
    //a/1.png md5 -
    //b/1.png
    //下载完成 => cache + 名称
    NSString *fileName = url.lastPathComponent;
    self.downLoadedPath = [kCachePath stringByAppendingPathComponent:fileName];
    self.downLoadingPath = [kTmpPath stringByAppendingPathComponent:fileName];
    //1.判断，url地址，对应的资源，是下载完毕，
    //1.1告诉外界，下载完毕，并且传递相关信息（本地的路径，文件的大小）
    //return
    if ([WKFileTool fileExists:self.downLoadedPath]) {
        //告诉外界，已经下载完成
        self.state = WKDownLoadStateSuccess;
        return;
    }
    
    
    //2.检测，临时文件是否存在
    if (![WKFileTool fileExists:self.downLoadingPath]) {
        //如果不存在则从0开始请求资源
        [self downLoadwithURL:url offset:0];
        return;
    }
    //2.1 存在，：直接以当前的文件大小，作为开始字节，去网络请求资源
    //获取本地大小
    _tmpSize = [WKFileTool fileSize:self.downLoadingPath];
    [self downLoadwithURL:url offset:_tmpSize];
}

- (void)pauseCurrentTask {
    if (self.state == WKDownLoadStateDownLoading) {
        self.state = WKDownLoadStatePause;
        [self.dataTask suspend];
    }
}

//继续下载
- (void)resumeCurrentTask {
    if (self.dataTask && self.state == WKDownLoadStatePause) {
        [self.dataTask resume];
        self.state = WKDownLoadStateDownLoading;
    }
}

- (void)cancelCurrentTask {
    self.state = WKDownLoadStatePause;
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)cancelAndClean {
    [self cancelCurrentTask];
    //删除缓存
    [WKFileTool removeFile:self.downLoadingPath];
}

#pragma mak - 协议方法
//第一次接受到响应的时候调用（响应头，并没有具体的资源内容）
//通过这个方法里面系统提供的回调代码块可以控制是继续请求还是取消本次请求
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // Content-Length 请求的大小 != 资源的大小
    //取资源总大小
    //[request setValue:[NSString stringWithFormat:@"bytes=%lld-",offset] forHTTPHeaderField:@"Range"];当不设置这个方法的时候Content-Range会没有
    //如果Content-Range有，应该从Content-Range里面获取
    _totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr && (contentRangeStr.length !=0)) {
        _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    if (self.downLoadInfo) {
        self.downLoadInfo(_totalSize);
    }
    
    //如果本地大小和总大小相等，则移动到下载完成文件夹，然后取消本次请求
    if (_tmpSize == _totalSize) {
        //移动到下载完成文件夹
        [WKFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        //取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        self.state = WKDownLoadStateSuccess;
        return;
    }
    
    //本地大小大于总大小
    if (_tmpSize > _totalSize) {
        //删除临时缓存
        [WKFileTool removeFile:self.downLoadingPath];
        //从0开始下载
        [self downLoader:response.URL];
        //取消请求
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    
    self.state = WKDownLoadStateDownLoading;
    //继续接受数据
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downLoadingPath append:YES];
    [self.outputStream open];
    completionHandler(NSURLSessionResponseAllow);
    
}

//当用户确定，继续接受数据的时候调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    _tmpSize += data.length;
    self.progress = 1.0 * _tmpSize / _totalSize;
    [self.outputStream write:data.bytes maxLength:data.length];
}

//请求完成的时候调用（!＝请求成功／失败）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
        //不一定是成功，
        //数据肯定可以请求完毕
        //判断，本地缓存是否等于总大小(filename:filesize:md5:xxx)
        //如果等于则验证文件是否完整（file md5）
        [WKFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        self.state = WKDownLoadStateSuccess;
    }else{
        //有问题
        //取消 断网
        if (error.code == -999) {
            self.state = WKDownLoadStatePause;
        }else{
            self.state = WKDownLoadStateFailed;
        }
    }
    [self.outputStream close];
}

#pragma mark - 私有方法
/**
根据开始字节请求资源

 @param url    下载地址
 @param offset 开始字节
 */
- (void)downLoadwithURL:(NSURL *)url offset:(long long)offset {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
   [request setValue:[NSString stringWithFormat:@"bytes=%lld-",offset] forHTTPHeaderField:@"Range"];
    self.dataTask = [self.session dataTaskWithRequest:request];
    [self resumeCurrentTask];
}

#pragma mark - 懒加载
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (void)setState:(WKDownLoadState)state{
    if (_state == state) {
        return;
    }
    _state = state;
    if (self.stateChange) {
        self.stateChange(_state);
    }
    if (_state == WKDownLoadStateSuccess && self.successBlock) {
        self.successBlock(self.downLoadedPath);
    }
    if (_state == WKDownLoadStateFailed && self.faildBlock) {
        self.faildBlock();
    }
}

- (void)setProgress:(float)progress {
    _progress = progress;
    if (self.progressChange) {
        self.progressChange(_progress);
    }
}

@end
