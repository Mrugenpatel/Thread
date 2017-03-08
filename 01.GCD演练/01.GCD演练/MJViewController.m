//
//  MJViewController.m
//  01.GCD演练
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"

@interface MJViewController ()

@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", [NSThread currentThread]);
    
    //[self gcdSyncDemo];
    [self gcdDemo1];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch me");
}

#pragma mark - GCD方法
#pragma mark 同步任务的阻塞
- (void)gcdSyncDemo
{
    dispatch_queue_t q = dispatch_queue_create("cn.itcast.gcddemo", DISPATCH_QUEUE_SERIAL);
    
    // 任务嵌套
    dispatch_sync(q, ^{
        NSLog(@"sync %@", [NSThread currentThread]);
        
        // 耗时的任务，同步里面包含同步，会造成阻塞
//        dispatch_sync(q, ^{
        // 永远也不会执行到
//            NSLog(@"async %@", [NSThread currentThread]);
//        });
    });
}

#pragma mark - 主(线程)队列，保证操作在主线程上执行
- (void)gcdDemo4
{
    // 每一个应用程序都只有一个主线程
    // 为什么需要在主线程上工作呢？
    // 在iOS开发中，所有UI的更新工作，都必须在主线程上执行！
    dispatch_queue_t q = dispatch_get_main_queue();
    
    // 主线程是由工作的，而且除非将程序杀掉，否则主线程的工作永远不会结束！
    // 阻塞了！！！
    dispatch_sync(q, ^{
        NSLog(@"come here baby!");
    });
    
    // 异步任务，在主线程上运行，同时是保持队形的
    for (int i = 0; i < 10; ++i) {
        dispatch_async(q, ^{
            NSLog(@"%@ - %d", [NSThread currentThread], i);
        });
    }
}

#pragma mark - 全局队列（苹果为了方便多线程的设计，提供一个全局队列，供所有的APP共同使用）
- (void)gcdDemo3
{
    // 全局队列与并行队列的区别
    // 1> 不需要创建，直接GET就能用
    // 2> 两个队列的执行效果相同
    // 3> 全局队列没有名称，调试时，无法确认准确队列
    
    // 记住：在开发中永远用DISPATCH_QUEUE_PRIORITY_DEFAULT
    // 多线程的优先级反转！低优先级的线程阻塞了高优先级的线程！
    dispatch_queue_t q =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (int i = 0; i < 10; ++i) {
        // 同步任务顺序执行
        dispatch_sync(q, ^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
        });
    }
    
    for (int i = 0; i < 10; ++i) {
        // 异步任务，并发执行，但是如果在穿行队列中，仍然会依次顺序执行
        dispatch_async(q, ^{
            // [NSThread currentThread] 可以在开发中，跟踪当前线程
            // num = 1，表示主线程
            // num = 2，表示第2个子线程。。。
            NSLog(@"%@ %d", [NSThread currentThread], i);
        });
    }
}

#pragma mark - 串行（一个接一个，排队跑步，保持队形）队列
- (void)gcdDemo1
{
    // 将操作放在队列中
    // 在C语言函数中，定义类型，绝大多数的结尾是_t或者ref
    // 使用串行队列，的异步任务非常非常非常有用！新建子线程是有开销的，不能无休止新建线程
    // 即可以保证效率（新建一个子线程），用能够实现并发
    // 应用案例：
    // 1> 从网络上上下载图片
    // 2> 滤镜（高光，红眼...）
    
    dispatch_queue_t q = dispatch_queue_create("cn.itcast.gcddemo", DISPATCH_QUEUE_SERIAL);
    
    // 非ARC开发时，千万别忘记release
//    dispatch_release(q);
    
    // 串行行队列的同步任务，同样会在主线程上运行
    // 提示：在开发中极少用d
    // 面试中有可能会问！
    for (int i = 0; i < 10; ++i) {
        // 同步任务顺序执行
        dispatch_sync(q, ^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
        });
    }
    
    for (int i = 0; i < 10; ++i) {
        // 异步任务，并发执行，但是如果在串行队列中，仍然会依次顺序执行
        dispatch_async(q, ^{
            // [NSThread currentThread] 可以在开发中，跟踪当前线程
            // num = 1，表示主线程
            // num = 2，表示第2个子线程。。。
            NSLog(@"%@ %d", [NSThread currentThread], i);
        });
    }
}

#pragma mark - 并行（并排跑，类似于赛跑）
- (void)gcdDemo2
{
    // 特点：没有队形，执行顺序程序员不能控制！
    // 应用场景：并发执行任务，没有先后顺序关系
    // 并行队列容易出错！并行队列不能控制新建线程的数量！
    dispatch_queue_t q = dispatch_queue_create("cn.itcast.gcd2", DISPATCH_QUEUE_CONCURRENT);
    
//    for (int i = 0; i < 10; ++i) {
//        // 异步任务
//        dispatch_async(q, ^{
//            // [NSThread currentThread] 可以在开发中，跟踪当前线程
//            // num = 1，表示主线程
//            // num = 2，表示第2个子线程。。。
//            NSLog(@"%@ %d", [NSThread currentThread], i);
//        });
//    }
    
    for (int i = 0; i < 10; ++i) {
        // 同步任务顺序执行
        dispatch_sync(q, ^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
        });
    }
}

@end
