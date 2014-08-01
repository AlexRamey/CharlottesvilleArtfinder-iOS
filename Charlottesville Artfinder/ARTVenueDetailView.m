//
//  ARTVenueDetailView.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/26/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTVenueDetailView.h"
#import "ARTVenue.h"

@implementation ARTVenueDetailView


-(id)initWithVenue:(ARTVenue *)venue
{
    
    // Initialization code
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"VenueDetailView"
                                                         owner:self
                                                       options:nil];
    
    self = [nibContents objectAtIndex:0];
    
    self.organizationName.text = venue.organizationName;
    self.organizationAddress.text = venue.streetAddress;
    self.thumbnailImage.image = [UIImage imageWithData:[venue getThumbnailData]];
    
    NSString *venueDescription = [venue.venueDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:venueDescription];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [venueDescription length])];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"American Typewriter" size:16] range:NSMakeRange(0, [venueDescription length])];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [venueDescription length])];
     
    self.aboutVenue.attributedText = attrString;
    
    [self.aboutVenue sizeToFit];
    
    self.frame = CGRectMake(0,0,320, self.aboutVenue.frame.size.height + self.aboutVenue.frame.origin.y);
    
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
