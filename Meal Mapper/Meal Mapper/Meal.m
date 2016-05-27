//
//  Meal.m
//  Meal Mapper
//
//  Created by Ryan King on 18/05/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import "Meal.h"

@implementation Meal

- (id) initWithName:(NSString *)name venueName:(NSString *)venueName address:(CLPlacemark *)address description:(NSString *)description goesWith:(NSString *)goesWith categoryTags:(NSMutableArray *)categoryTags image:(id)image{
    
    self.name = name;
    self.venueName = venueName;
    self.address = address;
    self.mealDescription = description;
    self.goesWith = goesWith;
    self.categoryTags = categoryTags;
    self.image = image;
    
    
    self.title = self.name;
    self.subtitle = self.venueName;
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.venueName forKey:@"venueName"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.mealDescription forKey:@"mealDescription"];
    [aCoder encodeObject:self.goesWith forKey:@"goesWith"];
    [aCoder encodeObject:self.categoryTags forKey:@"categoryTags"];
    [aCoder encodeObject:self.image forKey:@"image"];
    
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.subtitle forKey:@"subTitle"];
    
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self != nil)
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.venueName = [aDecoder decodeObjectForKey:@"venueName"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.mealDescription = [aDecoder decodeObjectForKey:@"mealDescription"];
        self.goesWith = [aDecoder decodeObjectForKey:@"goesWith"];
        self.categoryTags = [aDecoder decodeObjectForKey:@"categoryTags"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.subtitle = [aDecoder decodeObjectForKey:@"subTitle"];
        
    }
    
    return self;
}




@end
