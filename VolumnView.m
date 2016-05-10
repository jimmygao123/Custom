//
//  VolumnView.m
//  AnywhereMacPack
//
//  Created by Jimmy on 6/17/15.
//  Copyright (c) 2015 tvunetworks. All rights reserved.
//

#import "VolumnView.h"
@interface VolumnView ()
@property (strong, nonatomic) CALayer *greenLayer;
@end
@implementation VolumnView

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self)
    {
        self.isFilpLeft = NO;
        self.wantsLayer = YES;
        self.maxVolumn = 40;
        self.currentVolumn = 0;
        [self.layer addSublayer:self.greenLayer];
        self.layer.bounds = self.bounds;
        self.layer.backgroundColor = [NSColor grayColor].CGColor;
        self.layer.cornerRadius = 2.0f;

    }
    return self;
}
-(void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}
-(BOOL)wantsUpdateLayer
{
    return YES;
}
-(CALayer *)greenLayer
{
    CGRect rect = self.bounds;
    rect.size.height = rect.size.height/self.maxVolumn * self.currentVolumn;
    
    if(_greenLayer == nil)
        _greenLayer = [CALayer layer];
    _greenLayer.backgroundColor = [NSColor greenColor].CGColor;
    _greenLayer.frame = rect;
    return _greenLayer;
}
@synthesize currentVolumn = _currentVolumn;
-(void)setCurrentVolumn:(CGFloat)currentVolumn
{
    _currentVolumn = currentVolumn;
    CGRect rect = self.bounds;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    if(width > height)
    {
        rect.size.width = rect.size.width/self.maxVolumn * currentVolumn;
    }
    else
    {
        rect.size.height = rect.size.height/self.maxVolumn * currentVolumn;
    }
    
    if(self.greenLayer == nil)
    {
        self.greenLayer = [CALayer layer];
        CGFloat green = rect.size.width > rect.size.height ? rect.size.width : rect.size.height;
        self.greenLayer.backgroundColor = [NSColor colorWithRed:0 green:green blue:0 alpha:1].CGColor;
    }
    if(self.isFilpLeft)
        rect.origin.x = width - rect.size.width;
    self.greenLayer.frame = rect;
}
@end
