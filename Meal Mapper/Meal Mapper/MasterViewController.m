//
//  MasterViewController.m
//  Meal Mapper
//
//  Created by Ryan King on 22/04/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MealTableViewCell.h"
#import "AddMealViewController.h"
#import "Meal.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
    

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.mealMutableArray = [[NSMutableArray alloc]init];
    self.mealArrayNumber = 0;
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.tableView.rowHeight = 70;
    
    NSData *decodedObject = [self.defaults objectForKey:@"mealArray"];
    NSArray *decodedMealArray = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    self.mealMutableArray = [[NSMutableArray alloc]initWithArray:decodedMealArray];
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backToMasterView:(UIStoryboardSegue *)segue{
    AddMealViewController *mealViewController = [segue sourceViewController];
    self.latestMeal = mealViewController.createdMeal;
    [self.mealMutableArray addObject:self.latestMeal];
    self.mealArrayNumber = 0;
    [self.tableView reloadData];
    
    NSArray *mealArray = [[NSArray alloc]initWithArray:self.mealMutableArray];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mealArray];
    [self.defaults setObject:data forKey:@"mealArray"];
    [self.defaults synchronize];
    
}

- (IBAction)cancelAddMeal:(UIStoryboardSegue *)segue{
    
    
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showMealDetail"])
    {
        self.latestMealDetailViewController = [segue destinationViewController];
        
    }

    
}

#pragma mark - Table View

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger indexRow = indexPath.row;
    Meal *selectedMeal = [self.mealMutableArray objectAtIndex:indexRow];
    self.latestMealDetailViewController.mealName = selectedMeal.name;
    self.latestMealDetailViewController.mealImage = selectedMeal.image;
    self.latestMealDetailViewController.mealCategoryTagsArray = selectedMeal.categoryTags;
    self.latestMealDetailViewController.mealVenueName = selectedMeal.venueName;
    self.latestMealDetailViewController.mealLocation = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(selectedMeal.address.addressDictionary,NO)];
    self.latestMealDetailViewController.mealDescription = selectedMeal.mealDescription;
    self.latestMealDetailViewController.mealGoesWith = selectedMeal.goesWith;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return [[self.fetchedResultsController sections] count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mealMutableArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mealTableCell" forIndexPath:indexPath];
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"MealTableCell" bundle:nil] forCellReuseIdentifier:@"mealTableCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"mealTableCell" forIndexPath:indexPath];
    }
    
    if(self.mealArrayNumber != self.mealMutableArray.count)
    {
        Meal *currentMeal = [self.mealMutableArray objectAtIndex:self.mealArrayNumber];
        cell.mealLabel.text = currentMeal.name;
        cell.venueNameLabel.text = currentMeal.venueName;
        cell.addressLabel.text = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(currentMeal.address.addressDictionary,NO)];
        cell.mealImageView.image = currentMeal.image;
        self.mealArrayNumber++;
    }
   
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    
        [tableView beginUpdates];
        NSLog(@"array is %@",self.mealMutableArray);
        NSLog(@"indexpathrow is %ld",(long)indexPath.row);
        [self.mealMutableArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        
        NSArray *mealArray = [[NSArray alloc]initWithArray:self.mealMutableArray];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mealArray];
        [self.defaults setObject:data forKey:@"mealArray"];
        [self.defaults synchronize];
        
    }
}







/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
