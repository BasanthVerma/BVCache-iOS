//
//  AppCommons.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//


// Typedefs
typedef void (^CompletionBlockNoParams)();
typedef void (^CompletionBlockParam)(id param);
typedef void (^ErrorBlockParam)(id param);

#define SUCCES_CODE                                 200
#define UN_AUTHERIZED_CODE                          401
#define kNotifyNetworkAvailabilityChanged           @"networkAvailabilityChanged"

#define CACHED_FILES_LIMIT 100
