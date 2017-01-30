//
//  BVAyscDownloader.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "BVAyscDownloader.h"

@implementation BVAyscDownloader

-(void)downloadFileWithURLString:(NSString *)urlString
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *downloadedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        if (downloadedData) {
            // STORE IN MEMORY
            [[BVCache sharedInstance]  cacheFileWithData:downloadedData andURLString:urlString];
        }
        
    });
    
}

@end
