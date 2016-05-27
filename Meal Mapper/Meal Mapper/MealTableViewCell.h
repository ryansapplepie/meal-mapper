//
//  MealTableViewCell.h
//  Meal Mapper
//
//  Created by Ryan King on 23/05/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *mealImageView;
@property (nonatomic) IBOutlet UILabel *mealLabel;
@property (nonatomic) IBOutlet UILabel *venueNameLabel;
@property (nonatomic) IBOutlet UILabel *addressLabel;

@end
