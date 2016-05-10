//
//  LocationMrg.h
//  AnywhereMacPack
//
//  Created by Jimmy on 11/24/15.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NotifyWindow.h"

@interface LocationMrg : NSObject<CLLocationManagerDelegate>

@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign, readonly) double longitude;
@property (nonatomic, assign, readonly) double latitude;
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;

+(instancetype)getInstance;
+(void)start;
+(void)stop;

@end
