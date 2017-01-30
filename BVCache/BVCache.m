//
//  BVCache.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "BVCache.h"

BVCache *sharedCache = nil;

@implementation BVCache

+(BVCache*)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        if (sharedCache==nil) {
            sharedCache = [[BVCache alloc]init];
            sharedCache.appCache = [[NSCache alloc] init];
            [sharedCache.appCache setCountLimit:CACHED_FILES_LIMIT];
            [sharedCache.appCache setEvictsObjectsWithDiscardedContent:NO];
        }
    });
    return sharedCache;
}

-(void)cacheFileWithData:(NSData *)fileData andURLString:(NSString*)urlString
{
    [_appCache setObject:fileData forKey:urlString];
}

-(BOOL)checkIfFileWithThisURLIsCached:(NSString*)urlString
{
    return ([self.appCache objectForKey:urlString]!=nil) ? YES : NO;
}

-(UIImage *)getImageForURLString:(NSString *)urlString
{
    return [self.appCache objectForKey:urlString];
}

@end
