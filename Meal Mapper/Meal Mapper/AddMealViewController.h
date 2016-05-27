//
//  AddMealViewController.h
//  Meal Mapper
//
//  Created by Ryan King on 22/04/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>

@class Meal;

@interface AddMealViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *mealNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *venueTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *goesWithTextField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)getLocationButton:(id)sender;
- (IBAction)facebookButton:(id)sender;
- (IBAction)twitterButton:(id)sender;
- (IBAction)imageViewGesture:(UITapGestureRecognizer *)recognizer;



@property (strong,nonatomic)  CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) CLPlacemark *currentPlacemark;
- (void) reverseGeocode:(CLLocation *)location;
- (void) forwardGeocode;

@property (nonatomic) Meal *createdMeal;
@property (nonatomic) NSMutableArray *selectedCategoryTags;

@property (nonatomic) BOOL addressIsValid;
@end
