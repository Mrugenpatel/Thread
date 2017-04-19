//
//  MJViewController.h
//  03.Block引用
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef int (^MyBlock)(int a, int b); //使用typedef

@interface MJViewController : UIViewController

@property (nonatomic, copy) void (^viewDidScroll) (NSString *string);

@property (nonatomic, copy) int (^myBlock)(int a, int b); // 作为property


@property (nonatomic, copy) MyBlock myBlock2;

// 方法调用的参数
- (int)method2TakeBlock:(int (^) (int a, int b))block;

@end
