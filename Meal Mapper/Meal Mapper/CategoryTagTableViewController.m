//
//  CategoryTagTableViewController.m
//  Meal Mapper
//
//  Created by Ryan King on 17/05/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import "CategoryTagTableViewController.h"
#import "AddMealViewController.h"
#import "MapViewController.h"

@interface CategoryTagTableViewController ()

@end

@implementation CategoryTagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.categoryCount = 0;
    if(![self.defaults objectForKey:@"tagsArray"])
    {
        self.categoryArray = [[NSMutableArray alloc]initWithObjects:@"Breakfast",@"Lunch",@"Dinner",@"Dessert",@"Pasta",@"Toast",@"Rice",@"Asian",@"Steak",@"Yummy",nil];
    }else{
        self.categoryArray = [[NSMutableArray alloc]initWithArray:[self.defaults objectForKey:@"tagsArray"]];
    }
    self.selectedCellsArray = [[NSMutableArray alloc]initWithArray:[self.defaults objectForKey:@"tagsArray"]];
    
 
    if(self.comingFromAddMeal)
    {
        self.navigationItem.rightBarButtonItems = [[NSArray alloc]initWithObjects:self.navigationItem.rightBarButtonItem,self.editButtonItem, nil];
        
    }else{
        self.navigationItem.rightBarButtonItems = [[NSArray alloc]initWithObjects:nil];
        self.navigationItem.title = @"Filter Tags";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarButton)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarButton)];
    }
    
    NSLog(@"%@",self.categoryArray);
    NSLog(@"mealViewController is %@",self.mealViewController);
    
}

- (void) cancelBarButton{
    [self performSegueWithIdentifier:@"cancelToMapSegue" sender:self];
}

- (void) doneBarButton{
    [self performSegueWithIdentifier:@"backToMapSegue" sender:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"here");
    // Return the number of rows in the section.
    return self.categoryArray.count;
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSLog(@"category count is %d",self.categoryCount);
    
        if(self.categoryCount != self.categoryArray.count)
        {
            cell.textLabel.text = [self.categoryArray objectAtIndex:self.categoryCount];
            self.categoryCount++;
        }
    
    
    
        
    
    
        
    
    // Configure the cell...
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell tapped");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedCellsArray removeObject:cell.textLabel.text];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedCellsArray addObject:cell.textLabel.text];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView beginUpdates];
        [self.categoryArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        [self.defaults setObject:self.categoryArray forKey:@"tagsArray"];
        [self.defaults synchronize];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqualToString:@"backToMapSegue"])
    {
        MapViewController *mapController = [segue destinationViewController];
        mapController.filteredTagsArray = self.selectedCellsArray;
        
    }
    
    
    
}

- (void) viewDidDisappear:(BOOL)animated{
    self.mealViewController.selectedCategoryTags = self.selectedCellsArray;
    NSLog(@"selected cells array is %@",self.selectedCellsArray);
    [super viewDidDisappear:YES];
}




- (IBAction)addCategoryTag:(id)sender {
    UIAlertView *addCategoryTagView = [[UIAlertView alloc]initWithTitle:@"New Category Tag" message:@"Enter name of new Category Tag" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done",nil];
    addCategoryTagView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addCategoryTagView textFieldAtIndex:0].returnKeyType = UIReturnKeyDone;
    [addCategoryTagView show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1)
    {
        [self.categoryArray addObject:[alertView textFieldAtIndex:0].text];
        [self.selectedCellsArray addObject:[alertView textFieldAtIndex:0].text];
        self.categoryCount = 0;
        [self.defaults setObject:self.categoryArray forKey:@"tagsArray"];
        [self.defaults synchronize];
        [self.tableView reloadData];
    }
}


@end
