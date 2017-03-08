//
//  DemoObj.m
//  05.单例
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "DemoObj.h"

@implementation DemoObj

static DemoObj *instance;

/**
 1. 重写allocWithZone，用dispatch_once实例化一个静态变量
 2. 写一个+sharedXXX方便其他类调用
 */

// 在iOS中，所有对象的内存空间的分配，最终都会调用allocWithZone方法
// 如果要做单例，需要重写此方法
// GCD提供了一个方法，专门用来创建单例的
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static DemoObj *instance;
    
    // dispatch_once是线程安全的，onceToken默认为0
    static dispatch_once_t onceToken;
    // dispatch_once宏可以保证块代码中的指令只被执行一次
    dispatch_once(&onceToken, ^{
        // 在多线程环境下，永远只会被执行一次，instance只会被实例化一次
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

// 这种单例方法虽然简单，但有问题
+ (instancetype)sharedDemoObj
{
    // 如果有两个线程同时实例化，很有可能创建出两个实例来
//    if (!instance) {
//        // thread 1 0x0000A
//        // thread 2 0x0000B
//        instance = [[self alloc] init];
//    }
//    // 第一个线程返回的指针已经被修改！
//    return instance;
    return [[self alloc] init];
}

@end
