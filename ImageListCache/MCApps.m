//
//  MCApps.m
//  networkTest
//
//  Created by lychow on 11/5/15.
//  Copyright © 2015 lychow. All rights reserved.
//

#import "MCApps.h"

@interface MCApps ()

@end

@implementation MCApps

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(instancetype)appWithDict:(NSDictionary *)dict
{
    MCApps *app =[[MCApps alloc] init];
    [app setValuesForKeysWithDictionary:dict];
    return app;
}

@end
