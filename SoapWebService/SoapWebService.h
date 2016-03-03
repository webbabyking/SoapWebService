//
//  SoapWebService.h
//
//  Created by wangjie on 15/4/29.
//  Copyright (c) 2015年 wangjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoapUtility.h"
#import "SoapService.h"

//WEB WSDL内容
static NSString *wsdl_content=@"";

@interface SoapWebService : NSObject

+(NSString*)webServicePostAsync:(NSString *)postUrl withMethodName:(NSString*) methodName withParas:(NSDictionary *) parasdic;
+(NSString*)webServicePostAsync:(NSString *)postUrl withMethodName:(NSString*) methodName withParas:(NSDictionary *) parasdic Sync:(BOOL)isSync Success:(SuccessBlock)success falure:(FailureBlock)falure;

@end