//
//  ARTEventCategoryToggleCell.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/4/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTEventCategoryToggleCell.h"

@implementation ARTEventCategoryToggleCell

- (void)awakeFromNib
{
    // Initialization code
    [self.toggle addTarget:self action:@selector(toggleAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)toggleAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_toggle.on] forKey:[self.category.text stringByAppendingString:@"_Toggle"]];
}

@end
