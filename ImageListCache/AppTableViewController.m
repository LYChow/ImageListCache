//
//  AppTableViewController.m
//  networkTest
//
//  Created by lychow on 11/5/15.
//  Copyright © 2015 lychow. All rights reserved.
//


/**
 *function:
 *未下载完成时能够显示placeHolder图片、不重复下载、重新下载下载失败的图片
 *思路:
 *1.请求的数据成功之后存储在本地的NSDictionary,以url为key进行显示
 *2.为了防止operation重复执行,创建时以url为key存储在本地NSDictionary,刷新tableView进 行判断,防止重复执行
 *3.下载数据(成功 or 失败)均把当前url对应的operation移除NSDictionary 
   a.Image下载成功时把image加入本地的NSDictionary,下次刷新TableView时从本地获取Image不再创建operation
   b.Image下载失败时,在本地的NSDictionary中找不到相应的Image,重新创建operation 执行下载操作,可以多次请求失败(请求超时)的资源
 *
 */

#import "AppTableViewController.h"
#import "MCApps.h"
@interface AppTableViewController ()
@property(nonatomic,strong) NSMutableArray  *apps;

/**
 *  全局queue
 */
@property(nonatomic,strong) NSOperationQueue  *queue;

/**
 *  用于存放operation和url的字典
 */
@property(nonatomic,strong) NSMutableDictionary  *operations;

/**
 *  存放网络下载的图片
 */
@property(nonatomic,strong) NSMutableDictionary  *images ;
@end

@implementation AppTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSOperationQueue *)queue
{
    if (!_queue) {
        self.queue =[[NSOperationQueue alloc] init];
    }
    return _queue;
}

-(NSMutableDictionary *)operations
{
    if (!_operations) {
        self.operations =[[NSMutableDictionary alloc] init];
    }
    return _operations;
}

-(NSMutableDictionary *)images
{
    if (!_images) {
        self.images =[[NSMutableDictionary alloc] init];
    }
    return _images;
}

-(NSMutableArray *)apps
{
    //1.创建一个数组
    if (!_apps) {
        _apps =[NSMutableArray array];
        
        //2.加载本地的plist文件
        NSString *filePath =[[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil];
        NSArray *array =[NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *appInfo in array) {
            MCApps *app =[MCApps appWithDict:appInfo];
            [_apps addObject:app];
        }

    }
      return _apps;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId =@"cellIndentifier";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    MCApps *appInfo =[self.apps objectAtIndex:indexPath.row];
    cell.textLabel.text=appInfo.name;
    cell.detailTextLabel.text=appInfo.download;
    
    UIImage *image =[self.images objectForKey:appInfo.icon];
    NSLog(@"%@",image);
    if (image)
    {
        cell.imageView.image= image;
    }
    else
    {
        cell.imageView.image =[UIImage imageNamed:@"placeholder"];
        
        [self downloadImageWithUrl:appInfo.icon indexPath:indexPath];
        
    }
   
    return cell;
}

-(void)downloadImageWithUrl:(NSString *)icon  indexPath:(NSIndexPath *)indexPath
{

    
    
    NSBlockOperation *operation =[self.operations objectForKey:icon];
    if (operation) return;
    
    __weak typeof(self)  vc =self;
    
    NSLog(@"%@",self.images);
        operation =[NSBlockOperation blockOperationWithBlock:^{
            NSURL *url = [NSURL URLWithString:icon];
            NSData *data = [NSData dataWithContentsOfURL:url]; // 下载
            UIImage *image = [UIImage imageWithData:data]; // NSData -> UIImage
            
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                if (image) {
                    vc.images[icon]=image;
                    [vc.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            
            
            //下载(成功or 失败)之后把operation移除
            [vc.operations removeObjectForKey:icon];
        }];
        
        //把operation加入queue,防止重复下载
        self.operations[icon]= operation;
        
        [self.queue addOperation:operation];

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.apps.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)didReceiveMemoryWarning
{
    [self.images removeAllObjects];
    [self.operations removeAllObjects];
    [self.queue cancelAllOperations];


}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

@end
