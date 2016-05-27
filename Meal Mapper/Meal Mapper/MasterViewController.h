//
//  MasterViewController.h
//  Meal Mapper
//
//  Created by Ryan King on 22/04/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@class Meal;
@class  DetailViewController;

@interface MasterViewController : UITableViewController 

@property (nonatomic) DetailViewController *latestMealDetailViewController;

- (IBAction)backToMasterView:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddMeal:(UIStoryboardSegue *)segue;

@property (strong,nonatomic) NSMutableArray *mealMutableArray;
@property (nonatomic) int mealArrayNumber;
@property (nonatomic) Meal *latestMeal;

@property (nonatomic) NSUserDefaults *defaults;
@property (strong,nonatomic)  CLLocationManager *locationManager;


@end

