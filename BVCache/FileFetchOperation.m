//
//  FileFetchOperation.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "FileFetchOperation.h"
#import "NetworkModelManager.h"

@interface FileFetchOperation ()
@property (nonatomic, strong) NSString *urlString;
@end

@implementation FileFetchOperation

-(instancetype)initWithURLString:(NSString *)urlString CompletionBlock:(CompletionBlockNoParams)complete andErrorBlock:(ErrorBlockParam)error
{
    self = [super initWithCompletionBlock:complete andErrorBlock:error];
    if (self)
    {
        self.urlString = urlString;
    }
    return self;
}

-(void) main
{
    if([self checkIfOperationIsCancelled])
    {
        NSLog(@"Image download Operation was cancelled.");
        return;
    }
    
        NSData *data = [self fetchFileWithURL:self.urlString];
        
        if(data != nil)
        {
                [self performCompletionBlock:data];
        }
        else
        {
            [self performErrorBlock:nil];
        }
    
}

//Method to do the service call to server to login
-(NSData *)fetchFileWithURL:(NSString *)urlString
{
    //Create function call
    __block NSData *data = nil;
    __block CFRunLoopRef currentRefThread = CFRunLoopGetCurrent();
    CFRunLoopPerformBlock(currentRefThread, kCFRunLoopCommonModes, ^{
     
        NSURL *url = [NSURL URLWithString:urlString];
        data = [NSData dataWithContentsOfURL:url];
     
    });
    CFRunLoopWakeUp(currentRefThread);
    CFRunLoopRun();
    
    return data;
}


@end
