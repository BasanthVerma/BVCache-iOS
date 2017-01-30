//
//  BVCache.h
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVCache : NSObject

@property (nonatomic, strong) NSCache *appCache;

+(BVCache*)sharedInstance;

///Caches file with data and its url
-(void)cacheFileWithData:(NSData *)fileData andURLString:(NSString*)urlString;

///To check if file is already cached
-(BOOL)checkIfFileWithThisURLIsCached:(NSString*)urlString;

///Returns Image from Cache, before sure to check first! It is Nullable.
-(UIImage *)getImageForURLString:(NSString *)urlString;
@end
