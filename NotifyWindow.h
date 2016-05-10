//
//  NotifyWindow.h
//  NotifyView
//
//  Created by Jimmy on 15/11/24.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define LableXMargin 20
#define LableYMargin 20

@interface NotifyWindow : NSWindow
+(void)presentWithMessage:(NSString *)message ForTime:(int)second;
@end
