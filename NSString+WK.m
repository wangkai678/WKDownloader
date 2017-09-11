//
//  NSString+WK.m
//  Pods
//
//  Created by wangkai on 2017/9/11.
//
//

#import "NSString+WK.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (WK)

- (NSString *)md5 {
    const char *data = self.UTF8String;
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    //作用：把c语言的字符串转成md5字符串
    CC_MD5(data, (CC_LONG)strlen(data), md);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x",md[i]];
    }
    return result;
}

@end
