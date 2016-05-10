//
//  WaitingWindow.h
//  
//
//  Created by jimmygao on 11/30/15.
//
//

#import <Cocoa/Cocoa.h>
typedef bool (^conditionBlock) ();
@interface WaitingWindow : NSWindow

+(void)showWaitingWithMessage:(NSString *)message andDuringTime:(int)time;
+(void)showWaitingWhenFetchResult:(conditionBlock)condition needShowMessage:(NSString *)message WithDuringTime:(int)time;

+(void)dismissWaitingMessage;
@end
