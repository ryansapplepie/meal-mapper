//
//  Meal.h
//  Meal Mapper
//
//  Created by Ryan King on 18/05/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Meal : NSObject <NSCoding, MKAnnotation>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *venueName;
@property (nonatomic) CLPlacemark *address;
@property (nonatomic) NSString *mealDescription;
@property (nonatomic) NSString *goesWith;
@property (nonatomic) NSMutableArray *categoryTags;
@property (nonatomic) UIImage *image;

@property (nonatomic) BOOL facebookShared;
@property (nonatomic) BOOL twitterShared;
@property (nonatomic) BOOL messageShared;

- (id) initWithName:(NSString *)name venueName:(NSString *)venueName address:(CLPlacemark*)address description:(NSString *)description
            goesWith:(NSString*)goesWith categoryTags:(NSMutableArray *)categoryTags image:(UIImage *)image;


@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic)CLLocationCoordinate2D coordinate;



@end
