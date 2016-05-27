//
//  CategoryTagTableViewController.h
//  Meal Mapper
//
//  Created by Ryan King on 17/05/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewCategoryTagViewController;
@class AddMealViewController;

@interface CategoryTagTableViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic) int categoryCount;
@property (nonatomic) NSMutableArray *categoryArray;
@property (nonatomic) NewCategoryTagViewController *namingTagViewController;


- (IBAction)addCategoryTag:(id)sender;
- (void) doneBarButton;
- (void) cancelBarButton;

@property (strong,nonatomic) AddMealViewController *mealViewController;

@property (nonatomic) NSMutableArray *selectedCellsArray;
@property (nonatomic) NSUserDefaults *defaults;

@property (nonatomic) BOOL comingFromAddMeal;

@end
