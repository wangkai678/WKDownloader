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


@interface WKDownLoader : NSObject

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

@property (nonatomic,assign) WKDownLoadState state;

@end
