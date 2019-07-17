//
//  CRAppDelegate.h
//  Crazy Run
//
//  Created by Vladimir Vinnik on 09.09.14.
//  Copyright (c) 2014 Vladimir Vinnik. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appKey = @"a01388f66a73e1f79cfadc6d";
static NSString *channel = @"cute";
static BOOL isProduction = true;
@interface CRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* navigationController;

@end
