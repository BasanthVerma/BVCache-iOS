//
//  FileFetchOperation.h
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "BVOperation.h"

@interface FileFetchOperation :  BVOperation
-(instancetype)initWithURLString:(NSString *)urlString CompletionBlock:(CompletionBlockNoParams)complete andErrorBlock:(ErrorBlockParam)error;
@end
