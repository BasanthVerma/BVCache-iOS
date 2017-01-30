//
//  NetworkModelManager.h
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkModelManager : NSOperationQueue
@property (nonatomic, readonly) BOOL networkAvailable;
@property (nonatomic, readonly) BOOL wWANAvailable;
@property (nonatomic, readonly) BOOL localWANAvailable;

+ (instancetype)sharedInstance;

+ (void)get:(NSURL *)url completionBlock:(CompletionBlockParam)complete errorBlock:(ErrorBlockParam)error;
+ (void)postDictionary:(NSURL *)url parameters:(NSDictionary *)params contentType:(NSString *)content completionBlock:(CompletionBlockParam)completion errorBlock:(ErrorBlockParam)error;
+ (void)postString:(NSURL *)url parameters:(NSString *)params contentType:(NSString *)content completionBlock:(CompletionBlockParam)completion errorBlock:(ErrorBlockParam)error;

- (BOOL)canShutDown;

@end
