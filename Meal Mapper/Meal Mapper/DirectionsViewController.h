//
//  DirectionsViewController.h
//  Meal Mapper
//
//  Created by Ryan King on 14/06/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DirectionsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>


@property (nonatomic) NSArray *mealArray;
@property (nonatomic) CLLocationCoordinate2D currentLocationCoordinate;

@property (nonatomic) IBOutlet UITextField *fromTextField;
@property (nonatomic) IBOutlet UITextField *toTextField;

@property (nonatomic) long fromTextFieldNumber;
@property (nonatomic) long toTextFieldNumber;

@property (nonatomic) IBOutlet UISegmentedControl *transportControl;
@property (nonatomic) IBOutlet UIPickerView *namePicker;

- (void)pickerViewDone;
- (void)currentLocationButton;

@end
