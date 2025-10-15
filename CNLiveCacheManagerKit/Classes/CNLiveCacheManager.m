//
//  CNLiveCacheManager.m
//  AFNetworking
//
//  Created by 流诗语 on 2019/6/4.
//

#import "CNLiveCacheManager.h"
#import "NSString+CNLiveCacheString.h"
#import <CNLiveUserManagement/CNUserInfoManager.h>
#import <CNLiveUserManagement/CNUserInfoModel.h>

@interface CNLiveCacheManager()
@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, copy) NSString *_key;
@property (nonatomic) id _object;
@property (nonatomic, assign) BOOL _newFile;
@property (nonatomic, strong) NSArray * _fileName;
@property (nonatomic, assign) CNLiveCacheType _cacheType;
@property (nonatomic, assign) CNLiveCacheActionType _actionType;

@property (copy, readwrite) NSString *name;
@property (strong, readwrite) CNLiveDiskCache *diskCache;
@property (strong, readwrite) CNLiveMemoryCache *memoryCache;
@end

@implementation CNLiveCacheManager

+(nullable instancetype)cacheManager
{
    static CNLiveCacheManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        cacheFolder = [cacheFolder stringByAppendingPathComponent:@"CNLiveMainCache"];
        NSString * projectName = [[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] md5];
        if (![[CNUserInfoManager manager].userInfoModel.uid isEmpty] && ![[CNUserInfoManager manager].userInfoModel.uid isEqualToString:@"0"]) {
            self.basePath = [cacheFolder stringByAppendingPathComponent:[CNUserInfoManager manager].userInfoModel.uid];
        }else{
            self.basePath = [cacheFolder stringByAppendingPathComponent:projectName];
        }
    }
    return self;
}

- (void)setCacheManager:(NSString *)key {
    NSString * filePath = self._newFile?[self.basePath stringByAppendingPathComponent:key]:self.basePath;
    if (self._fileName.count > 0 && self._fileName != nil) {
        for (NSString * file in self._fileName) {
            filePath = [filePath stringByAppendingPathComponent:file];
        }
    }
    CNLiveDiskCache *diskCache = [[CNLiveDiskCache alloc] initWithPath:filePath];
    if (!diskCache) return;
    CNLiveMemoryCache *memoryCache = [[CNLiveMemoryCache alloc] init];
    memoryCache.name = key;

    _name = key;
    _diskCache = diskCache;
    _memoryCache = memoryCache;
    
#ifdef DEBUG
    _diskCache.errorLogsEnabled = YES;
#else
    _diskCache.errorLogsEnabled = NO;
#endif
}

- (CNLiveCacheManager *(^)(CNLiveCacheActionType actionType))actionType
{
    return ^CNLiveCacheManager *(CNLiveCacheActionType actionType) {
        self._actionType = actionType;
        return self;
    };
}

- (CNLiveCacheManager *(^)(NSString *key))key
{
    return ^CNLiveCacheManager *(NSString *key){
        self._key = key;
        return self;
    };
}
- (CNLiveCacheManager *(^)(id<NSCoding> object))object
{
    return ^CNLiveCacheManager *(id<NSCoding> object) {
        self._object = object;
        return self;
    };
}
- (CNLiveCacheManager *(^)(CNLiveCacheType cacheType))cacheType
{
    return ^CNLiveCacheManager *(CNLiveCacheType cacheType){
        self._cacheType = cacheType;
        return self;
    };
}
- (CNLiveCacheManager *(^)(BOOL newFile))newFile
{
    return ^CNLiveCacheManager *(BOOL newFile) {
        self._newFile = newFile;
        return self;
    };
}
- (CNLiveCacheManager *(^)(NSArray * fileName))fileName
{
    return ^CNLiveCacheManager *(NSArray * fileName) {
        self._fileName = fileName;
        return self;
    };
}
- (void(^)(CNLiveCacheResultBlock resultBlock))completerBlock
{
    [self setCacheManager:self._key];
    return ^void(CNLiveCacheResultBlock resultBlock) {
        if (self._actionType == CNLiveCacheActionTypeInsert) {
            
            [self insertObjectWithResultBlock:resultBlock];
        }
        if (self._actionType == CNLiveCacheActionTypeSelect) {
            
            [self selectObjectWithResultBlock:resultBlock];
        }
        if (self._actionType == CNLiveCacheActionTypeContain) {
            
            [self containsObjectWithResultBlock:resultBlock];
        }
        if (self._actionType == CNLiveCacheActionTypeDelect) {
            
            [self delectObjectWithResultBlock:resultBlock];
        }
    };
}
- (id)start
{
    id object = nil;
    [self setCacheManager:self._key];
    if (self._actionType == CNLiveCacheActionTypeInsert) {
        if (self._cacheType != CNLiveCacheTypeUserDefa) {
            [_memoryCache setObject:self._object forKey:self._key];
            [_diskCache setObject:self._object forKey:self._key UseFile:self._cacheType == CNLiveCacheTypeFile];
        }else{
            [_memoryCache setObject:self._object forKey:self._key];
            [[NSUserDefaults standardUserDefaults] setObject:self._object forKey:self._key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if (self._actionType == CNLiveCacheActionTypeDelect) {
        if (self._cacheType != CNLiveCacheTypeUserDefa) {
            if ([self._key isEmpty]) {
                [_memoryCache removeAllObjects];
                [_diskCache removeAllObjectsUseFile:self._cacheType == CNLiveCacheTypeFile];
            }else{
                if (self._newFile) {
                    [[NSFileManager defaultManager] removeItemAtPath:[self.basePath stringByAppendingPathComponent:self._key] error:nil];
                }else{
                    [_memoryCache removeObjectForKey:self._key];
                    [_diskCache removeObjectForKey:self._key UseFile:self._cacheType == CNLiveCacheTypeFile];
                }
            }
        }else{
            [_memoryCache removeObjectForKey:self._key];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:self._key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if (self._actionType == CNLiveCacheActionTypeSelect) {
        if (self._cacheType != CNLiveCacheTypeUserDefa) {

            id<NSCoding> obj = [_memoryCache objectForKey:self._key];
            if (!obj) {
                id<NSCoding> obj = [_diskCache objectForKey:self._key UseFile:self._cacheType == CNLiveCacheTypeFile];
                if (obj) {
                    [_memoryCache setObject:obj forKey:self._key];
                    object = obj;
                }
            }else{
                object = obj;
            }
            
        }else{
            id<NSCoding> obj = [_memoryCache objectForKey:self._key];
            if (!obj) {
                id<NSCoding> obj = [[NSUserDefaults standardUserDefaults] objectForKey:self._key];
                if (obj) {
                    [_memoryCache setObject:obj forKey:self._key];
                    object = obj;
                }
            }else{
                object = obj;
            }
        }
    }
    
    if (self._actionType == CNLiveCacheActionTypeContain) {
        if (self._cacheType != CNLiveCacheTypeUserDefa) {

            BOOL isHave = [_memoryCache containsObjectForKey:self._key] || [_diskCache containsObjectForKey:self._key UseFile:self._cacheType == CNLiveCacheTypeFile];
            object = [NSNumber numberWithBool:isHave];
        }else{
            BOOL isHave = [_memoryCache containsObjectForKey:self._key] || [[NSUserDefaults standardUserDefaults] objectForKey:self._key];
            object = [NSNumber numberWithBool:isHave];
        }
    }
    __key = nil;
    __object = nil;
    __cacheType = CNLiveCacheTypeDefult;
    return object;
}
#pragma mark - private
//增
-(void)insertObjectWithResultBlock:(CNLiveCacheResultBlock)resultBlock {
    __weak typeof(self) weakSelf = self;
    if (self._cacheType == CNLiveCacheTypeFile) {
        [self.memoryCache setObject:self._object forKey:self._key];
        [self.diskCache setObject:self._object forKey:self._key UseFile:YES withBlock:^{
            resultBlock(weakSelf._key,weakSelf._object,YES);
            weakSelf._key = nil;
            weakSelf._object = nil;
            weakSelf._cacheType = CNLiveCacheTypeDefult;
        }];
    }
    if (self._cacheType == CNLiveCacheTypeSQLite) {
        [self.memoryCache setObject:self._object forKey:self._key];
        [self.diskCache setObject:self._object forKey:self._key UseFile:NO withBlock:^{
            resultBlock(weakSelf._key,weakSelf._object,YES);
            weakSelf._key = nil;
            weakSelf._object = nil;
            weakSelf._cacheType = CNLiveCacheTypeDefult;
        }];
    }
    if (self._cacheType == CNLiveCacheTypeUserDefa) {
        [self.memoryCache setObject:self._object forKey:self._key];
        [[NSUserDefaults standardUserDefaults] setObject:self._object forKey:self._key];
        if ([[NSUserDefaults standardUserDefaults] synchronize]) {
            resultBlock(weakSelf._key,weakSelf._object,YES);
            weakSelf._key = nil;
            weakSelf._object = nil;
            weakSelf._cacheType = CNLiveCacheTypeDefult;
        }
    }
    if (self._cacheType == CNLiveCacheTypeDefult) {
        [self.memoryCache setObject:self._object forKey:self._key];
        [self.diskCache setObject:self._object forKey:self._key UseFile:NO withBlock:^{
            resultBlock(weakSelf._key,weakSelf._object,YES);
            weakSelf._key = nil;
            weakSelf._object = nil;
            weakSelf._cacheType = CNLiveCacheTypeDefult;
        }];
    }
}
//查
-(void)selectObjectWithResultBlock:(CNLiveCacheResultBlock)resultBlock {
    __weak typeof(self) weakSelf = self;
    if (self._cacheType != CNLiveCacheTypeUserDefa) {

        id<NSCoding> object = [self.memoryCache objectForKey:self._key];
        if (object) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                resultBlock(weakSelf._key,object,YES);
                weakSelf._key = nil;
                weakSelf._object = nil;
                weakSelf._cacheType = CNLiveCacheTypeDefult;
            });
        } else {
            [self.diskCache objectForKey:self._key UseFile:self._cacheType == CNLiveCacheTypeFile withBlock:^(NSString *key, id<NSCoding> object) {
                if (object && ![weakSelf.memoryCache objectForKey:key]) {
                    [weakSelf.memoryCache setObject:object forKey:key];
                }
                resultBlock(key,object,YES);
                weakSelf._key = nil;
                weakSelf._object = nil;
                weakSelf._cacheType = CNLiveCacheTypeDefult;
            }];
        }
    }
    if (self._cacheType == CNLiveCacheTypeUserDefa) {
        id<NSCoding> object = [self.memoryCache objectForKey:self._key];
        if (object) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                resultBlock(weakSelf._key,object,YES);
                weakSelf._key = nil;
                weakSelf._object = nil;
                weakSelf._cacheType = CNLiveCacheTypeDefult;
            });
        } else {
            id obj = [[NSUserDefaults standardUserDefaults] objectForKey:self._key];
            if (obj && ![weakSelf.memoryCache objectForKey:self._key]) {
                [self.memoryCache setObject:obj forKey:self._key];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                resultBlock(weakSelf._key,obj,YES);
                weakSelf._key = nil;
                weakSelf._object = nil;
                weakSelf._cacheType = CNLiveCacheTypeDefult;
            });
        }
    }
}
// 查元素
- (void)containsObjectWithResultBlock:(CNLiveCacheResultBlock)resultBlock {
 
    __weak typeof(self) weakSelf = self;
    if (self._cacheType != CNLiveCacheTypeUserDefa) {

        if ([self->_memoryCache containsObjectForKey:self._key]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                resultBlock(weakSelf._key, nil, YES);
                weakSelf._key = nil;
                weakSelf._object = nil;
                weakSelf._cacheType = CNLiveCacheTypeDefult;
            });
        } else  {
            [self->_diskCache containsObjectForKey:weakSelf._key UseFile:self._cacheType == CNLiveCacheTypeFile withBlock:^(NSString *key, BOOL contains) {
                resultBlock(key,nil,contains);
                weakSelf._key = nil;
                weakSelf._object = nil;
                weakSelf._cacheType = CNLiveCacheTypeDefult;
            }];
        }
    }
    if (self._cacheType == CNLiveCacheTypeUserDefa) {
        id<NSCoding> object = [self.memoryCache objectForKey:self._key];
        if (object) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                resultBlock(weakSelf._key,object,YES);
                weakSelf._key = nil;
                weakSelf._object = nil;
                weakSelf._cacheType = CNLiveCacheTypeDefult;
            });
        } else {
            id obj = [[NSUserDefaults standardUserDefaults] objectForKey:self._key];
            if (obj && ![weakSelf.memoryCache objectForKey:self._key]) {
                [self.memoryCache setObject:obj forKey:self._key];
                resultBlock(weakSelf._key,object,YES);
                weakSelf._key = nil;
                weakSelf._object = nil;
                weakSelf._cacheType = CNLiveCacheTypeDefult;
            }
        }
    }
}
// 删
- (void)delectObjectWithResultBlock:(CNLiveCacheResultBlock)resultBlock {
    
    __weak typeof(self) weakSelf = self;
    if (self._cacheType != CNLiveCacheTypeUserDefa) {
            if ([self._key isEmpty]) {
                [self.memoryCache removeAllObjects];
                [self.diskCache removeAllObjectsUseFile:self._cacheType == CNLiveCacheTypeFile withBlock:^{
                    resultBlock(nil,nil,NO);
                    weakSelf._key = nil;
                    weakSelf._object = nil;
                    weakSelf._cacheType = CNLiveCacheTypeDefult;
                }];
            }else{
                [self.memoryCache removeObjectForKey:self._key];
                [self.diskCache removeObjectForKey:self._key UseFile:self._cacheType == CNLiveCacheTypeFile withBlock:^(NSString *key) {
                    resultBlock(key,nil,NO);
                    weakSelf._key = nil;
                    weakSelf._object = nil;
                    weakSelf._cacheType = CNLiveCacheTypeDefult;
                }];
            }
        
    }
    if (self._cacheType == CNLiveCacheTypeUserDefa) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self._key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.memoryCache removeObjectForKey:self._key];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            resultBlock(weakSelf._key,nil,NO);
            weakSelf._key = nil;
            weakSelf._object = nil;
            weakSelf._cacheType = CNLiveCacheTypeDefult;
        });
    }
}

- (NSString *)description {
    if (_name) return [NSString stringWithFormat:@"<%@: %p> (%@)", self.class, self, _name];
    else return [NSString stringWithFormat:@"<%@: %p>", self.class, self];
}


@end
