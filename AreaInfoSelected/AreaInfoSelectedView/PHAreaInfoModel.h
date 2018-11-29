//
//  PHAreaInfoModel.h
//  JsonModelAutoGenerate
//
//  Created by 泓杉mini的Mac mini on 2018/11/28
//  Copyright © 2018年 HS. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<YYModel/YYModel.h>)
  #import <YYModel/YYModel.h>
#else
  #import "YYModel.h"
#endif


@interface PHAreaInfoModelCitysDistricts : NSObject<NSCoding, NSCopying>

@property (nonatomic ,copy)NSString  *sysno;
@property (nonatomic ,copy)NSString  *districtname;


@end

@interface PHAreaInfoModelCitys : NSObject<NSCoding, NSCopying>

@property (nonatomic ,copy)NSString  *citySyso;
@property (nonatomic ,copy)NSArray  *districts;
@property (nonatomic ,copy)NSString  *cityName;


@end

@interface PHAreaInfoModel : NSObject<NSCoding, NSCopying>

@property (nonatomic ,copy)NSArray  *citys;
@property (nonatomic ,copy)NSString  *provinceName;
@property (nonatomic ,copy)NSString  *provinceSysno;


@end

