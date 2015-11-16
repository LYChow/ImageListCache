//
//  UIBarButtonItem+Extention.m
//  TransferData
//
//  Created by lychow on 11/11/15.
//  Copyright © 2015 IOSDeveloper. All rights reserved.
//

#import "UIBarButtonItem+Extention.h"
#import "UIView+Extention.h"
@implementation UIBarButtonItem (Extention)


+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
