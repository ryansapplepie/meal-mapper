//
//  MapViewController.m
//  Meal Mapper
//
//  Created by Ryan King on 25/05/15.
//  Copyright (c) 2015 Ryan King. All rights reserved.
//

#import "MapViewController.h"
#import "Meal.h"
#import "DetailViewController.h"
#import "CategoryTagTableViewController.h"
#import "DirectionsViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.tabBarController.delegate = self;
    
    self.clearBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearPolyline)];
    NSLog(@"viewDidLoad");
    
}

- (void)clearPolyline{
    [self.mapView removeOverlays:self.mapView.overlays];
    self.navigation.rightBarButtonItems = [[NSArray alloc]initWithObjects:self.navigation.rightBarButtonItem,nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if(self.cameFromDetail)
    {
        self.defaults = [NSUserDefaults standardUserDefaults];
        //in case view did load is called after this method
    }
    if(viewController == self)
    {
        [self.mapView removeAnnotations:[self.mapView annotations]];
        
        NSData *decodedObject = [self.defaults objectForKey:@"mealArray"];
        NSArray *decodedMealArray = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
        self.latestDecodedArray = [[NSArray alloc]initWithArray:decodedMealArray];
        if(decodedMealArray.count != 0)
        {
            for(int i = 0;i < decodedMealArray.count || i == 0; i++)
            {
                //NSLog(@"i is %d",i);
                NSLog(@"decodedMealArray is %@",decodedMealArray);
                Meal *meal = [decodedMealArray objectAtIndex:i];
                //NSLog(@"%@",meal);
                meal.coordinate = meal.address.location.coordinate;
            
                if(self.cameFromDetail)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:meal];

                    });
                }else{
                    [self.mapView addAnnotation:meal];
                }
                
            
            }
        }else{
            NSLog(@"decodedMealArray is nil");
        }
        
       
    }
    
}


- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[Meal class]])
    {
        Meal *meal = (Meal*)annotation;
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:meal reuseIdentifier:@"mealIdentifier"];
        
        
        UIGraphicsBeginImageContext(CGSizeMake(40, 40));
        [meal.image drawInRect:CGRectMake(0, 0, 40, 40)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        annotationView.image = meal.image;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:newImage];
        annotationView.rightCalloutAccessoryView =  [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.frame =  CGRectMake(0, 0, 40, 40);
        
        //NSLog(@"%f, %f",annotationView.frame.size.width,annotationView.frame.size.height);
        return annotationView;
    }else{
        if(!self.cameFromDetail)
        {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude+0.002);
            self.currentLocationCoordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
            //^to pass to direcitonsViewController^
            MKCoordinateRegion userLocationView = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
            [self.mapView setRegion:userLocationView animated:YES];
        }
        
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"currentLocationIdentifier"];
        annotationView.image = [UIImage imageNamed:@"currentLocationIcon.png"];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.frame = CGRectMake(0, 0, 40, 40);
        
        return annotationView;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqualToString:@"directionsSegue"])
    {
        UINavigationController *navigationController = [segue destinationViewController];
        DirectionsViewController *destinationDirectionsController = [navigationController.viewControllers objectAtIndex:0];
        destinationDirectionsController.mealArray = self.latestDecodedArray;
        destinationDirectionsController.currentLocationCoordinate = self.currentLocationCoordinate;
        
    }
    
}




- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailViewController *mealDetailController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [mealDetailController setModalPresentationStyle:UIModalPresentationFullScreen];
    Meal *meal = (Meal*)view.annotation;
    
    mealDetailController.mealName = meal.name;
    mealDetailController.mealVenueName = meal.venueName;
    mealDetailController.mealImage = meal.image;
    mealDetailController.mealCategoryTagsArray = meal.categoryTags;
    mealDetailController.mealGoesWith = meal.goesWith;
    mealDetailController.mealDescription = meal.mealDescription;
    mealDetailController.mealLocation = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(meal.address.addressDictionary,NO)];
    //mealDetailController.mealLocation = @"TEMP";
    
    mealDetailController.comingFromMap = YES;
    [self presentViewController:mealDetailController animated:YES completion:nil];
   
    
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        polylineRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineRenderer.lineWidth = 2.0;
        return polylineRenderer;
    }else{
        return nil;
    }
    
}

- (IBAction)editCategoryTagsBarButton:(id)sender{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.tagTableView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CategoryTagsViewController"];
    [self presentViewController:self.tagTableView animated:YES completion:nil];
    
    
}

- (IBAction)fromDirectionsToMap:(UIStoryboardSegue *)segue{
    NSLog(@"fromDirectionsToMap");
    self.navigation.rightBarButtonItems = [[NSArray alloc]initWithObjects:self.navigation.rightBarButtonItem,self.clearBarButtonItem,nil];
    
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if(error)
        {
            NSLog(@"error is %@",error.description);
            UIAlertView *errorAlertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to find directions for this transportation" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [errorAlertView show];
        }else{
            NSArray *routesArray = [response routes];
            NSLog(@"routes array is %@",routesArray);
            [routesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MKRoute *route = obj;
                MKPolyline *line = [route polyline];
                [self.mapView removeOverlays:self.mapView.overlays];
                [self.mapView addOverlay:line];
            }];
        }
        
    }];
    
}
- (IBAction)backToMap:(UIStoryboardSegue *)segue{
    NSLog(@"selected tags are %@",self.filteredTagsArray);
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if(self.latestDecodedArray.count != 0)
    {
        for(int i = 0;i < self.latestDecodedArray.count || i == 0; i++)
        {
            //NSLog(@"i is %d",i);
            //NSLog(@"decodedMealArray is %@",decodedMealArray);
            Meal *meal = [self.latestDecodedArray objectAtIndex:i];
            //NSLog(@"%@",meal);
            meal.coordinate = meal.address.location.coordinate;
            
            int b = 0;
            int c = 0;
            int invalidTags = 0;
            BOOL finishedFiltering = NO;
            do{
                
                NSLog(@"c is %d",c);
                NSLog(@"meal tags %lu",(unsigned long)meal.categoryTags.count);
                NSLog(@"b is %d",b);
                NSLog(@"filteredTagsArray is %lu",(unsigned long)self.filteredTagsArray.count);
                
                if(invalidTags > c)
                {
                    c++;
                    //^lol^
                    b = 0;
                }
                
                
                
                if([[self.filteredTagsArray objectAtIndex:b]isEqualToString:[meal.categoryTags objectAtIndex:c]])
                {
                    
                    NSLog(@"found match");
                    [self.mapView addAnnotation:meal];
                    NSLog(@"filteredTagsArrayObject is %@",[self.filteredTagsArray objectAtIndex:b]);
                    NSLog(@"cateGoryTags is %@",[meal.categoryTags objectAtIndex:c]);
                    finishedFiltering = YES;
                }else{
                    NSLog(@"filteredTagsArrayObject is %@",[self.filteredTagsArray objectAtIndex:b]);
                    NSLog(@"cateGoryTags is %@",[meal.categoryTags objectAtIndex:c]);
                    b++;
                    if(b >= self.filteredTagsArray.count)
                    {
                        invalidTags++;
                    }
                    if(invalidTags == meal.categoryTags.count)
                    {
                        finishedFiltering = YES;
                    }
                }
                
                
                NSLog(@"looped");
            }while(!finishedFiltering);
            
            
        }
    }else{
        NSLog(@"decodedMealArray is nil");
    }

}

- (IBAction)cancelToMap:(UIStoryboardSegue *)segue{
    
}


- (void)zoomOnMeal:(NSString *)mealLocation{
    if(mealLocation)
    {
        CLGeocoder *gecoder = [[CLGeocoder alloc]init];
        [gecoder geocodeAddressString:mealLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if(error)
            {
                NSLog(@"Error is %@", error.description);
            }else{
                CLPlacemark *placeMark = [placemarks lastObject];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(placeMark.location.coordinate.latitude, placeMark.location.coordinate.longitude+0.002);
                MKCoordinateRegion mealRegion = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
                [self.mapView setRegion:mealRegion animated:YES];
            
            }
        
        }];
    }
    
}


@end
