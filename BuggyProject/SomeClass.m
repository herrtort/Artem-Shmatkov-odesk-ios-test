//
//  SomeClass.m
//  BuggyProject
//  Copyright (c) 2014 oDesk Corporation. All rights reserved.
//

#import "SomeClass.h"

@implementation SomeClass

+ (void)printTextInMain:(NSString *)someText {
    // Bug#1
    // dispatch_sync(dispatch_get_main_queue(), ^{
    //     NSLog(@"%@", someText);
    // });
    
    // FIX:
    // When calling dispatch_sync on a queue, always verify that this queue is not already the current queue (dispatch_get_current_queue()). Because dispatch_sync will queue your block on the queue passed as the first parameter, and then will wait for this block to be executed before continuing.
    //        
    // So if the dispatch_get_current_queue() and the queue on which you enqueue your block are the same, namely the main queue in your case, the main queue will block on the call to dispatch_sync until… the main queue as executed the block, but it can't, as the queue is blocked, and you have a beautiful deadlock here.
    // http://stackoverflow.com/a/12379188/1263701
    
    dispatch_block_t block = ^
    {
        NSLog(@"%@", someText);
    };
    
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@end
