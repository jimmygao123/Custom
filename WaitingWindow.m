//
//  WaitingWindow.m
//  
//
//  Created by jimmygao on 11/30/15.
//
//

#import "WaitingWindow.h"
#define WholeTime 8
#define VerMarginSub 10
#define ContentXMargin 20
#define ContentYMargin 20
extern int g_liveState;
static WaitingWindow *_instance = NULL;
@implementation WaitingWindow
{
    NSProgressIndicator *indicator;
    NSTextField *label;
    NSTimer *timer;
    int remainTime;
}

+(instancetype)getInstance{
    @synchronized(self){
        if(_instance == NULL){
            _instance = [[WaitingWindow alloc]init];
        }
        return _instance;
    }
}
+(void)dismissWaitingMessage{
    [[self getInstance] prepareForPrepresent];
}
+(void)showWaitingWithMessage:(NSString *)message andDuringTime:(int)time{
    [[self getInstance] presentWithMessage:message DuringTime:time];
}

+(void)showWaitingWhenFetchResult:(conditionBlock)condition needShowMessage:(NSString *)message WithDuringTime:(int)time{
    [[self getInstance] presentWithMessage:message DuringTime:time];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        condition();
    });
}



-(instancetype)init{
    if(self = [super init]){
        [self setStyleMask:NSBorderlessWindowMask];
        [self setReleasedWhenClosed:NO];
        [self setOpaque:YES];
        
        self.alphaValue = 0.8;
        [self setBackgroundColor:[NSColor clearColor] ];
        [self setMovableByWindowBackground:NO];
        [self setHasShadow:YES];
        
        remainTime = WholeTime;
        
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
    
    if(indicator == nil){
        indicator = [[NSProgressIndicator alloc]init];
        indicator.style = NSProgressIndicatorSpinningStyle;
        [indicator sizeToFit];
        indicator.indeterminate = YES;
        indicator.displayedWhenStopped = NO;
        
        indicator.controlTint = NSDefaultControlTint;
        indicator.controlSize = NSRegularControlSize;
    }
    
    
    if(label == nil){
        label = [[NSTextField alloc]init];
        [label setFont:[NSFont systemFontOfSize:15]];
        [label setTextColor:[NSColor whiteColor]];
        [label setBezeled:NO];
        [label setDrawsBackground:NO];
        [label setEditable:NO];
        [label setSelectable:NO];
    }
    
    [aView addSubview:indicator];
    [aView addSubview:label];
    
    [super setContentView:aView];
}

-(void)presentWithMessage:(NSString *)message DuringTime:(int)second{
   
    if(message == nil){
        NSLog(@"message is nil");
        return;
    }
    
    [self prepareForPrepresent];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doCounter) userInfo:nil repeats:YES];
    [timer fire];
    if(message.length){
        
        remainTime = second;
        [self adjustSubviewPositionNeededMessage:message];
        [indicator startAnimation:nil];
        [self makeKeyAndOrderFront:nil];
        
    }else{
        remainTime = 0;
        return;
    }
}

-(void)adjustSubviewPositionNeededMessage:(NSString*)message{
    CGSize indicatorSize = indicator.frame.size;
    CGRect screenFrame = [NSScreen mainScreen].frame;
    CGPoint indicatorOrigin = CGPointMake((screenFrame.size.width - indicatorSize.width)/2, (screenFrame.size.height - indicatorSize.height)/2);
    
    label.stringValue = message;
    [label sizeToFit];
    CGSize labelSize = label.frame.size;
    CGPoint labelOrigin = CGPointMake((screenFrame.size.width - labelSize.width)/2, indicatorOrigin.y - VerMarginSub);//below indictor
    
    
    NSRect contentViewRect = NSMakeRect(labelOrigin.x, labelOrigin.y,  labelSize.width, labelSize.height+indicatorSize.height+VerMarginSub);
    NSRect windowFrame = NSMakeRect(contentViewRect.origin.x - ContentXMargin, contentViewRect.origin.y - ContentYMargin, contentViewRect.size.width + 2*ContentXMargin, contentViewRect.size.height + 2*ContentYMargin);
    
    [self setFrame:windowFrame display:YES];
    [indicator setFrameOrigin:NSMakePoint((windowFrame.size.width - indicatorSize.width)/2, (windowFrame.size.height - indicatorSize.height)/2)];
    [label setFrameOrigin:NSMakePoint((windowFrame.size.width - labelSize.width)/2, (windowFrame.size.height - indicatorSize.height)/2 - VerMarginSub - labelSize.height)];

}

-(void)doCounter{
    remainTime--;
    NSLog(@"Jimmy_______timer = %d",remainTime);
    if(remainTime <= 0){
        [self dismiss];
    }
}

-(void)dismiss{
    [indicator stopAnimation:nil];
    remainTime = WholeTime;
    [timer invalidate];
    timer = NULL;
    [self close];
}
-(void)prepareForPrepresent{
    if(timer.isValid){
        [self dismiss];
    }else{
        if(timer){
            if(timer.valid){
                [timer invalidate];
            }
            timer = NULL;
        }
    }
}
@end
