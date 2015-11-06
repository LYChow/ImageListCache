//
//  MCOperation.m
//  ImageListCache
//
//  Created by lychow on 11/6/15.
//  Copyright © 2015 LY'S MacBook Air. All rights reserved.
//

#import "MCOperation.h"

@implementation MCOperation

-(void)main
{
    //在子线程中 创建一个autoreleasepool管理对象的内存
    @autoreleasepool {
        //operation被cancel时,不再执行下载操作
        if (self.cancelled) return;
        NSURL *url = [NSURL URLWithString:self.iconUrl];
        NSData *data = [NSData dataWithContentsOfURL:url]; // 下载
        UIImage * image = [UIImage imageWithData:data]; // NSData -> UIImage

        if (self.cancelled)  return;
        //operation被cancel时,不再把image传出去赋值
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if ([_delegate respondsToSelector:@selector(operation:image:)]) {
                [_delegate operation:self image:image];
            }
        }];
    }
}
@end
