//
//  MFStoreHelper.m
//  PatPat
//
//  Created by patpat on 2018/12/27.
//  Copyright © 2018 http://www.patpat.com. All rights reserved.
//

#import "MFStoreHelper.h"
#import "SFHFKeychainUtils.h"

static NSString * const kServiceDomain                     = @"com.interfocusllc.patpat";

@implementation MFStoreHelper

+(void)storeValue:(id)value forKey:(NSString *)key
{
    key = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingFormat:@".%@",key];
    NSUserDefaults *defaultsSetting = [NSUserDefaults standardUserDefaults];
    if (value==nil) {
        [defaultsSetting removeObjectForKey:key];
    }else{
        [defaultsSetting setValue:value forKey:key];
    }
    [defaultsSetting synchronize];
}

+(id)getValueForKey:(NSString *)key
{
    if (key == nil)return nil;
    key = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingFormat:@".%@",key];
    NSUserDefaults *defaultsSetting = [NSUserDefaults standardUserDefaults];
    return [defaultsSetting valueForKey:key];
}

+(void)systemStoreValue:(NSString *)value
                 forKey:(NSString *)key
{
    if (![value isKindOfClass:[NSString class]]) {
        if ([SFHFKeychainUtils deleteItemForUsername:key andServiceName:kServiceDomain error:nil withAccessible:YES]){
            NSLog(@"删除kechain信息成功！");
        }else{
            NSLog(@"删除kechain信息失败！");
        }
    }else{
        if ([SFHFKeychainUtils storeUsername:key
                                 andPassword:value
                              forServiceName:kServiceDomain
                              updateExisting:true
                                       error:nil]){
            NSLog(@"保存信息到kechain成功！");
        }else{
            NSLog(@"保存信息到kechain失败！");
        };
    }
}

+ (id)getSystemValueForKey:(NSString *)key
{
    return [SFHFKeychainUtils getPasswordForUsernameOld:key andServiceName:kServiceDomain error:nil];
}


@end
