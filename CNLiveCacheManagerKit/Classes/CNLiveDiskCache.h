//
//  CNLiveCacheManager.h
//  CNLiveCacheKit
//
//  Created by 流诗语 on 2019/4/26.
//

#import <Foundation/Foundation.h>

@interface CNLiveDiskCache : NSObject

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

@property (nullable, copy) NSString *name;

@property (readonly) NSString *path;

@property (readonly) NSUInteger inlineThreshold;

@property (nullable, copy) NSData *(^customArchiveBlock)(id object);

@property (nullable, copy) id (^customUnarchiveBlock)(NSData *data);

@property (nullable, copy) NSString *(^customFileNameBlock)(NSString *key);



#pragma mark - Limit
///=============================================================================
/// @name Limit
///=============================================================================

@property NSUInteger countLimit;

@property NSUInteger costLimit;

@property NSTimeInterval ageLimit;

@property NSUInteger freeDiskSpaceLimit;

@property NSTimeInterval autoTrimInterval;

@property BOOL errorLogsEnabled;

#pragma mark - Initializer
///=============================================================================
/// @name Initializer
///=============================================================================
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithPath:(NSString *)path;

- (nullable instancetype)initWithPath:(NSString *)path
                      inlineThreshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;


#pragma mark - Access Methods
///=============================================================================
/// @name Access Methods
///=============================================================================

- (BOOL)containsObjectForKey:(NSString *)key UseFile:(BOOL)useFile;

- (void)containsObjectForKey:(NSString *)key UseFile:(BOOL)useFile withBlock:(void(^)(NSString *key, BOOL contains))block;

- (nullable id<NSCoding>)objectForKey:(NSString *)key UseFile:(BOOL)useFile;

- (void)objectForKey:(NSString *)key UseFile:(BOOL)useFile withBlock:(void(^)(NSString *key, id<NSCoding> _Nullable object))block;

- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key UseFile:(BOOL)useFile;

- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key UseFile:(BOOL)useFile withBlock:(void(^)(void))block;

- (void)removeObjectForKey:(NSString *)key UseFile:(BOOL)useFile;

- (void)removeObjectForKey:(NSString *)key UseFile:(BOOL)useFile withBlock:(void(^)(NSString *key))block;

- (void)removeAllObjectsUseFile:(BOOL)useFile;

- (void)removeAllObjectsUseFile:(BOOL)useFile withBlock:(void(^)(void))block;

- (void)removeAllObjectsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                                 endBlock:(nullable void(^)(BOOL error))end;

- (NSInteger)totalCount;

- (void)totalCountWithBlock:(void(^)(NSInteger totalCount))block;

- (NSInteger)totalCost;

- (void)totalCostWithBlock:(void(^)(NSInteger totalCost))block;


#pragma mark - Trim
///=============================================================================
/// @name Trim
///=============================================================================

- (void)trimToCount:(NSUInteger)count;

- (void)trimToCount:(NSUInteger)count withBlock:(void(^)(void))block;

- (void)trimToCost:(NSUInteger)cost;

- (void)trimToCost:(NSUInteger)cost withBlock:(void(^)(void))block;

- (void)trimToAge:(NSTimeInterval)age;

- (void)trimToAge:(NSTimeInterval)age withBlock:(void(^)(void))block;


#pragma mark - Extended Data
///=============================================================================
/// @name Extended Data
///=============================================================================

+ (nullable NSData *)getExtendedDataFromObject:(id)object;

+ (void)setExtendedData:(nullable NSData *)extendedData toObject:(id)object;

- (NSString *)cacheFilePath:(NSString *)key;

@end
