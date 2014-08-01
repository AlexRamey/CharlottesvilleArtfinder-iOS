//
//  ARTTransportationView.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/24/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ARTTransportationView : UIView

@property (weak, nonatomic) IBOutlet UIButton *getDirections;
@property (weak, nonatomic) IBOutlet UIButton *getApp;
@property (weak, nonatomic) IBOutlet UILabel *parkingLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
