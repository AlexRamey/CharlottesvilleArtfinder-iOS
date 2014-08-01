//
//  ARTVenueDetailView.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/26/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTVenue;
@interface ARTVenueDetailView : UIView

@property (weak, nonatomic) IBOutlet UILabel *organizationName;
@property (weak, nonatomic) IBOutlet UILabel *organizationAddress;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UIButton *getDirectionsButton;
@property (weak, nonatomic) IBOutlet UIButton *viewOnMapButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *aboutVenue;

-(id)initWithVenue:(ARTVenue *)venue;

@end
