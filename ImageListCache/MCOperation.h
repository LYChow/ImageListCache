//
//  MCOperation.h
//  ImageListCache
//
//  Created by lychow on 11/6/15.
//  Copyright © 2015 LY'S MacBook Air. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MCOperation;
@protocol MCOperationDelegate <NSObject>

-(void)operation:(MCOperation *)operation image:(UIImage *)image;

@end

@interface MCOperation : NSOperation

@property(nonatomic, copy) NSString *iconUrl;

@property(nonatomic,strong) NSIndexPath  *indexPath;

@property(nonatomic , weak) id <MCOperationDelegate> delegate;

@end
