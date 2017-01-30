//
//  NetworkModelOperation.h
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVOperation.h"

typedef enum {
    POST = 0,
    GET
} BBNetworkOperationType;

@interface NetworkModelOperation : BVOperation

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSString *taskType,*contentType;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) NSUInteger numberOfBytesReceivedBeforeNotifying;

- (instancetype)initWithURL:(NSURL *)url timeout:(NSTimeInterval)timeout parameters:(id)params requestType:(BBNetworkOperationType)requestType contentType:(NSString *)content;

@end

