//
//  AddMealViewController.m
//  Meal Mapper
//
//  Created by Ryan King on 22/04/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import "AddMealViewController.h"
#import "Meal.h"
#import "CategoryTagTableViewController.h"

@interface AddMealViewController ()

@end

@implementation AddMealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.addressIsValid = NO;
    self.selectedCategoryTags = [[NSMutableArray alloc]initWithObjects:@"Breakfast",@"Lunch",@"Dinner",@"Dessert",@"Pasta",@"Toast",@"Rice",@"Asian",
                                 @"Steak",@"Yummy",nil];
    //^default categoryTags
    
    [self.imageView.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self.imageView.layer setBorderWidth:2.0];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ALL DA METHODS

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqualToString:@"setTagsIdentifier"])
    {
        CategoryTagTableViewController *tagViewController = [segue destinationViewController];
        tagViewController.mealViewController = self;
        tagViewController.comingFromAddMeal = YES;
        
    }else if([[segue identifier]isEqualToString:@"doneAddMealIdentifier"])
    {
        
        self.createdMeal = [[Meal alloc]initWithName:self.mealNameTextField.text venueName:self.venueTextField.text address:self.currentPlacemark description:self.descriptionTextField.text goesWith:self.goesWithTextField.text categoryTags:self.selectedCategoryTags image:self.imageView.image];
        
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
  if([identifier isEqualToString:@"doneAddMealIdentifier"])
  {
      
      if(self.addressIsValid)
      {
        return YES;
          
      }else{
          NSLog(@"locationTextField text is %@",self.locationTextField.text);
          UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please obtain a location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
          [alertView show];
            return NO;
          
      }
      
  }else{
      
      return YES;
  }
    
    return YES;
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == self.locationTextField)
    {
        self.locationTextField.textColor = [UIColor grayColor];
        self.addressIsValid = NO;
    }
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    if(textField == self.locationTextField)
    {
        NSLog(@"finished editing");
        if(self.locationTextField.textColor != [UIColor blueColor])
        {
            NSLog(@"not blue colour");
            [self forwardGeocode];
        }
        //gonna check if user inputted valid address via
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    
    return YES;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"HI");
    self.currentLocation = [locations lastObject];
    
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

- (void) forwardGeocode{
    CLGeocoder *gecoder = [[CLGeocoder alloc]init];
    [gecoder geocodeAddressString:self.locationTextField.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error)
        {
            NSLog(@"Error is %@", error.description);
        }else{
            self.currentPlacemark = [placemarks lastObject];
            self.locationTextField.text = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(self.currentPlacemark.addressDictionary,NO)];
            self.locationTextField.textColor = [UIColor blueColor];
            self.addressIsValid = YES;
        }
        
    }];
    
}
- (void) reverseGeocode:(CLLocation *)location{
    CLGeocoder *geocoder  = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error)
        {
            NSLog(@"Error is %@", error.description);
            
        }else{
            self.currentPlacemark = [placemarks lastObject];
            self.locationTextField.text = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(self.currentPlacemark.addressDictionary,NO)];
            
            
        }
    }];
    
}

- (IBAction)getLocationButton:(id)sender {
    
    [self reverseGeocode:self.currentLocation];
    self.locationTextField.textColor = [UIColor blueColor];
    self.addressIsValid = YES;
}

- (IBAction)facebookButton:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbPostViewController= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *shareMealString = [NSString stringWithFormat:@"Check out this Meal! %@ from %@! Location: %@. Shared via Meal Mapper for iOS",self.mealNameTextField.text,self.venueTextField.text,self.locationTextField.text];
        
        UIImage *sharedViaIcon = [UIImage imageNamed:@"sharedViaIcon.png"];
        UIImage *secondMealImage = self.imageView.image;
        UIGraphicsBeginImageContext(secondMealImage.size);
        [secondMealImage drawInRect:CGRectMake(0, 0, secondMealImage.size.width, secondMealImage.size.height)];
        [sharedViaIcon drawInRect:CGRectMake(150,40, sharedViaIcon.size.width,sharedViaIcon.size.height)];
        UIImage *watermarkedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [fbPostViewController setInitialText:shareMealString];
        [fbPostViewController addImage:watermarkedImage];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Remember" message:@"Make sure you have at least one Facebook account setup in system settings. If you see no text try uninstalling the Facebook app from your device"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

        [self presentViewController:fbPostViewController animated:YES completion:nil];
        
        
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Something's wrong Jim!" message:@"You can't post right now, make sure your device has an internet connection and you have at least one Facebook account setup"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}


- (IBAction)twitterButton:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *twrPostViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *shareMealString = [NSString stringWithFormat:@"Check out this Meal! %@ from %@! Location: %@. Shared via Meal Mapper for iOS",self.mealNameTextField.text,self.venueTextField.text,self.locationTextField.text];
        
        UIImage *sharedViaIcon = [UIImage imageNamed:@"sharedViaIcon.png"];
        UIImage *secondMealImage = self.imageView.image;
        UIGraphicsBeginImageContext(secondMealImage.size);
        [secondMealImage drawInRect:CGRectMake(0, 0, secondMealImage.size.width, secondMealImage.size.height)];
        [sharedViaIcon drawInRect:CGRectMake(150,40, sharedViaIcon.size.width,sharedViaIcon.size.height)];
        UIImage *watermarkedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [twrPostViewController setTitle:@"Share your Meal!"];
        [twrPostViewController setInitialText:shareMealString];
        [twrPostViewController addImage:watermarkedImage];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Remember" message:@"Make sure you have at least one Twitter account setup in system settings"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

        [self presentViewController:twrPostViewController animated:YES completion:nil];
        
        
    
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Something's wrong Jim!" message:@"You can't tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    
    
}

- (IBAction)imageViewGesture:(UITapGestureRecognizer *)recognizer{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"This Device has no camera XD"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Obtain Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *pickPhotoAction = [UIAlertAction actionWithTitle:@"Pick Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:takePhotoAction];
    [alertController addAction:pickPhotoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    //[self presentViewController:picker animated:YES completion:nil];
    
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}




@end
