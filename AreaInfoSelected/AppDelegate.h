//
//  AppDelegate.h
//  AreaInfoSelected
//
//  Created by 泓杉mini on 2018/11/28.
//  Copyright © 2018 PH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

