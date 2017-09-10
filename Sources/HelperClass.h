//
//  HelperClass.h
//  Tawsila
//
//  Created by Sanjay on 01/08/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface HelperClass : NSObject

+(CLLocationCoordinate2D )getLatLongFromAddress:(NSString *)address;

@end
