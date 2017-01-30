//
//  ListViewController.m
//  BVCache
//
//  Created by Basanth Verma on 12/07/16.
//  Copyright © 2016 Basanth Verma. All rights reserved.
//

#import "ListViewController.h"
#import "ListView.h"

@interface ListViewController ()
@property (nonatomic, strong) ListView *listView;
@end

@implementation ListViewController

-(void)loadView
{
    [self createUI];
}

-(void)createUI
{
    self.listView = [[ListView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.listView;
}

@end
