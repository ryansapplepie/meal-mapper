//
//  DirectionsViewController.m
//  Meal Mapper
//
//  Created by Ryan King on 14/06/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import "DirectionsViewController.h"
#import "Meal.h"
#import "MapViewController.h"

@interface DirectionsViewController ()

@end

@implementation DirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIToolbar *doneBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [doneBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerViewDone)];
    UIBarButtonItem *currentLocationBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrowIcon 35x35.png"] style:UIBarButtonItemStylePlain target:self action:@selector(currentLocationButton)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    doneBar.items = @[doneBarButton,flexibleSpace,currentLocationBarButton];
    [self.namePicker removeFromSuperview];
    
    
    [self.toTextField setInputView:self.namePicker];
    [self.toTextField setInputAccessoryView:doneBar];
    [self.fromTextField setInputView:self.namePicker];
    [self.fromTextField setInputAccessoryView:doneBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) currentLocationButton{
    if(self.toTextField.isFirstResponder)
    {
        [self.toTextField resignFirstResponder];
        self.toTextField.text = @"Current Location";
        self.toTextField.textColor = [UIColor blueColor];
    }
    else if(self.fromTextField.isFirstResponder)
    {
        [self.fromTextField resignFirstResponder];
        self.fromTextField.text = @"Current Location";
        self.fromTextField.textColor = [UIColor blueColor];
       
    }
}
- (void) pickerViewDone{
    if(self.mealArray.count)
    {
        Meal *meal = [self.mealArray objectAtIndex:[self.namePicker selectedRowInComponent:0]];
        if(self.toTextField.isFirstResponder)
        {
            [self.toTextField resignFirstResponder];
            self.toTextField.text = meal.name;
            self.toTextFieldNumber = [self.namePicker selectedRowInComponent:0];
        }
        else if(self.fromTextField.isFirstResponder)
        {
            [self.fromTextField resignFirstResponder];
            self.fromTextField.text = meal.name;
            self.fromTextFieldNumber = [self.namePicker selectedRowInComponent:0];
        }
        
    }else{
        if(self.toTextField.isFirstResponder)
        {
            [self.toTextField resignFirstResponder];
            
        }else if(self.fromTextField.isFirstResponder)
        {
            [self.fromTextField resignFirstResponder];
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.mealArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Meal *meal = [self.mealArray objectAtIndex:row];
    NSString *mealTitle = meal.name;
    
    
    return mealTitle;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqualToString:@"fromDirectionsToMapSegue"])
    {
        MKPlacemark *toPlacemark;
        MKPlacemark *fromPlacemark;
        MKMapItem *toMapItem;
        MKMapItem *fromMapItem;
        
        Meal *meal = [self.mealArray objectAtIndex:self.toTextFieldNumber];
        toPlacemark = [[MKPlacemark alloc]initWithCoordinate:meal.coordinate addressDictionary:nil];
        meal = [self.mealArray objectAtIndex:self.fromTextFieldNumber];
        fromPlacemark = [[MKPlacemark alloc]initWithCoordinate:meal.coordinate addressDictionary:nil];
        
        if([self.toTextField.text isEqualToString:@"Current Location"])
        {
            toPlacemark = [[MKPlacemark alloc]initWithCoordinate:self.currentLocationCoordinate addressDictionary:nil];
            toMapItem = [[MKMapItem alloc]initWithPlacemark:toPlacemark];
        }
        if([self.fromTextField.text isEqualToString:@"Current Location"])
        {
            fromPlacemark = [[MKPlacemark alloc]initWithCoordinate:self.currentLocationCoordinate addressDictionary:nil];
            fromMapItem = [[MKMapItem alloc]initWithPlacemark:fromPlacemark];
        }
            
            
            toMapItem = [[MKMapItem alloc]initWithPlacemark:toPlacemark];
            [toMapItem setName:@"destinationItem"];
            fromMapItem = [[MKMapItem alloc]initWithPlacemark:fromPlacemark];
            [fromMapItem setName:@"sourceItem"];
            
            MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
            [request setSource:fromMapItem];
            [request setDestination:toMapItem];
            switch (self.transportControl.selectedSegmentIndex) {
                case 0:
                    [request setTransportType:MKDirectionsTransportTypeAutomobile];
                    break;
                case 1:
                    [request setTransportType:MKDirectionsTransportTypeWalking];
                    break;
                case 2:
                    [request setTransportType:MKDirectionsTransportTypeAny];
                    break;
            
            }
            request.requestsAlternateRoutes = NO;
            
            MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
            
            MapViewController *mapController = [segue destinationViewController];
            mapController.directions = directions;
        
        
        
    }
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if([identifier isEqualToString:@"fromDirectionsToMapSegue"])
    {
        if([self.toTextField.text isEqualToString:@""]  || [self.fromTextField.text isEqualToString:@""])
        {
            UIAlertView *emptyTextFieldsAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill Text Fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [emptyTextFieldsAlert show];
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
        
    
}



@end
