//
//  LocationMrg.m
//  AnywhereMacPack
//
//  Created by Jimmy on 11/24/15.
//

#import "LocationMrg.h"
#import "log4cplus.h"
static LocationMrg *_instance = NULL;

@implementation LocationMrg
{
    CLLocationManager *_locationMrg;
    CLGeocoder *_geoCoder;
}

+(instancetype)getInstance{
    
    if(_instance == NULL){
        _instance = [[LocationMrg alloc]init];
    }
    return _instance;
}

+(void)start{
    [[LocationMrg getInstance] startLocationService];
}

+(void)stop{
    [[LocationMrg getInstance] stopLocationService];
}

-(instancetype)init{
    if (self = [super init]) {
        _locationMrg = [[CLLocationManager alloc]init];
        _geoCoder = [[CLGeocoder alloc]init];
    }
    return self;
}

-(void)startLocationService{
    
    _locationMrg.delegate = self;
    
    _locationMrg.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationMrg.distanceFilter =  20;  //meters
    
    if([CLLocationManager locationServicesEnabled]){
        NSLog(@"location service is availiable");
        [_locationMrg startUpdatingLocation];
    }else{
        //to do later, add alert window to let user know how to open the location service.
        NSLog(@"location service is not availiable");
    }
}

-(void)stopLocationService{
    [_locationMrg stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusAuthorized){
        [_locationMrg startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if(locations.count > 0){
        
        CLLocation *newLocation = (CLLocation *)locations.lastObject;
        
        _longitude = newLocation.coordinate.longitude;
        _latitude = newLocation.coordinate.latitude;
        
        NSDate *date = newLocation.timestamp;
        _timeInterval = [date timeIntervalSinceNow];
        
        [_geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if(error){
                NSLog(@"geocode location error = %@",error.description);
            }else{
                if(placemarks.count > 0){

                    CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                    _address = [NSString stringWithFormat:@"%@ %@,%@,%@,%@",
                                         placeMark.subThoroughfare,
                                         placeMark.thoroughfare,
                                         placeMark.locality,
                                         placeMark.administrativeArea,
                                         placeMark.country];
                    NSLog(@"get address = %@",self.address);
                }else{
                    NSLog(@"palce mark count is zero");
                }
                
            }
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error){
        NSLog(@"location error = %@",error.description);
        log4cplus_error("gps", "location fetch error = %s",error.description.UTF8String);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NotifyWindow presentWithMessage:@"Fetch loaction failed, enable your Wifi or mobile network." ForTime:3];
        });
    }
}
@end
