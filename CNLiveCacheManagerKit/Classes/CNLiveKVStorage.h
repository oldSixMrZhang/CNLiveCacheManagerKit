//
//  CNLiveKVStorage.h
//  CNLiveCacheKit
//
//  Created by 流诗语 on 2019/4/26.
//

#import <Foundation/Foundation.h>

@interface CNLiveKVStorageItem : NSObject
@property (nonatomic, strong) NSString *key;                ///< key
@property (nonatomic, strong) NSData *value;                ///< value
@property (nullable, nonatomic, strong) NSString *filename; ///< filename (nil if inline)
@property (nonatomic) int size;                             ///< data 大小
@property (nonatomic) int modTime;                          ///< 写入时间
@property (nonatomic) int accessTime;                       ///< 最后保存时间
@property (nullable, nonatomic, strong) NSData *extendedData; ///<  扩展字段可以为空
@end


typedef NS_ENUM(NSUInteger, CNLiveKVStorageType) {
    
    CNLiveKVStorageTypeFile = 0,

    CNLiveKVStorageTypeSQLite = 1,

    CNLiveKVStorageTypeMixed = 2,
};

/**此类为CNLiveKVStorage的重写,修改其一部分方法的实现*/
@interface CNLiveKVStorage : NSObject

#pragma mark - Attribute
@property (nonatomic, readonly) NSString *path;        ///< The path of this storage.
@property (nonatomic, readonly) CNLiveKVStorageType type;  ///< The type of this storage.
@property (nonatomic) BOOL errorLogsEnabled;

#pragma mark - Initializer
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithPath:(NSString *)path type:(CNLiveKVStorageType)type NS_DESIGNATED_INITIALIZER;

#pragma mark - Save Items
///=============================================================================
/// @name Save Items
///=============================================================================

- (BOOL)saveItem:(CNLiveKVStorageItem *)item;

- (BOOL)saveItemWithKey:(NSString *)key value:(NSData *)value;

- (BOOL)saveItemWithKey:(NSString *)key
                  value:(NSData *)value
               filename:(nullable NSString *)filename
           extendedData:(nullable NSData *)extendedData;

#pragma mark - Remove Items
///=============================================================================
/// @name Remove Items
///=============================================================================

- (BOOL)removeItemForKey:(NSString *)key;

- (BOOL)removeItemForKeys:(NSArray<NSString *> *)keys;

- (BOOL)removeItemsLargerThanSize:(int)size;

- (BOOL)removeItemsEarlierThanTime:(int)time;

- (BOOL)removeItemsToFitSize:(int)maxSize;

- (BOOL)removeItemsToFitCount:(int)maxCount;

- (BOOL)removeAllItems;

- (void)removeAllItemsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                               endBlock:(nullable void(^)(BOOL error))end;

#pragma mark - Get Items
///=============================================================================
/// @name Get Items
///=============================================================================

- (nullable CNLiveKVStorageItem *)getItemForKey:(NSString *)key;

- (nullable CNLiveKVStorageItem *)getItemInfoForKey:(NSString *)key;

- (nullable NSData *)getItemValueForKey:(NSString *)key;

- (nullable NSArray<CNLiveKVStorageItem *> *)getItemForKeys:(NSArray<NSString *> *)keys;

- (nullable NSArray<CNLiveKVStorageItem *> *)getItemInfoForKeys:(NSArray<NSString *> *)keys;

- (nullable NSDictionary<NSString *, NSData *> *)getItemValueForKeys:(NSArray<NSString *> *)keys;

#pragma mark - Get Storage Status
///=============================================================================
/// @name Get Storage Status
///=============================================================================

- (BOOL)itemExistsForKey:(NSString *)key;

- (int)getItemsCount;

- (int)getItemsSize;

@end

