//
//  ARTMapViewController.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/27/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class ARTObjectStore, ARTVenue;
@interface ARTMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationCoordinate2D jeffersonTheatreCoordinate;
    ARTVenue *selectedVenue;
}

@property (nonatomic, strong) ARTObjectStore *store;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *mapTypeControl;
@property (nonatomic, weak) IBOutlet UIButton *userFocus;
@property (nonatomic, weak) IBOutlet UIButton *cvilleFocus;

-(void)spotlightVenue:(ARTVenue *)venue;

-(IBAction)changeMapType:(id)sender;
-(IBAction)centerMapOnUser:(id)sender;
-(IBAction)centerMapOnCville:(id)sender;

@end
