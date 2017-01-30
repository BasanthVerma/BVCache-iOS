//
//  NetworkModelManager.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "NetworkModelManager.h"
#import "Reachability.h"
#import "NetworkModelOperation.h"
#import <UIKit/UIKit.h>

#define REACHABILITYCHECKADDRESS @"www.google.com"
#define DEFAULTNETWORKTIMEOUT 60.0

static NetworkModelManager *nwInstance;
@interface NetworkModelManager()
@property (nonatomic, strong) Reachability *reachability;
@end

@implementation NetworkModelManager
+ (instancetype)sharedInstance
{
    if (nwInstance == nil) {
        nwInstance = [[NetworkModelManager alloc] init];
    }
    return nwInstance;
}

+ (void)get:(NSURL *)url completionBlock:(CompletionBlockParam)complete errorBlock:(ErrorBlockParam)error
{
    NetworkModelOperation *operation = [[NetworkModelOperation alloc] initWithURL:url timeout:DEFAULTNETWORKTIMEOUT parameters:nil requestType:GET contentType:nil];
    operation.completeBlock = complete;
    operation.errorBlock = error;
    
    [[NetworkModelManager sharedInstance] addOperation:operation];
    
}

+ (void)postDictionary:(NSURL *)url parameters:(NSDictionary *)params contentType:(NSString *)contentType completionBlock:(CompletionBlockParam)completion errorBlock:(ErrorBlockParam)error
{
    NetworkModelOperation *operation = [[NetworkModelOperation alloc] initWithURL:url
                                                                          timeout:DEFAULTNETWORKTIMEOUT
                                                                       parameters:params
                                                                      requestType:POST
                                                                      contentType:contentType];
    operation.completeBlock = completion;
    operation.errorBlock = error;
    
    [[NetworkModelManager sharedInstance] addOperation:operation];
    
}

+ (void)postString:(NSURL *)url parameters:(NSString *)params contentType:(NSString *)contentType completionBlock:(CompletionBlockParam)completion errorBlock:(ErrorBlockParam)error
{
    NetworkModelOperation *operation = [[NetworkModelOperation alloc] initWithURL:url
                                                                          timeout:DEFAULTNETWORKTIMEOUT
                                                                       parameters:params
                                                                      requestType:POST
                                                                      contentType:contentType];
    operation.completeBlock = completion;
    operation.errorBlock = error;
    [[NetworkModelManager sharedInstance] addOperation:operation];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setName:@"com.BVCache.networkqueue"];
        [self setMaxConcurrentOperationCount:5];
        _networkAvailable = NO;
        _wWANAvailable = NO;
        _localWANAvailable = NO;
        
        [self registerForNotifications];
        
        _reachability = [Reachability reachabilityWithHostname:REACHABILITYCHECKADDRESS];
        _reachability.reachableOnWWAN = YES; // Ensure we can reach via 3G/Edge/CDMA
        [_reachability startNotifier];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterForNotifications];
}

#pragma mark - Notificaitons
- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    _networkAvailable = _reachability.isReachable;
    if (_networkAvailable)
    {
        _wWANAvailable = _reachability.isReachableViaWWAN;
        _localWANAvailable = _reachability.isReachableViaWiFi;
    }
    else
    {
        _wWANAvailable = _localWANAvailable = NO;
    }
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyNetworkAvailabilityChanged object:_reachability];
    }
}

- (BOOL)canShutDown
{
    return (self.operationCount==0) ? YES : NO;
}

- (void)shutdown
{
    [self cancelAllOperations];
    while (!self.canShutDown) {
        [NSThread sleepForTimeInterval:.25];
    }
}
@end

