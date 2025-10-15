//
//  CNLiveCacheEnum.h
//  CNLiveCacheKit
//
//  Created by 流诗语 on 2019/6/4.
//  Copyright © 2019年 woshiliushiyu. All rights reserved.
//

#ifndef CNLiveCacheEnum_h
#define CNLiveCacheEnum_h

typedef NS_ENUM(NSUInteger, CNLiveCacheType) {
    /** 默认内存,磁盘都存储 */
    CNLiveCacheTypeDefult,
    /** sql 存储(适用于小文件) */
    CNLiveCacheTypeSQLite,
    /** 文件存储(适用于大文件) */
    CNLiveCacheTypeFile,
    /** plist 存储(偏好设置) */
    CNLiveCacheTypeUserDefa,
};

typedef NS_ENUM(NSUInteger, CNLiveCacheActionType) {
    /** 插入&替换操作 */
    CNLiveCacheActionTypeInsert,
    /** 查找操作 */
    CNLiveCacheActionTypeSelect,
    /** 删除操作 */
    CNLiveCacheActionTypeDelect,
    /** 元素查询 */
    CNLiveCacheActionTypeContain,
};

#endif /* CNLiveCacheEnum_h */
