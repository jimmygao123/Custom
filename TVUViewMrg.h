//
//  ViewMrg.h

//
//  Created by Jimmy on 11/17/15.
//
//

#import <Foundation/Foundation.h>

@interface ViewMrg : NSObject

+(instancetype)getInstance;

-(void)needShowNotifyMessage:(NSString *)text inView:(UIView*)view forSeconds:(NSInteger)second;

@end
