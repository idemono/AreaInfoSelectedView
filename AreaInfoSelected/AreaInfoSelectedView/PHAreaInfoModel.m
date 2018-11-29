//
//  PHAreaInfoModel.m
//  JsonModelAutoGenerate
//
//  Created by 泓杉mini的Mac mini on 2018/11/28
//  Copyright © 2018年 HS. All rights reserved.
//

#define YYModelSynthCoderAndHash \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; } \
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; } \
- (NSUInteger)hash { return [self yy_modelHash]; } \
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

#import "PHAreaInfoModel.h"
@implementation PHAreaInfoModelCitysDistricts 

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{};
}

YYModelSynthCoderAndHash

@end

@implementation PHAreaInfoModelCitys 

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"districts":[PHAreaInfoModelCitysDistricts class]
             };
}

YYModelSynthCoderAndHash

@end

@implementation PHAreaInfoModel 

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"citys":[PHAreaInfoModelCitys class]
             };
}

YYModelSynthCoderAndHash

@end

