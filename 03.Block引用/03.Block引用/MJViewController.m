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
    
    
    
    //作为property
    _myBlock = ^int (int a, int b) {
        return a + b;
    };  // Block初始化
    
    int sum = _myBlock(10, 20);
    
    // typedef
    MyBlock myBlock = ^int (int a, int b) {
        return a * b;
    };
    int sum1 = myBlock(10, 20);
    
    // 作为变量
    __block int sum2 = 0;
    int (^myBlock3)(int a, int b) = ^int (int a, int b) {
        sum2 = a + b;
        return sum2;
    };
    sum2 = myBlock(10, 20);
    
    // Block作为参数
    int sum3 = [self methodTakeBlock:^int (int a, int b) {
        return b / a;
    }];
    
    // 在方法声明中用Block
   int sum4 = [self method2TakeBlock:^int(int a, int b) {
        return a * b - b;
    }];
    
    //[self executeAction];
    
    
    NSLog(@"");
}

- (void ) executeAction {
    
    self.viewDidScroll = ^(NSString *string) {  //Block初始化
        NSLog(@"测试%@",string);
    };
    
    if (self.viewDidScroll) {
        self.viewDidScroll(@"111");
    }
    
}

// 方法调用的参数
- (int)method2TakeBlock:(int (^)(int, int))block {
    int sum = 0;
    if (block) {
        sum = block(10, 20);
    }
    return sum;
}



- (int)methodTakeBlock:(MyBlock)block {
    int sum = 0;
    if (block) {
        sum = block(10, 20);
    }
    return sum;
}

@end
