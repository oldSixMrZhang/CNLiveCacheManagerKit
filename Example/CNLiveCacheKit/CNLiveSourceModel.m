//
//  CNLiveSourceModel.m
//  CNLiveCacheKit_Example
//
//  Created by 流诗语 on 2019/6/17.
//  Copyright © 2019年 woshiliushiyu. All rights reserved.
//

#import "CNLiveSourceModel.h"

@implementation CNLiveSourceModel
MJCodingImplementation
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
//        _isSuccess = [aDecoder decodeBoolForKey:@"isSuccess"];
//        _number = [aDecoder decodeIntegerForKey:@"number"];
//        _str = [aDecoder decodeObjectForKey:@"str"];
//        _array = [aDecoder decodeObjectForKey:@"array"];
//    }
//    return self;
//}
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeBool:_isSuccess forKey:@"isSuccess"];
//    [aCoder encodeInteger:_number forKey:@"number"];
//    [aCoder encodeObject:_str forKey:@"str"];
//    [aCoder encodeObject:_array forKey:@"array"];
//}

- (instancetype)initWithisSuccess:(BOOL)isSuccess number:(NSInteger)number str:(NSString *)str array:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.isSuccess = isSuccess;
        self.number = number;
        self.str = str;
        self.array = array;
    }
    return self;
}

@end
