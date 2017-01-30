//
//  ListView.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "ListView.h"
#import "UIImageView+CachedImage.h"

@interface ListView ()
@property (nonatomic, strong)   UIImageView *demoImageView;
@end

@implementation ListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _demoImageView = [[UIImageView alloc]init];
        //Replace url below to try out your example urls
        [_demoImageView setCachedImage:@"https://www.google.co.in/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"];
        [self addSubview:_demoImageView];

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.demoImageView.frame = CGRectMake(0, 0, 200, 100);
    self.demoImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

@end
