//
//  NSString+CNLiveCacheString.m
//  CNLiveCacheKit_Example
//
//  Created by 流诗语 on 2019/6/6.
//  Copyright © 2019年 woshiliushiyu. All rights reserved.
//

#import "NSString+CNLiveCacheString.h"
#import <objc/runtime.h>
#include <CommonCrypto/CommonCrypto.h>
#import <time.h>
#include <zlib.h>


@implementation NSString (CNLiveCacheString)
- (NSString *)md5
{
    const char *cStr = [[self dataUsingEncoding:NSUTF8StringEncoding] bytes];
    unsigned char digest[16];
    CC_MD5(cStr, (uint32_t)[[self dataUsingEncoding:NSUTF8StringEncoding] length], digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
- (BOOL)isEmpty
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!str2 || ![str2 isKindOfClass:[NSString class]] || str2.length == 0 || [str2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    }
    return NO;
}
@end
