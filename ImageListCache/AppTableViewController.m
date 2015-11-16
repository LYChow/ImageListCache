//
//  AppTableViewController.m
//  networkTest
//
//  Created by lychow on 11/5/15.
//  Copyright © 2015 lychow. All rights reserved.
//


/**
 *function:
 *未下载完成时能够显示placeHolder图片、不重复下载、重新下载下载失败的图片,对网络请求的数据进行沙盒缓存
 *思路:
 *
 *1.加载image通过url(key) 在内存中images(a.存在 or b.不存在)
 *a.存在--->直接显示在cell上显示图片
 *b.不存在----->在本地沙盒里是否存在---->(b1.存在  or b2.不存在)
 *b1.从user的caches文件夹获取image在cell上显示
 *b2.执行步骤2,请求数据
 *2.请求的数据成功之后存储在本地的NSDictionary,以url为key进行显示
 *3.为了防止operation重复执行,创建时以url为key存储在本地NSDictionary(operations),刷新tableView进 行判断,防止重复执行
 *4.下载数据(成功 or 失败)均把当前url对应的operation移除NSDictionary
  *a.Image下载成功时把image加入本地的NSDictionary(images),下载的图片根据url存在本地的沙盒内
  *b.Image下载失败时,在本地的NSDictionary中找不到相应的Image,重新创建operation 执行下载操作,可以多次请求失败(请求超时)的资源
 *5.把耗时的operation进行封装 
 */

#define MCImageCachePath(url)  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]

#import "AppTableViewController.h"
#import "MCApps.h"
#import "MCOperation.h"

#import "UIBarButtonItem+Extention.h"
#import "LYLoginViewController.h"
@interface AppTableViewController ()<MCOperationDelegate>
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
    
    
    self.navigationItem.rightBarButtonItem =[UIBarButtonItem itemWithTarget:self action:@selector(login) image:@"icon_category_-1" highImage:@"icon_category_highlighted_-1"];
}

-(void)login
{
    LYLoginViewController *loginVC =[[LYLoginViewController alloc] initWithNibName:@"LYLoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
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
    //内存中存在Image
    if (image)
    {
        cell.imageView.image= image;
    }
    else
    {
        /**
         *  去本地沙盒的缓存中获取image
         *
         *  @param NSCachesDirectory NSUserDomainMask当前程序用户所在路径
         *  @param NSUserDomainMask
         *  @param YES               ~/相当于  /users/apple  YES-->绝对路径
         *
         *  @return 文件的路径
         */
//        NSString *filePath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *fileName =[appInfo.icon lastPathComponent];
//        NSString *imagePath =[filePath stringByAppendingPathComponent:fileName];
        
        
    
        NSData *data =[NSData dataWithContentsOfFile:MCImageCachePath(appInfo.icon)];
        //沙盒缓存存在图片
        if (data)
        {
            cell.imageView.image =[UIImage imageWithData:data];
        }
        else
        {
        //沙盒不存在图片,请求网络数据
            cell.imageView.image =[UIImage imageNamed:@"placeholder"];
            [self downloadImageWithUrl:appInfo.icon indexPath:indexPath];
        }
        
    }
   
    return cell;
}

-(void)downloadImageWithUrl:(NSString *)icon  indexPath:(NSIndexPath *)indexPath
{

    
    
    MCOperation *operation =[self.operations objectForKey:icon];
    if (operation) return;
    
    operation =[[MCOperation alloc]init];
    operation.iconUrl=icon;
    operation.indexPath=indexPath;
    operation.delegate=self;
    
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
    [self.queue setSuspended:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.queue setSuspended:NO];
}


#pragma -mark operationDelegate数据下载完成时回调
-(void)operation:(MCOperation *)operation image:(UIImage *)image
{
    //下载(成功or 失败)之后把operation移除
    [self.operations removeObjectForKey:operation.iconUrl];

    
    self.images[operation.iconUrl]=image;
    NSString *imagePath =MCImageCachePath(operation.iconUrl);
    
    //不同类型的image进行转换
    NSData *data;
    if ([[[[operation.iconUrl lastPathComponent] componentsSeparatedByString:@"."] lastObject] isEqualToString:@"png"])
    {
        data =UIImagePNGRepresentation(image);
    }
    else if([[[[operation.iconUrl lastPathComponent] componentsSeparatedByString:@"."] lastObject] isEqualToString:@"jpg"])
    {
        data =UIImageJPEGRepresentation(image, 1.0);
    }
    
    [data writeToFile:imagePath atomically:YES];
    
    
    [self.tableView reloadRowsAtIndexPaths:@[operation.indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
