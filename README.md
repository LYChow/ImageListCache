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
