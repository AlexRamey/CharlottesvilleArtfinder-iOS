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

@property (nonatomic, weak) IBOutlet UIButton *getDirections;
@property (nonatomic, weak) IBOutlet UIButton *getApp;
@property (nonatomic, weak) IBOutlet UILabel *parkingSelection;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end
