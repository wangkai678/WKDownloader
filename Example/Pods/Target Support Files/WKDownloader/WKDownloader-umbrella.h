#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSString+WK.h"
#import "WKDownLoader.h"
#import "WKDownLoaderManager.h"
#import "WKFileTool.h"

FOUNDATION_EXPORT double WKDownloaderVersionNumber;
FOUNDATION_EXPORT const unsigned char WKDownloaderVersionString[];

