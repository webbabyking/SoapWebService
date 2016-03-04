//
//  SoapService.m
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//
#import "SoapService.h"
#import <UIKit/UIKit.h>


@implementation ResponseData 

@end


@implementation SoapService



-(id)initWithPostUrl:(NSString *)url SoapAction:(NSString *)soapAction{
    self=[super init];
    if(self){
        self.PostUrl=url;
        self.SoapAction=soapAction;
    }
    return self;
}

-(ResponseData *)PostSync:(NSString *)postData{
    NSMutableURLRequest *request=[self CreateRequest:postData];
    ResponseData *result=[[ResponseData alloc] init];
    if([self getOSVersion]>=9.0){
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            result.StatusCode=httpResponse.statusCode;
            result.Content=@"";
            if ([data length] > 0 && error == nil) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"ResponseString = %@",responseString);
                result.Content=responseString;
            }else if ([data length] == 0 && error == nil){
                NSLog(@"Nothing was downloaded.");
            }else if (error != nil){
                NSLog(@"Error happened = %@",error);
            }
            dispatch_semaphore_signal(sema);
        }];
        [task resume];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        // Response对象，用来得到返回后的数据，比如，用statusCode==200 来判断返回正常
        NSHTTPURLResponse *response;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:&response error:nil];
        // 处理返回的数据
        NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        result.StatusCode=response.statusCode;
        result.Content=strReturn;
    }
    return result;
}

-(void)PostAsync:(NSString *)postData Success:(SuccessBlock)success falure:(FailureBlock)failure{
    NSMutableURLRequest *request=[self CreateRequest:postData];
    if([self getOSVersion]>=9.0){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if ([data length] > 0 && error == nil) {
                //            NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                //            NSString *filePath = [documentsDir stringByAppendingPathComponent:@"apple.html"];
                //            [data writeToFile:filePath atomically:YES];
                //            NSLog(@"Successfully saved the file to %@",filePath);
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"ResponseString = %@",responseString);
                success(responseString);
            }else if ([data length] == 0 && error == nil){
                NSLog(@"Nothing was downloaded.");
                success(@"");
            }else if (error != nil){
                NSLog(@"Error happened = %@",error);
                failure(error);
            }
        }];
        [task resume];
    }else {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] > 0 && connectionError == nil) {
                //            NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                //            NSString *filePath = [documentsDir stringByAppendingPathComponent:@"apple.html"];
                //            [data writeToFile:filePath atomically:YES];
                //            NSLog(@"Successfully saved the file to %@",filePath);
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"ResponseString = %@",responseString);
                success(responseString);
            }else if ([data length] == 0 && connectionError == nil){
                NSLog(@"Nothing was downloaded.");
                success(@"");
            }else if (connectionError != nil){
                NSLog(@"Error happened = %@",connectionError);
                failure(connectionError);
            }
        }];
    }

}



-(NSMutableURLRequest *)CreateRequest:(NSString *)postData{
    // 要请求的地址
    NSString *urlString=self.PostUrl;
    // 将地址编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // 实例化NSMutableURLRequest，并进行参数配置
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    if(self.Timeout){
        [request setTimeoutInterval: self.Timeout];
    }else{
        [request setTimeoutInterval: 30];
    }
    if(self.SoapAction){
        [request addValue:self.SoapAction forHTTPHeaderField:@"SOAPAction"];
    }
    if(self.ContentType){
        [request addValue:self.ContentType forHTTPHeaderField:@"Content-Type"];
    }else{
        [request addValue:@"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }
    if(self.UserAgent){
        [request addValue:self.UserAgent forHTTPHeaderField:@"User-Agent"];
    }else{
        [request addValue:@"IOS App (power by elliott)" forHTTPHeaderField:@"User-Agent"];
    }
    if(self.AcceptEncoding){
        [request addValue:self.AcceptEncoding forHTTPHeaderField:@"Accept-Encoding"];
    }
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


-(ResponseData *)GetWSDL{
    NSMutableURLRequest *request=[self CreateGetWSDLRequest];
    ResponseData *result=[[ResponseData alloc] init];
    if([self getOSVersion]>=9.0){
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            result.StatusCode=httpResponse.statusCode;
            result.Content=@"";
            if ([data length] > 0 && error == nil) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"ResponseString = %@",responseString);
                result.Content=responseString;
            }else if ([data length] == 0 && error == nil){
                NSLog(@"Nothing was downloaded.");
            }else if (error != nil){
                NSLog(@"Error happened = %@",error);
            }
            dispatch_semaphore_signal(sema);
        }];
        [task resume];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        // Response对象，用来得到返回后的数据，比如，用statusCode==200 来判断返回正常
        NSHTTPURLResponse *response;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:&response error:nil];
        // 处理返回的数据
        NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        result.StatusCode=response.statusCode;
        result.Content=strReturn;

    }
    
    return result;
}

-(NSMutableURLRequest *)CreateGetWSDLRequest{
    // 要请求的地址
    NSString *urlString=self.PostUrl;
    urlString=[urlString lowercaseString];
    if(![urlString hasSuffix:@"wsdl"])
    {
        urlString=[self.PostUrl stringByAppendingString:@"?wsdl"];
    }
    else
    {
        urlString=self.PostUrl;
    }
    // 将地址编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // 实例化NSMutableURLRequest，并进行参数配置
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    if(self.Timeout){
        [request setTimeoutInterval: self.Timeout];
    }else{
        [request setTimeoutInterval: 30];
    }
    if(self.ContentType){
        [request addValue:self.ContentType forHTTPHeaderField:@"Content-Type"];
    }else{
        [request addValue:@"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }
    if(self.AcceptEncoding){
        [request addValue:self.AcceptEncoding forHTTPHeaderField:@"Accept-Encoding"];
    }
    
    [request setHTTPMethod:@"GET"];
    
    return request;
}

- (double) getOSVersion{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    return version;
}

@end
