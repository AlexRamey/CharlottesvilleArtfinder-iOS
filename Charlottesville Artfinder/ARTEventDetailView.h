//
//  ARTEventDetailView.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/2/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTEvent;
@interface ARTEventDetailView : UIView

@property (nonatomic, weak) IBOutlet UILabel *eventTitle;
@property (nonatomic, weak) IBOutlet UILabel *eventTime;
@property (nonatomic, weak) IBOutlet UILabel *eventDescription;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImage;
@property (nonatomic, weak) IBOutlet UIButton *calendarButton;

-(id)initWithEvent:(ARTEvent *)event selectedOnDate:(NSDate *)date;

@end
