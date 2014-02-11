//
//  DFID.m
//  Copyright (c) 2014 Fiksu Inc. See license file.
//

#import "DFID.h"
#import <sys/sysctl.h>
#import <UIKit/UIKit.h>
#include <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

NSString *const DFID_VERSION = @"dfid_v7_alpha";

@implementation DFID

+ (NSString*) getSysInfoByName:(char*) typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+(NSString*) diskSpace {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    return [[dictionary objectForKey: NSFileSystemSize] stringValue];
}

+(NSString*) canOpenApps {
    NSArray *apps = [NSArray arrayWithObjects:
                     @"tel://",@"sms://",@"fb://",@"twitter://",@"ibooks://",@"comgooglemaps://",
                     @"pcast://",@"mgc://",@"youtube://",@"googlechrome://",@"googledrive://",
                     @"googlevoice://",
                     nil];
    NSString* a;
    NSMutableString* installed = [NSMutableString string];
    
    for (a in apps){
        NSURL* url = [NSURL URLWithString:a];
        [[UIApplication sharedApplication] canOpenURL:url] ? [installed appendString:@"T"] : [installed appendString:@"F"];
    }
    return installed;
}

+(NSString*) hasCydia {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        return @"T";
    } else {
        return @"F";
    }
}

+(NSString*) languageList {
    return [[NSLocale preferredLanguages] componentsJoinedByString:@","];
}

+(NSString*) carrierInfo {
    NSMutableString* cInfo = [NSMutableString string];
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString *carrierName = [carrier carrierName];
    if (carrierName != nil){
        [cInfo appendString:carrierName];
    }
    
    NSString *mcc = [carrier mobileCountryCode];
    if (mcc != nil){
        [cInfo appendString:mcc];
    }
    
    NSString *mnc = [carrier mobileNetworkCode];
    if (mnc != nil){
        [cInfo appendString:mnc];
    }
    
    return cInfo;
}

+(NSString*) messageConfigs {
    NSMutableString* configs = [NSMutableString string];
    
    [MFMailComposeViewController canSendMail] ? [configs appendString:@"T"] : [configs appendString:@"F"];
    [MFMessageComposeViewController canSendText] ? [configs appendString:@"T"] : [configs appendString:@"F"];
    if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)]){
        [MFMessageComposeViewController canSendAttachments] ? [configs appendString:@"T"] : [configs appendString:@"F"];
    }
    if([MFMessageComposeViewController respondsToSelector:@selector(canSendSubject)]){
        [MFMessageComposeViewController canSendSubject] ? [configs appendString:@"T"] : [configs appendString:@"F"];
    }
    
    return configs;
}

+ (NSString*) buildRawString {
    NSMutableArray* rawComponents = [NSMutableArray array];
    
    [rawComponents addObject:[self getSysInfoByName:"hw.machine"]];
    [rawComponents addObject:[[UIDevice currentDevice] name]];
    [rawComponents addObject:[[UIDevice currentDevice] systemName]];
    [rawComponents addObject:[[UIDevice currentDevice] systemVersion]];
    [rawComponents addObject:[[UIDevice currentDevice] model]];
    [rawComponents addObject:[[NSTimeZone systemTimeZone] name]];
    [rawComponents addObject:[self diskSpace]];
    [rawComponents addObject:[[NSLocale autoupdatingCurrentLocale] localeIdentifier]];
    [rawComponents addObject:[self canOpenApps]];
    [rawComponents addObject:[self hasCydia]];
    [rawComponents addObject:[self languageList]];
    [rawComponents addObject:[self carrierInfo]];
    [rawComponents addObject:[self messageConfigs]];
    
    return [rawComponents componentsJoinedByString:@","];
}

+ (NSString*) dfid {
    NSString* rawString = [self buildRawString];
    NSLog(@"Raw aoi: %@", rawString);
    
    NSData *data = [rawString dataUsingEncoding: NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [NSString stringWithFormat:@"%@_%@", DFID_VERSION, output];
}

@end
