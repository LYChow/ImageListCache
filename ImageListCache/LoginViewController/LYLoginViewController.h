//
//  LYLoginViewController.h
//  ImageListCache
//
//  Created by lychow on 11/13/15.
//  Copyright © 2015 LY'S MacBook Air. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
- (IBAction)login:(id)sender;

@end
