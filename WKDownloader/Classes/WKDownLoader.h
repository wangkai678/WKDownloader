//
//  rr.h
//  Pods
//
//  Created by wangkai on 2017/9/4.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WKDownLoadState) {
    WKDownLoadStatePause,
    WKDownLoadStateDownLoading,
    WKDownLoadStateSuccess,
    WKDownLoadStateFailed
};

typedef void(^DownLoadInfoType)(long long totalSize);
typedef void(^ProgressBlockType)(float progress);
typedef void(^SuccessBlockType)(NSString *filePath);
typedef void(^FailedBlockType)();
typedef void(^StateChangeType)(WKDownLoadState state);

@interface WKDownLoader : NSObject

- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlockType)progressBlock success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

/**
 根据URL地址下载资源，如果任务已经存在，则继续下载

 @param url 资源下载路径
 */
- (void)downLoader:(NSURL *)url;


/**
 暂停任务
 */
- (void)pauseCurrentTask;


/**
 取消下载
 */
- (void)cancelCurrentTask;


/**
 取消任务，并清理缓存
 */
- (void)cancelAndClean;


/**
 继续下载
 */
- (void)resumeCurrentTask;

@property (nonatomic ,assign,readonly) float progress;
@property (nonatomic,assign,readonly) WKDownLoadState state;


@property (nonatomic, copy) DownLoadInfoType downLoadInfo;

@property (nonatomic, copy) StateChangeType stateChange;

@property (nonatomic, copy) ProgressBlockType progressChange;

@property (nonatomic, copy) SuccessBlockType successBlock;

@property (nonatomic, copy) FailedBlockType faildBlock;



@end
