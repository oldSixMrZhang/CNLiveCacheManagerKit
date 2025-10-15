//
//  CNLiveSourceModel.h
//  CNLiveCacheKit_Example
//
//  Created by 流诗语 on 2019/6/17.
//  Copyright © 2019年 woshiliushiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
NS_ASSUME_NONNULL_BEGIN

@interface CNLiveSourceModel : NSObject<NSCoding>
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString * str;
@property (nonatomic, strong) NSArray *array;

- (instancetype)initWithisSuccess:(BOOL)isSuccess number:(NSInteger)number str:(NSString *)str array:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
