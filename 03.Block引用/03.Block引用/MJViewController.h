//
//  MJViewController.h
//  03.Block引用
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJViewController : UIViewController

@property (nonatomic, copy) void (^viewDidScroll)(NSString *string);

@end
