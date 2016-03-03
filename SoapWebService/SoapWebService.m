//
//  SoapWebService.m
//
//  Created by wangjie on 15/4/29.
//  Copyright (c) 2015年 wangjie. All rights reserved.
//

#import "SoapWebService.h"

@implementation SoapWebService

+(NSString*)webServicePostAsync:(NSString *)postUrl withMethodName:(NSString*) methodName withParas:(NSDictionary *) parasdic
{
    return [self webServicePostAsync:postUrl withMethodName:methodName withParas:parasdic Sync:true Success:nil falure:nil];
}

+(NSString*)webServicePostAsync:(NSString *)postUrl withMethodName:(NSString*) methodName withParas:(NSDictionary *) parasdic Sync:(BOOL)isSync Success:(SuccessBlock)success falure:(FailureBlock)falure
{
    NSString* wsdlSuffix=@"?wsdl";
    NSString* urlString=[postUrl lowercaseString];
    if([urlString hasSuffix:wsdlSuffix])
    {
        postUrl=[postUrl substringWithRange:NSMakeRange(0,postUrl.length-wsdlSuffix.length)];
    }
    SoapService *soaprequest=[[SoapService alloc] init];
#if !__has_feature(objc_arc)
    [soaprequest autorelease];
#endif
    soaprequest.PostUrl=postUrl;
    BOOL bContine=true;
    if( nil == wsdl_content || 0 == wsdl_content.length )
    {
        ResponseData *result=[soaprequest GetWSDL];
        if (result.StatusCode==200) {
            wsdl_content=result.Content;
            bContine=true;
        }
        else
        {
            bContine=false;
        }
    }
    if(bContine && (nil != wsdl_content || 0 != wsdl_content.length ))
    {
        
        SoapUtility *soaputility=[[SoapUtility alloc] initFromString:wsdl_content];
#if !__has_feature(objc_arc)
        [soaputility autorelease];
#endif
        soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
        NSString *postData=[soaputility BuildSoapwithMethodName:methodName withParas:parasdic];
        if (isSync) {
            //同步方法
            ResponseData *result= [soaprequest PostSync:postData];
            if (result.StatusCode==200) {
                return result.Content;
            }
        }
        else{
            //异步请求
            [soaprequest PostAsync:postData Success:^(NSString *response) {
                if(nil!=success)
                {
                    success(response);
                }
            } falure:^(NSError *response) {
                if(nil!=success)
                {
                    falure(response);
                }
            }];
        }
    }
    return nil;
}

//+(void)webServicePostAsync:(NSString *)postData Success:(SuccessBlock)success falure:(FailureBlock)falure
//{
//
//    NSDictionary *dic=@{@"theCityName": cityname};
//    NSString *methodName=@"getWeatherbyCityName";
//
//    //WSDL文件，放在程序中（名件名为WebService）
//    SoapUtility *soaputility=[[SoapUtility alloc] initFromFile:@"WebService"];
//    NSString *postData=[soaputility BuildSoapwithMethodName:methodName withParas:dic];
//
//    SoapService *soaprequest=[[SoapService alloc] init];
//    soaprequest.PostUrl=@"http://218.94.15.118:9090/wrm_service/services/WRM_Service";
//    soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
//
//    if (isSync) {
//        //同步方法
//        ResponseData *result= [soaprequest PostSync:postData];
//        [self.result setText:result.Content];
//    }
//    else{
//        //异步请求
//        [soaprequest PostAsync:postData Success:^(NSString *response) {
//            [self.result setText:response];
//        } falure:^(NSError *response) {
//            [self.result setText:response.description];
//        }];
//    }
//}

@end
