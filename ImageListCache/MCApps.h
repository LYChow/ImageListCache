//
//  MCApps.h
//  networkTest
//
//  Created by lychow on 11/5/15.
//  Copyright © 2015 lychow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCApps : UIViewController


@property(nonatomic,strong) NSString  *name;
@property(nonatomic,strong) NSString  *icon;
@property(nonatomic,strong) NSString  *download;
/**
 * dict  转换model
 *
 *  @param dict
 */
+(instancetype)appWithDict:(NSDictionary *)dict;
@end
