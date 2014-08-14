//
//  ARTTransportationViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/24/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTTransportationViewController.h"
#import "ARTTransportationView.h"
#import "ARTTransportationAnnotation.h"
#import <MapKit/MapKit.h>
#import "ARTKMLParser.h"
#import "UIColor+Theme.h"

@interface ARTTransportationViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) UIButton *getDirections;
@property (nonatomic, weak) UIButton *getApp;
@property (nonatomic, weak) UILabel *parkingSelection;
@property (nonatomic, weak) MKMapView *mapView;

@property (nonatomic) CLLocationCoordinate2D waterStreetGarage;
@property (nonatomic) CLLocationCoordinate2D waterStreetLot;
@property (nonatomic) CLLocationCoordinate2D marketStreetGarage;

@end

@implementation ARTTransportationViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        //custom initialization
        _waterStreetGarage = CLLocationCoordinate2DMake(38.029357, -78.480873);
        _waterStreetLot = CLLocationCoordinate2DMake(38.029534, -78.481688);
        _marketStreetGarage = CLLocationCoordinate2DMake(38.030210, -78.477815);
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ARTTransportationView *view = [[ARTTransportationView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 600)];
    
    _getDirections = view.getDirections;
    [_getDirections addTarget:self action:@selector(getDirections:) forControlEvents:UIControlEventTouchUpInside];
    
    _getApp = view.getApp;
    [_getApp addTarget:self action:@selector(getApp:) forControlEvents:UIControlEventTouchUpInside];
    
    _parkingSelection = view.parkingSelection;
    
    _mapView = view.mapView;
    _mapView.delegate = self;
    
    //Center map on correct region of downtown mall
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(38.030316, -78.480052), 500, 500);
    
    [_mapView setRegion:region animated:YES];
    [_mapView setMapType:MKMapTypeHybrid];
    
    ARTTransportationAnnotation *waterGaragePin = [[ARTTransportationAnnotation alloc] initWithCoordinate:_waterStreetGarage title:@"Water Street Garage"];
    ARTTransportationAnnotation *waterLotPin = [[ARTTransportationAnnotation alloc] initWithCoordinate:_waterStreetLot title:@"Water Street Lot"];
    ARTTransportationAnnotation *marketPin = [[ARTTransportationAnnotation alloc] initWithCoordinate:_marketStreetGarage title:@"Market Street Garage"];
    NSArray *annotations = @[waterGaragePin, waterLotPin, marketPin];
    [_mapView addAnnotations:annotations];
    
    NSArray *initiallySelectedAnnotation = @[waterGaragePin];
    [_mapView setSelectedAnnotations:initiallySelectedAnnotation];
    
    [_parkingSelection setText:@"Water Street Garage"];
    
    [_scrollView addSubview:view];
    [_scrollView setContentSize:CGSizeMake(320, 600)];
    
    NSDictionary *downtownMallPolygon = [ARTKMLParser overlaysFromKMLAtPath:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"DowntownMall" ofType:@"kml"]]];
    
    MKPolygon *downtownMallOverlay = [downtownMallPolygon objectForKey:@"DowntownMall"];
    
    [downtownMallOverlay setTitle:@"Downtown Mall"];
    
    [_mapView addOverlay:downtownMallOverlay];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getDirections:(id)sender
{
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        MKPlacemark *placemark = nil;
        
        if ([[_parkingSelection text] caseInsensitiveCompare:@"Water Street Lot"] == NSOrderedSame)
        {
            placemark = [[MKPlacemark alloc] initWithCoordinate:_waterStreetLot addressDictionary:nil];
        }
        else if ([[_parkingSelection text] caseInsensitiveCompare:@"Water Street Garage"] == NSOrderedSame)
        {
            placemark = [[MKPlacemark alloc] initWithCoordinate:_waterStreetGarage addressDictionary:nil];
        }
        else
        {
            placemark = [[MKPlacemark alloc] initWithCoordinate:_marketStreetGarage addressDictionary:nil];
        }
        
        //By default, if one map item is provided, then directions are provided from current location to the map item
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
        
        [destination setName:[_parkingSelection text]];
        
        NSArray *param = [[NSArray alloc] initWithObjects:destination, nil];
        
        //These options will launch a hybrid map with superimposed traffic information that provides driving directions
        NSDictionary *mapOptions = @{
                                     MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                     MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeHybrid],
                                     MKLaunchOptionsShowsTrafficKey:@"YES"
                                     };
        //Launch maps
        [MKMapItem openMapsWithItems:param launchOptions:mapOptions];
    }
    else
    {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Directions Unavailable" message:@"iOS 6 Required. Update." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [a show];
    }
}

-(IBAction)getApp:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/charlottesville-area-transit/id733998147?mt=8"]];
}

-(void)dealloc
{
    _mapView.delegate = nil;
}

#pragma mark - MKMapViewDelegate Methods

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [_parkingSelection setText:[[view annotation] title]];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[ARTTransportationAnnotation class]])
    {
        NSString *reuseIdentifier = @"parking";
        
        MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        
        if (!pinView)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        }
        else
        {
            pinView = [pinView initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        }
        
        [pinView setCanShowCallout:YES];
        
        return pinView;
    }
    
    return nil;
}

#pragma mark - MKMapViewDelegate Methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonRenderer *aRenderer = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon *)overlay];
        
        aRenderer.fillColor = [[UIColor ARTBlue] colorWithAlphaComponent:0.4];
        aRenderer.strokeColor = [[UIColor ARTBlue] colorWithAlphaComponent:0.6];
        aRenderer.lineWidth = 1;
        
        return aRenderer;
        
    }
    return nil;
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
