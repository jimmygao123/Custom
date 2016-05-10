//
//  VolumnView.h
//  AnywhereMacPack
//
//  Created by Jimmy on 6/17/15.
//  Copyright (c) 2015 tvunetworks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VolumnView : NSView
@property (assign, nonatomic) CGFloat currentVolumn;
@property (assign, nonatomic) CGFloat maxVolumn;
@property (assign, nonatomic) BOOL isFilpLeft;
@end
