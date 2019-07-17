/*
 ============================================================================
 Name        : UIUtil.m
 Version     : 1.0.0
 Copyright   : 
 Description : 工具类
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "UIUtil.h"


@implementation UIUtil

+ (UIAlertView*)showWarning:(NSString*)message title:(NSString*)title delegate:(id)delegate
{
    UIAlertView* alertSheet = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alertSheet show];
    
    return alertSheet;
}

+ (UIAlertView*)showQuestion:(NSString*)message title:(NSString*)title delegate:(id)delegate
{
    UIAlertView* alertSheet = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertSheet show];
    
    return alertSheet;
}

@end
