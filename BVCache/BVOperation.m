//
//  BVOperation.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "BVOperation.h"

@implementation BVOperation

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.sourceThread = [NSThread currentThread];
    }
    return self;
}

-(instancetype)initWithCompletionBlock:(CompletionBlockParam)complete andErrorBlock:(ErrorBlockParam)error
{
    self = [super init];
    if(self)
    {
        self.completeBlock = complete;
        self.errorBlock = error;
        self.sourceThread = [NSThread currentThread];
    }
    return self;
}

- (void)runCompletionBlock:(id)param
{
    if (self.completeBlock)
    {
        self.completeBlock(param);
    }
}

- (void)runErrorBlock:(id)param
{
    if (self.errorBlock)
    {
        self.errorBlock(param);
    }
}

- (void)performErrorBlock:(NSError *)errorParam
{
    if (self.errorBlock)
    {
        // If the source thread is the main thread, perform the selector on the main thread.
        // Otherwise just call the completion block directly
        if ([self.sourceThread isEqual:[NSThread mainThread]]) {
            [self performSelectorOnMainThread:@selector(runErrorBlock:) withObject:errorParam waitUntilDone:YES];
        }
        else {
            self.errorBlock(errorParam);
        }
        
    }
}

- (void)performCompletionBlock:(id)params
{
    if (self.completeBlock)
    {
        // If the source thread is the main thread, perform the selector on the main thread.
        // Otherwise just call the completion block directly
        if ([self.sourceThread isEqual:[NSThread mainThread]]) {
            [self performSelectorOnMainThread:@selector(runCompletionBlock:) withObject:params waitUntilDone:YES];
        }
        else {
            self.completeBlock(params);
        }
    }
}

- (BOOL)checkIfOperationIsCancelled
{
    if (!self.isCancelled)
    {
        return NO;
    }
    return YES;
}

- (BOOL)isRunningInBackground
{
    return ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground);
}


@end
