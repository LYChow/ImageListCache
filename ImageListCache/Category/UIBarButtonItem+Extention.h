//
//  UIBarButtonItem+Extention.h
//  TransferData
//
//  Created by lychow on 11/11/15.
//  Copyright © 2015 IOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extention)

/*!
  @param target    被添加事件的对象
  @param action    响应方法
  @param image     背景图片
  @param highImage 高亮时的背景图片
  @return           自定义的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end
