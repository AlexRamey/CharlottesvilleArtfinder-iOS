//
//  ARTTransportationView.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/24/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTTransportationView.h"

@implementation ARTTransportationView

- (id)initWithFrame:(CGRect)frame
{
    // Initialization code
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TransportationContentView"
                                                         owner:self
                                                       options:nil];
    
    self = [nibContents objectAtIndex:0];
    self.frame = CGRectMake(0,0,320,600);
    
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
