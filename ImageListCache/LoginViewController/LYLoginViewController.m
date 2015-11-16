//
//  LYLoginViewController.m
//  ImageListCache
//
//  Created by lychow on 11/13/15.
//  Copyright © 2015 LY'S MacBook Air. All rights reserved.
//

#import "LYLoginViewController.h"
#import "Reachability.h"
@interface LYLoginViewController () <NSURLSessionDelegate>

@end

@implementation LYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender
{
    NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/login?username=%@&pwd=%@",self.userNameTextField.text, self.passcodeTextField.text];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    id json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([json isKindOfClass:[NSDictionary class]])
    {
        if (json[@"error"])
        {
            NSLog(@"%@",json[@"error"]);
        }
        else
        {
            NSLog(@"%@",json[@"success"]);
        }
    }
    else if ([json isKindOfClass:[NSArray class]])
    {
    
    }
    
//    NSURLSessionConfiguration *cfg =[NSURLSessionConfiguration defaultSessionConfiguration];
//   [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChange) name:kReachabilityChangedNotification object:nil];
    
    [reachability startNotifier];
    
    [self checkNetworkStatus];
}

-(void)networkStatusChange
{
    [self checkNetworkStatus];
}

-(void)checkNetworkStatus
{
   
    if ([self isEnableWWLan])
    {
           NSLog(@"是移动网络");
    }
    if ([self isEnableWIFI])
    {
            NSLog(@"是WIFI");
    }
//    else
//    {
//             NSLog(@"无网");
//    }
}

-(BOOL)isEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

-(BOOL)isEnableWWLan
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

-(void)dealloc
{

}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{

}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    NSLog(@"%@",session);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{

}



@end
