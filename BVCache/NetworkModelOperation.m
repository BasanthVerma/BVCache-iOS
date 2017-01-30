//
//  NetworkModelOperation.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "NetworkModelOperation.h"
#import <UIKit/UIKit.h>

#define DEFAULTNUMBEROFBYTESTORECEIVEBEFORENOTIFY 50000
#define ACCEPT_ENCODING                  @"Accept-Encoding"
#define CONTENT_ENCODING                 @"Content-Encoding"
#define CONTENT_LENGTH                   @"Content-Length"

@interface NetworkModelOperation() <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) id params;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign) BBNetworkOperationType requestType;

@end

@implementation NetworkModelOperation

{
    long long _notifySize;
}

- (instancetype)initWithURL:(NSURL *)url timeout:(NSTimeInterval)timeout parameters:(id)params requestType:(BBNetworkOperationType)requestType contentType:(NSString *)content
{
    self = [super init];
    if (self) {
        self.url = url;
        self.params = params;
        self.timeout = timeout;
        self.requestType = requestType;
        if(content == nil || [content isEqualToString:@""])
        {
            self.contentType = @"application/json";
        }
        else
        {
            self.contentType = content;
        }
        self.error = nil;
        self.sourceThread = [NSThread currentThread];
        self.numberOfBytesReceivedBeforeNotifying = DEFAULTNUMBEROFBYTESTORECEIVEBEFORENOTIFY;
    }
    return self;
}

- (void)main
{
    @try {
        self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:self.timeout];
        if (!self.request) {
            @throw [NSException exceptionWithName:@"Failed To create URL request" reason:[NSString stringWithFormat:@"Request URL: %@",self.url] userInfo:nil];
        }
        
        [self.request addValue:self.contentType forHTTPHeaderField:@"Content-Type"];
        [self.request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        
        NSData *jsonData;
        if (self.requestType == POST) {
            [self.request setHTTPMethod:@"POST"];
            if ([self.params isKindOfClass:[NSDictionary class]]) {
                jsonData = [NSJSONSerialization dataWithJSONObject:self.params options:kNilOptions error:nil];
            }
            if ([self.params isKindOfClass:[NSString class]]) {
                jsonData = [self.params dataUsingEncoding:NSUTF8StringEncoding];
                
            }
            
            [self.request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[jsonData length]] forHTTPHeaderField:CONTENT_LENGTH ];
            [self.request setHTTPBody:jsonData];
            
        }
        else {
            [self.request setHTTPMethod:@"GET"];
        }
        
        // Create the user-agent string to use
        NSString *userAgent = [NSString stringWithFormat:
                               @"Sarvint Client App %@ / IOS %@ / %@",
                               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                               [UIDevice currentDevice].systemVersion,
                               (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone"];
        [self.request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        
        [self.request setNetworkServiceType:NSURLNetworkServiceTypeBackground];
        [self.request setHTTPShouldUsePipelining:YES];
        if ([self.request respondsToSelector:@selector(setAllowsCellularAccess:)]) {
            [self.request setAllowsCellularAccess:YES];
        }
        
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.data = [NSMutableData data];
        [self.connection start];
        CFRunLoopRun();
        if (self.error != nil) {
            if (self.errorBlock != nil) {
                [self performErrorBlock:self.error];
            }
            return;
        }
        
        if (self.completeBlock!=nil) {
            [self performCompletionBlock:self.data];
        }
    }
    @catch(NSException *e) {
        self.data = nil;
        NSLog(@"%@",e.description);
    }
   self.errorBlock = nil;
   self.completeBlock = nil;
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _notifySize = 0;
    [self.data setLength:0];
    self.error = nil;
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    _notifySize += data.length;
    [self.data appendData:data];
    if (_notifySize > _numberOfBytesReceivedBeforeNotifying) {
        _notifySize = 0;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.data = nil;
    self.error = error;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSLog(@"Download failed! Error - %@ %@",[error localizedDescription], [error userInfo][NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end

