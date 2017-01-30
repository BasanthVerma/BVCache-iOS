//
//  FileFetchService.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "FileFetchService.h"
#import "FileFetchOperation.h"
#import "NetworkModelManager.h"
#import "BVCache.h"

static FileFetchService *fileFetchServiceSharedInstance = nil;

@implementation FileFetchService

#pragma mark - Class methods
+ (instancetype)sharedInstance
{
    if (fileFetchServiceSharedInstance == nil) {
        fileFetchServiceSharedInstance = [[FileFetchService alloc] init];
    }
    return fileFetchServiceSharedInstance;
}

#pragma mark - Instance methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.name = @"com.BVCache.filefetcherqueue";
        _operationQueue.maxConcurrentOperationCount = 6;
    }
    return self;
}

-(void)fetchFileForURLString:(NSString *)urlString andSetToImageView:(UIImageView*)imageView
{
    if(([UIApplication sharedApplication].applicationState == UIApplicationStateBackground))
    {
        return;
    }

    FileFetchOperation *fetchOp = [[FileFetchOperation alloc] initWithURLString:urlString CompletionBlock:^(NSData *data){
        //Cache it
        [[BVCache sharedInstance] cacheFileWithData:data andURLString:urlString];
        [imageView setImage:[UIImage imageWithData:data]];
        
    } andErrorBlock:^(id param) {
        NSLog(@"Image not found or there was an error in downloading");
    }];
    
    [self.operationQueue addOperation:fetchOp];
}

- (void)stopService:(NSNotification *)notificaiton
{
    [self.operationQueue cancelAllOperations];
}

- (void)pauseService:(NSNotification *)notification
{
    [self.operationQueue cancelAllOperations];
}

@end
