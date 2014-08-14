//
//  ARTDetailViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/26/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTVenueDetailViewController.h"
#import "ARTMapViewController.h"
#import "ARTVenueDetailView.h"

@interface ARTVenueDetailViewController ()

@end

@implementation ARTVenueDetailViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        //custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ARTVenueDetailView *detail = [[ARTVenueDetailView alloc] initWithVenue:_venue];
    
    [scrollView setContentSize:CGSizeMake(detail.frame.size.width, detail.frame.size.height)];
    [scrollView addSubview:detail];
    
    [detail.viewOnMapButton addTarget:self action:@selector(viewOnMapAction:) forControlEvents:UIControlEventTouchUpInside];
    [detail.getDirectionsButton addTarget:self action:@selector(getDirectionsAction:) forControlEvents:UIControlEventTouchUpInside];
    [detail.callButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)viewOnMapAction:(id)sender
{
    self.tabBarController.selectedIndex = 0;
    
    UINavigationController *mapNav = (UINavigationController *)self.tabBarController.selectedViewController;
    if ([mapNav.viewControllers count] > 1)
    {
        [mapNav popToRootViewControllerAnimated:YES];
    }
    
    ARTMapViewController *mapViewController = (ARTMapViewController *)mapNav.viewControllers[0];
    [mapViewController spotlightVenue:_venue];
}

-(IBAction)getDirectionsAction:(id)sender
{
    UIAlertView *choice = [[UIAlertView alloc] initWithTitle:@"Directions" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Driving", @"Walking", nil];
    
    [choice show];
}

-(IBAction)callAction:(id)sender
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"])
    {
        NSString *trimmedPhoneNumber = [_venue.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *venuePhoneNumberNoWhiteSpace = [trimmedPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *venuePhoneNumberNoWhiteSpaceOrDash = [venuePhoneNumberNoWhiteSpace stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:venuePhoneNumberNoWhiteSpaceOrDash];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else
    {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Call Failed" message:@"This Device Cannot Make Calls." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [a show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *mapOptions = nil;
    NSDictionary *params = nil;
    
    if (buttonIndex == 1)
    {
        //These options will launch a hybrid map with superimposed traffic information that provides driving directions
        mapOptions = @{
                       MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                       MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeHybrid],
                       MKLaunchOptionsShowsTrafficKey:@"YES"
                       };
        params = @{@"Selected Venue" : _venue.organizationName, @"Type of Directions" : @"Driving"};
    }
    else if (buttonIndex == 2)
    {
        //These options will launch a hybrid map with superimposed traffic information that provides walking directions
        mapOptions = @{
                       MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking,
                       MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeHybrid],
                       MKLaunchOptionsShowsTrafficKey:@"YES"
                       };
        params = @{@"Selected Venue" : _venue.organizationName, @"Type of Directions" : @"Walking"};
    }
    else
    {
        return;
    }
    
    [Flurry logEvent:@"Directions Selected" withParameters:params];
    
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        
        //Create placemark object, which will be used to create MKMapItem object
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:_venue.coordinate addressDictionary:nil];
        
        //By default, if one map item is provided, then directions are provided from current location to the map item
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
        
        [destination setName:_venue.organizationName];
        
        NSArray *param = [[NSArray alloc] initWithObjects:destination, nil];
        
        //Launch maps
        if (mapOptions)
        {
            [MKMapItem openMapsWithItems:param launchOptions:mapOptions];
        }
        
    }
    else
    {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Directions Unavailable" message:@"iOS 6 Required. Update." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [a show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
