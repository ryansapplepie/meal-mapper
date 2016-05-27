//
//  DetailViewController.h
//  Meal Mapper
//
//  Created by Ryan King on 22/04/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet UIImageView *mealImageView;
@property (nonatomic) IBOutlet UILabel *mealNameLabel;

@property (nonatomic) int tableViewRow;
@property (nonatomic) int categoryTagsNumber;

@property (nonatomic) NSString *mealName;
@property (nonatomic) UIImage *mealImage;
@property (nonatomic) NSString *mealVenueName;
@property (nonatomic) NSString *mealLocation;;
@property (nonatomic) NSString *mealDescription;
@property (nonatomic) NSString *mealGoesWith;
@property (nonatomic) NSMutableArray *mealCategoryTagsArray;


-(IBAction)returnToMapButton:(id)sender;
-(IBAction)showMapButton:(id)sender;
@property (nonatomic) IBOutlet UIButton *returnToMapButtonOutlet;
@property (nonatomic) IBOutlet UIButton *showMapButtonOutlet;
@property (nonatomic) BOOL comingFromMap;

@end

