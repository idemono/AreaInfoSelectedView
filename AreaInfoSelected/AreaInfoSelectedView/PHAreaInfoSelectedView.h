//
//  PHAreaInfoSelectedView.h
//  AreaInfoSelected
//
//  Created by 泓杉mini on 2018/11/28.
//  Copyright © 2018 PH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAreaInfoSelectedView : UIView

//省市县数据源
@property (strong, nonatomic) NSArray *dataArray;

//1.传定位城市,具体到 省,市
//2.之前已经录入的地址(纯字符串,用空格隔开)
//3.之前已经记录的地址(字符串,code)

@end

NS_ASSUME_NONNULL_END
