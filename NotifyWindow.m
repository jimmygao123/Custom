//
//  NotifyWindow.m
//  NotifyView
//
//  Created by Jimmy on 15/11/24.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "NotifyWindow.h"

static NotifyWindow *instance = NULL;
@implementation NotifyWindow
{
    NSTextField *label;
}

+(instancetype)getInstance{

    if(instance == NULL){
        instance = [[self alloc]init];
    }
    return instance;
}

+(void)presentWithMessage:(NSString *)message ForTime:(int)second{
    [[NotifyWindow getInstance] presentWithMessage:message DuringTime:second];
}

-(instancetype)init{
    if (self = [super init]) {
        
        [self setLevel:NSModalPanelWindowLevel];
        [self setStyleMask:NSBorderlessWindowMask];
        [self setReleasedWhenClosed:NO];
        [self setOpaque:YES];
        
        self.alphaValue = 0.8;
        [self setBackgroundColor:[NSColor clearColor] ];
        [self setMovableByWindowBackground:NO];
        [self setHasShadow:YES];
       
        label = [[NSTextField alloc]init];
        
        [label setFont:[NSFont systemFontOfSize:15]];
        [label setTextColor:[NSColor whiteColor]];
        [label setBezeled:NO];
        [label setDrawsBackground:NO];
        [label setEditable:NO];
        [label setSelectable:NO];

        [self.contentView addSubview:label];
    }
    return self;
}

-(void)setContentView:(id)contentView{
    
    NSView *aView = (NSView *)contentView;
    aView.wantsLayer = YES;
    NSColor *bgColor = [NSColor colorWithWhite:0.2 alpha:0.8];
    aView.layer.backgroundColor = bgColor.CGColor;
    aView.layer.cornerRadius = 5.f;
    aView.layer.masksToBounds = YES;
    
    [super setContentView:aView];
}

-(void)presentWithMessage:(NSString *)message DuringTime:(int)second{
    
    if(message.length){
        
        label.stringValue = message;
        
        [self adjustMessagePosition];
        [self makeKeyAndOrderFront:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self close];
        });

    }else{
        NSLog(@"No message info to notify!");
        return;
    }
}

-(void)adjustMessagePosition{
    [label sizeToFit];
    
    CGSize windowSize = CGRectInset(label.frame, -LableXMargin, -LableYMargin).size;
    CGRect screenFrame = [NSScreen mainScreen].frame;
    CGPoint winowOrigin = CGPointMake((screenFrame.size.width - windowSize.width)/2, (screenFrame.size.height - windowSize.height)/2);
    
    [self setFrame:NSMakeRect(winowOrigin.x, winowOrigin.y, windowSize.width, windowSize.height) display:NO animate:NO];
    [label setFrameOrigin:CGPointMake(LableXMargin,LableYMargin)];
}
@end
