//
//  MJViewController.m
//  03.Block引用
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

    DemoObj *obj = [[DemoObj alloc] init];
    [obj demoBlockOp];
    
    [self executeAction];
}

- (void ) executeAction {
    
    self.viewDidScroll(@"111");
    
}

@end
