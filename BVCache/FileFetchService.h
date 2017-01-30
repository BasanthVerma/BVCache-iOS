//
//  FileFetchService.h
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileFetchService : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;
+ (instancetype)sharedInstance;
-(void)fetchFileForURLString:(NSString *)urlString andSetToImageView:(UIImageView*)imageView;
@end
