//
//  ARTMapViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/27/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTMapViewController.h"
#import "AppDelegate.h"
#import "ARTVenueDetailViewController.h"
#import "ARTObjectStore.h"
#import "ARTVenue.h"
#import "ARTAnnotationView.h"

@implementation ARTMapViewController

static NSString * const ART_MAP_TYPE_PREF_KEY = @"ART_MAP_TYPE_PREF_KEY";

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        _store = [ARTObjectStore sharedStore];
        
        jeffersonTheatreCoordinate = CLLocationCoordinate2DMake(38.030662, -78.481200);
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [_mapView removeAnnotations:_mapView.annotations];
        
        for (ARTVenue *venue in [_store allVenues])
        {
            [_mapView addAnnotation:venue];
        }
        
        [_locationManager startUpdatingLocation];
        [_activityIndicator startAnimating];
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSNumber *firstLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:ART_IS_FIRST_LAUNCH_KEY];
    
    if ([firstLaunch boolValue])
    {
        [[NSUserDefaults standardUserDefaults]
         setObject:@NO forKey:ART_IS_FIRST_LAUNCH_KEY];
        
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Pro Tip" message:@"Use the buttons in the top corners to quickly shift the map's focus to the downtown mall or your location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [a show];
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnsActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //NSUserDefaults integerForKey: returns 0 if no value exists
    NSInteger mapTypeValue = [[NSUserDefaults standardUserDefaults]
                              integerForKey:ART_MAP_TYPE_PREF_KEY];
    
    [_mapTypeControl setSelectedSegmentIndex:mapTypeValue];
    
    [self changeMapType:_mapTypeControl];
}

- (void)appToBackground
{
    [_mapView setShowsUserLocation:NO];
}

- (void)appReturnsActive
{
    [_mapView setShowsUserLocation:YES];
}

-(void)spotlightVenue:(ARTVenue *)venue
{
    NSArray *annotations = [_mapView annotations];
    for (ARTVenue *a in annotations)
    {
        if ([a.parseObjectID caseInsensitiveCompare:venue.parseObjectID] == NSOrderedSame)
        {
            [_mapView setRegion:MKCoordinateRegionMakeWithDistance(a.coordinate, 50, 50) animated:YES];
            [_mapView selectAnnotation:a animated:YES];
            break;
        }
    }
}

-(IBAction)changeMapType:(id)sender
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:[sender selectedSegmentIndex] forKey:ART_MAP_TYPE_PREF_KEY];
    
    switch ([sender selectedSegmentIndex])
    {
        case 0:
        {
            [_mapView setMapType:MKMapTypeStandard];
            break;
        }
        case 1:
        {
            [_mapView setMapType:MKMapTypeSatellite];
            break;
        }
        case 2:
        {
            [_mapView setMapType:MKMapTypeHybrid];
            break;
        }
    }
}

-(IBAction)centerMapOnUser:(id)sender
{
    [_mapView setCenterCoordinate:[[[_mapView userLocation] location] coordinate] animated:YES];
}

-(IBAction)centerMapOnCville:(id)sender
{
    [_mapView setCenterCoordinate:jeffersonTheatreCoordinate animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_locationManager setDelegate:nil];
}

#pragma mark - MKMapViewDelegate Methods

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[ARTVenue class]])
    {
        //Get primary category of the venue that the annotation represents
        NSString *reuseIdentifier = [((ARTVenue *)annotation) getPrimaryCategory];
        
        //Try to dequeue an existing pin first
        ARTAnnotationView *pinView = (ARTAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        
        if (!pinView)
        {
            pinView = [[ARTAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        }
        else
        {
            pinView = [pinView initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        }
        
        return pinView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    selectedVenue = (ARTVenue *)[view annotation];
    
    [self performSegueWithIdentifier:@"MapToDetail" sender:self];
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_activityIndicator stopAnimating];
    [_locationManager stopUpdatingLocation];
    
    //Get most recent location update
    CLLocation* userInitialPosition = [locations objectAtIndex:([locations count]-1)];
    
    //Create a CLLocation at The Jefferson Theater
    CLLocation *reference = [[CLLocation alloc] initWithLatitude:jeffersonTheatreCoordinate.latitude longitude:jeffersonTheatreCoordinate.longitude];
    
    if ([reference distanceFromLocation:userInitialPosition] > 5000)
    {
        //If more than 5k from JeffTheater, just zoom the map to the middle of the downtown mall
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(jeffersonTheatreCoordinate, 300, 300);
        [_mapView setRegion:region animated:YES];
    }
    else //center on their position
    {
        CLLocationCoordinate2D coord = [userInitialPosition coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
        [_mapView setRegion:region animated:YES];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
    [_locationManager stopUpdatingLocation];
    
    //In this case, just zoom the map to the middle of the downtown mall
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(jeffersonTheatreCoordinate, 250, 250);
    [_mapView setRegion:region animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [(ARTVenueDetailViewController *)[segue destinationViewController] setVenue:selectedVenue];
}

@end
