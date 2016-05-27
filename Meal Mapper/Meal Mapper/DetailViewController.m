//
//  DetailViewController.m
//  Meal Mapper
//
//  Created by Ryan King on 22/04/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import "DetailViewController.h"
#import "MapViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mealNameLabel.text = self.mealName;
    self.navigationItem.title = self.mealName;
    self.mealImageView.image = self.mealImage;
    self.categoryTagsNumber = 0;
   
    if(self.comingFromMap)
    {
        self.returnToMapButtonOutlet.userInteractionEnabled = YES;
        self.returnToMapButtonOutlet.hidden = NO;
        self.showMapButtonOutlet.userInteractionEnabled = NO;
        self.showMapButtonOutlet.hidden = YES;
        
        //this code must be on the main thred ^^
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if(section == 0 || section == 1 || section == 2 || section == 3)
    {
    return 1;
    }else if (section == 4)
    {
        return self.mealCategoryTagsArray.count;
    }else if (section == 5)
    {
        return 2;
    }else{
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Venue Name";
            break;
        case 1:
            return @"Location:";
            break;
        case 2:
            return @"Description";
            break;
        case 3:
            return @"Goes With";
            break;
        case 4:
            return @"Tags";
            break;
        case 5:
            return @"Share via";
            break;
        default:
            return @"Error";
            break;
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int mealTagsArrayCountInt = (int)self.mealCategoryTagsArray.count;
    int categoryTagsRowMax = mealTagsArrayCountInt + 3;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    
    switch (self.tableViewRow) {
        case 0:
            cell.textLabel.text = self.mealVenueName;
            break;
        case 1:
            cell.textLabel.text = self.mealLocation;
            break;
        case 2:
            cell.textLabel.text = self.mealDescription;
            break;
        case 3:
            cell.textLabel.text = self.mealGoesWith;
            break;
        default:
            break;
    }
    
    if(self.tableViewRow <= categoryTagsRowMax && self.tableViewRow > 3)
    {
        cell.textLabel.text = [self.mealCategoryTagsArray objectAtIndex:self.categoryTagsNumber];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.userInteractionEnabled = NO;
        self.categoryTagsNumber++;
       
    
    }else if(self.tableViewRow == (categoryTagsRowMax +1))
    {
        cell.textLabel.text = @"Facebook";
        cell.imageView.image = [UIImage imageNamed:@"facebookIcon.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       // cell.userInteractionEnabled = YES;
        
    }else if(self.tableViewRow == (categoryTagsRowMax +2))
    {
        cell.textLabel.text = @"Twitter";
        cell.imageView.image = [UIImage imageNamed:@"twitterIcon.jpeg"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       // cell.userInteractionEnabled = YES;
    }
    
    self.tableViewRow++;
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.textLabel.text isEqualToString:@"Facebook"])
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *fbPostViewController= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            NSString *shareMealString = [NSString stringWithFormat:@"Check out this Meal: %@ from %@! Location: %@. Shared via Meal Mapper for iOS",self.mealName,self.mealVenueName,self.mealLocation];
            
            UIImage *sharedViaIcon = [UIImage imageNamed:@"sharedViaIcon.png"];
            UIImage *secondMealImage = self.mealImage;
            UIGraphicsBeginImageContext(self.mealImage.size);
            [secondMealImage drawInRect:CGRectMake(0, 0, self.mealImage.size.width, self.mealImage.size.height)];
            [sharedViaIcon drawInRect:CGRectMake(150,40, sharedViaIcon.size.width,sharedViaIcon.size.height)];
            UIImage *watermarkedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [fbPostViewController setTitle:@"Share your Meal!"];
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
        
    }else if (([cell.textLabel.text isEqualToString:@"Twitter"]))
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *twrPostViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            NSString *shareMealString = [NSString stringWithFormat:@"Check out this Meal: %@ from %@! Location: %@. Shared via Meal Mapper for iOS",self.mealName,self.mealVenueName,self.mealLocation];
            
            UIImage *sharedViaIcon = [UIImage imageNamed:@"sharedViaIcon.png"];
            UIImage *secondMealImage = self.mealImage;
            UIGraphicsBeginImageContext(self.mealImage.size);
            [secondMealImage drawInRect:CGRectMake(0, 0, self.mealImage.size.width, self.mealImage.size.height)];
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
    }else{
        
        UIAlertView *showMoreDetailAlertView = [[UIAlertView alloc]initWithTitle:cell.textLabel.text message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [showMoreDetailAlertView show];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)returnToMapButton:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
    
- (IBAction)showMapButton:(id)sender{
    MapViewController *mapController = (MapViewController *)[self.tabBarController.viewControllers objectAtIndex:1];
    mapController.cameFromDetail = YES;
    [mapController tabBarController:self.tabBarController didSelectViewController:mapController];
    [mapController zoomOnMeal:self.mealLocation];
    self.tabBarController.selectedViewController = mapController;
  
    
}

@end
