//
//  MJViewController.m
//  05.单例
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"
#import "DemoObj.h"

@interface MJViewController ()

@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    DemoObj *obj = [[DemoObj alloc] init];
//    NSLog(@"%@", obj);
    NSLog(@"%@", [DemoObj sharedDemoObj]);
    
}

@end
