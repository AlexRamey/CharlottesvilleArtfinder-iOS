//
//  ARTEventDetailView.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/2/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTEventDetailView.h"
#import "ARTEvent.h"

@implementation ARTEventDetailView

-(id)initWithEvent:(ARTEvent *)event selectedOnDate:(NSDate *)date
{
    
    // Initialization code
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"EventDetailView"
                                                         owner:self
                                                       options:nil];
    
    self = [nibContents objectAtIndex:0];
    
    self.eventTitle.text = event.title;
    
    NSString *startTime = nil;
    NSString *endTime = nil;
    
    if (event.startDate)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        startTime = [formatter stringFromDate:event.startDate];
        endTime = [formatter stringFromDate:event.endDate];
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        startTime = [formatter stringFromDate:date];
        endTime = @"All Day";
    }
    
    self.eventTime.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    
    NSString *category = event.category;
    UIImage *thumbnailImage = nil;
    
    if ([category caseInsensitiveCompare:@"Dance"] == NSOrderedSame)
    {
        thumbnailImage = [UIImage imageNamed:@"dancedefault"];
    }
    else if ([category caseInsensitiveCompare:@"Gallery"] == NSOrderedSame)
    {
        thumbnailImage = [UIImage imageNamed:@"gallerydefault"];
    }
    else if ([category caseInsensitiveCompare:@"Music"] == NSOrderedSame)
    {
        thumbnailImage = [UIImage imageNamed:@"musicdefault"];
    }
    else if ([category caseInsensitiveCompare:@"Theatre"] == NSOrderedSame)
    {
        thumbnailImage = [UIImage imageNamed:@"theatredefault"];
    }
    else
    {
        thumbnailImage = [UIImage imageNamed:@"venuedefault"];
    }
    
    self.thumbnailImage.image = thumbnailImage;
    
    NSString *description = [event.eventDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:description];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [description length])];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, [description length])];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [description length])];
    
    self.eventDescription.attributedText = attrString;
    
    [self.eventDescription sizeToFit];
    
    self.frame = CGRectMake(0,0,320, self.eventDescription.frame.size.height + self.eventDescription.frame.origin.y);
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
