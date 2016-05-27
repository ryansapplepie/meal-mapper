//
//  MapViewController.h
//  Meal Mapper
//
//  Created by Ryan King on 25/05/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>

@class CategoryTagTableViewController;

@interface MapViewController : UIViewController <MKMapViewDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic) NSUserDefaults *defaults;
@property (nonatomic) CategoryTagTableViewController *tagTableView;

@property (nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) NSArray *latestDecodedArray;

-(IBAction)editCategoryTagsBarButton:(id)sender;

- (IBAction)backToMap:(UIStoryboardSegue *)segue;
- (IBAction)cancelToMap:(UIStoryboardSegue *)segue;
- (IBAction)fromDirectionsToMap:(UIStoryboardSegue *)segue;


- (void) zoomOnMeal:(NSString *)mealLocation;
- (void)clearPolyline;

@property (nonatomic) BOOL cameFromDetail;

@property (nonatomic) NSMutableArray *filteredTagsArray;

@property (nonatomic) CLLocationCoordinate2D currentLocationCoordinate;

@property (nonatomic) MKDirections *directions;

@property (nonatomic) IBOutlet UINavigationItem *navigation;
@property (nonatomic) UIBarButtonItem *clearBarButtonItem;


@end
