//
//  WKFileTool.h
//  Pods
//
//  Created by 王凯 on 17/9/9.
//
//

#import <Foundation/Foundation.h>

@interface WKFileTool : NSObject

+ (BOOL)fileExists:(NSString *)filePath;

+ (long long)fileSize:(NSString *)filePath;

+ (void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath;

+ (void)removeFile:(NSString *)filePath;
@end
