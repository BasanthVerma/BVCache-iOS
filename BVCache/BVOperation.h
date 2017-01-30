//
//  BVOperation.h
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVOperation : NSOperation

@property (nonatomic, copy) CompletionBlockParam completeBlock;
@property (nonatomic, copy) ErrorBlockParam errorBlock;
@property (nonatomic, strong) NSThread *sourceThread;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSNumber *userId;

- (void)performErrorBlock:(NSError *)errorParam;
- (void)performCompletionBlock:(id)params;
- (BOOL)checkIfOperationIsCancelled;
- (BOOL)isRunningInBackground;
-(instancetype)initWithCompletionBlock:(CompletionBlockParam)complete andErrorBlock:(ErrorBlockParam)error;
@end
