//
//  UIImageView+CachedImage.m
//  BVCache
//
//  Created by Basanth Verma on 30/01/17.
//  Copyright © 2017 Basanth Verma. All rights reserved.
//

#import "UIImageView+CachedImage.h"
#import "FileFetchService.h"
#import "BVCache.h"

@implementation UIImageView (CachedImage)

-(void)setCachedImage:(NSString *)url //toImageView:(UIImageView*)imageView
{
    if (url) {
        //If image already exists in cache, fetch from cache and set it
        if ([[BVCache sharedInstance] checkIfFileWithThisURLIsCached:url]) {
            [self setImage:[[BVCache sharedInstance] getImageForURLString:url]];
        }
        //Fetch, Cache and set the image
        else
            [[FileFetchService sharedInstance]fetchFileForURLString:url andSetToImageView:self];
    }
}

@end
