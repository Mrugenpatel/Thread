//
//  MJViewController.m
//  02.NSOperation
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"

@interface MJViewController ()

@property (nonatomic, strong) NSOperationQueue *myQueue;

@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myQueue = [[NSOperationQueue alloc] init];
    
    [self demoOp2];
}

- (void)demoOp:(id)obj
{
    NSLog(@"%@ - %@", [NSThread currentThread], obj);
}

#pragma mark - NSOperation方法
#pragma mark 设置任务的执行顺序
- (void)demoOp3
{
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片 %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"修饰图片 %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"保存图片 %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"更新UI %@", [NSThread currentThread]);
    }];
    
    // 设定执行顺序, Dependency依赖，可能会开多个，但不会太多
    // 依赖关系是可以跨队列的！
    [op2 addDependency:op1];
    [op3 addDependency:op2];
    [op4 addDependency:op3];
    // GCD是串行队列，异步任务，只会开一个线程
    
    [self.myQueue addOperation:op1];
    [self.myQueue addOperation:op2];
    [self.myQueue addOperation:op3];
    // 所有UI的更新需要在主线程上进行
    [[NSOperationQueue mainQueue] addOperation:op4];
}

#pragma mark NSInvocationOP
- (void)demoOp2
{
    // 需要定义一个方法，能够接收一个参数
    // 是用起来不够灵活
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(demoOp:) object:@"hello op"];
    
//    [self.myQueue addOperation:op];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark NSBlockOperation
- (void)demoOp1
{
//    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"%@", [NSThread currentThread]);
//    }];
//    
    // 所有的自定义队列，都是在子线程中运行
//    [self.myQueue addOperation:block];
    
    // 新建线程是有开销的
    // 在设定同时并发的最大线程数时，如果前一个线程工作完成，但是还没有销毁，会新建线程
    // 应用场景：网络开发中，下载工作！（线程开销：CPU,MEM）电量！
    // 如果是3G，开3个子线程
    // 如果是WIFI，开6个子线程
    
    for (int i = 0; i < 10; ++i) {
        [self.myQueue addOperationWithBlock:^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
        }];
    }
    
    // 在主线程中执行
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        NSLog(@"%@", [NSThread currentThread]);
//    }];
}

@end
