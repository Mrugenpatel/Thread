//
//  DemoObj.h
//  05.单例
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoObj : NSObject

// 共享实例，便于其他类访问
+ (instancetype)sharedDemoObj;

@end
