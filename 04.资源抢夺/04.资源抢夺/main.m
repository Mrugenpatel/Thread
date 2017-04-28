//
//  main.m
//  04.资源抢夺
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJAppDelegate.h"

int main(int argc, char * argv[])
{
    
    @autoreleasepool {
//        dispatch_sync(dispatch_get_main_queue(), ^(void){
//            NSLog(@"这里死锁了");
//        });
        /*
         我们把整个dispatch_sync看作是一个任务，比如说是非常关键、需要高度集中注意力的运钞过程。这个过程非常重要，一旦开始执行就必须一气呵成，任何事情都不能干扰这个过程（阻塞线程）。
         
         现在主线程开始执行这个运钞任务，任务执行到一半时，突然运钞员说我好累啊，辛苦了好久了，我现在需要休息（向主线程添加了block）。运钞员天真的认为，我知道运钞这个事很重要，本来应该等到运钞结束后再休息（这样是串行）。但是在这之前，我的身体条件不允许工作。
         
         但是之前已经说了，运钞这件事很重要，它一旦开始就不能结束（阻塞线程）。怎么能允许有人中途休息呢，因此要休息可以（block是可以执行的），先把钞票运到安全地方再休息。
         
         对应到代码里面来，当我们想要同步执行这个block的时候，其实是告诉主线程，你把事情处理完了，就过来处理我这个blcok，在此之前我一直等你。而主线程呢，刚处理dispatch_sync函数到一半呢，这个函数还没返回，哪里有空去执行block。因此这段代码运行后，并非卡在block中无法返回，而是根本无法执行到这个block。
         */
    }
    
    dispatch_async(dispatch_get_global_queue(0,0), ^(void){
        NSLog(@"这就不死锁了");
    });
    
    /*
     所以接下来就只需要重点思考一下，在同步执行时，什么时候会导致死锁。可以再得出一个结论，向并发队列中添加block不会导致死锁。再次回顾一下之前导致的死锁的原因，由于在串行队列中添加了block，block一直等到前面的任务处理完才会执行，从而导致了死锁。现在即使是同步的向并发队列中添加block，GCD会自动为我们管理线程，主线程目前阻塞着（处理这个同步方法），那就新建一个新的线程，但无论如何这个被添加block迟早都会被执行。而所有添加的block被执行完后，同步方法也就返回了。因此不会导致死锁。
     */
    
    /*
    最后再来讨论一下用同步方法向串行队列添加block的情况，这种情况下会不会造成死锁呢，答案是不一定。事实上，导致死锁的原因一定是：
    
    在某一个串行队列中，同步的向这个队列添加block。
    
    比如文章开头的例子就属于这种情况。如果同步的向另外一个串行队列添加方法，并不一定导致死锁。比如：
    */
    dispatch_queue_t queue = dispatch_queue_create("serial", nil);
    dispatch_sync(queue, ^(void){
        NSLog(@"这个也不会死锁");
    });
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MJAppDelegate class]));
    }
}
