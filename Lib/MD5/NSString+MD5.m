//
//  NSString+MD5.m
//  UMC
//

//

#import "NSString+MD5.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (MD5)


#pragma mark - MD5

- (NSString *)stringTo32MD5 {
    return [[self md5] lowercaseString];//uppercaseString
}

- (NSString *)stringTo16MD5 {
    return [[[self md5] substringWithRange:NSMakeRange(8, 16)] uppercaseString];
}

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSString *MD5str = [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                         result[0], result[1], result[2], result[3],
                         result[4], result[5], result[6], result[7],
                         result[8], result[9], result[10], result[11],
                         result[12], result[13], result[14], result[15]
                         ] lowercaseString];
    return MD5str;
}

@end
