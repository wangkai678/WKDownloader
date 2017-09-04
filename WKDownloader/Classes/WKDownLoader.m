//
//  rr.m
//  Pods
//
//  Created by wangkai on 2017/9/4.
//
//

#import "WKDownLoader.h"

@implementation WKDownLoader

+ (void)downLoader:(NSURL *)url {
    //1. 文件的存放
    //下载中 =>temp + 名称
    //MD5 + URL 防止重复资源
    //a/1.png md5 -
    //b/1.png
    //下载完成 => cache + 名称
    
    //1.判断，url地址，对应的资源，是下载完毕，
    //1.1告诉外界，下载完毕，并且传递相关信息（本地的路径，文件的大小）
    //return
    
    //2.检测，临时文件是否存在
    //2.1 存在，：直接以当前的文件大小，作为开始字节，去网络请求资源
    // HTTP:rang:开始字节-结束字节
    
    //2.2不存在：从0字节开始请求资源
    
}

@end
