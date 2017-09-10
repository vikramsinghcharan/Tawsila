//
//  HelperClass.m
//  Tawsila
//
//  Created by Sanjay on 01/08/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

#import "HelperClass.h"

@implementation HelperClass


+(CLLocationCoordinate2D )getLatLongFromAddress:(NSString *)address
{
    
    CLLocationCoordinate2D cordinate;
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@",address];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    id responce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *results =responce[@"results"];
    
    if (results.count > 0)
    {
       
        NSString *lat = [NSString stringWithFormat:@"%@",responce[@"results"][0][@"geometry"][@"location"][@"lat"]];
        NSString *lng = [NSString stringWithFormat:@"%@",responce[@"results"][0][@"geometry"][@"location"][@"lng"]];
        
        cordinate.latitude = [lat doubleValue];
        cordinate.longitude = [lng doubleValue];
        
    }
    else
    {
        cordinate.latitude = 0.0;
        cordinate.longitude = 0.0;
    }
    
    return cordinate;

}

@end
