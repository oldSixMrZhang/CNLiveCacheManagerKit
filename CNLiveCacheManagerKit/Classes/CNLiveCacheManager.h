//
//  CNLiveCacheManager.h
//  AFNetworking
//
//  Created by 流诗语 on 2019/6/4.
//

#import <Foundation/Foundation.h>
#import "CNLiveDiskCache.h"
#import "CNLiveMemoryCache.h"
#import "CNLiveCacheEnum.h"

#define CACHE [CNLiveCacheManager cacheManager]

/**
 四项操作返回 block,下方写时不会代码提示,可复制此处.

 @param key 存储标识符
 @param result 存储数据
 @param contain 是否存储该数据
 */
typedef void(^CNLiveCacheResultBlock)(NSString *key,id result,BOOL contain);

@interface CNLiveCacheManager : NSObject

/**
 初始化引擎,可使用上部缩写.

 @return 返回
 */
+ (nullable instancetype)cacheManager;

#pragma mark - 链式调用
/** 链式调用 */

/**
 数据存储的唯一标识符,删除时如果不传该值则删除全部,除删除数据外,其他的都必须要传.
 */
- (CNLiveCacheManager *(^)(NSString *key))key;

/**
 需存的数据.该数据必须实现NSCoding协议,如不实现协议,则只存在于内存中,不会存磁盘,
 */
- (CNLiveCacheManager *(^)(id<NSCoding> object))object;

/**
 对缓存器进行选择(❗️❗️❗️ 大于 20K 的数据必须选 file 类型存储❗️❗️❗️),存储类型中所有元素都将存在内存一份.
 */
- (CNLiveCacheManager *(^)(CNLiveCacheType cacheType))cacheType;

/**
 增.删.查.取.四种操作.
 */
- (CNLiveCacheManager *(^)(CNLiveCacheActionType actionType))actionType;

/**
 是否通过 key 创建不同的文件夹,以区分不同数据.默认不进行区分
 */
- (CNLiveCacheManager *(^)(BOOL newFile))newFile;

/**
 设置本地存储时创一个文件,(此设置可以在相同的 key 下创建多个数据存储位置)
 */
- (CNLiveCacheManager *(^)(NSArray * fileName))fileName;

/**
 异步返回四种操作的异步回调,(此 block 没有代码提示,注意.block中是异步的)
 */
- (void (^)(CNLiveCacheResultBlock resultBlock))completerBlock;

/**
 开始进行四项操作的动作.

 @return 此返回参数在增,删中操作中返回 nil,上层可不进行接收.
 */
- (id)start;

@end
