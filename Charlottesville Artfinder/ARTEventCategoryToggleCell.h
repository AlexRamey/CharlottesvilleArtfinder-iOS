//
//  ARTEventCategoryToggleCell.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/4/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTEventCategoryToggleCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnail;
@property (nonatomic, weak) IBOutlet UILabel *category;
@property (nonatomic, weak) IBOutlet UISwitch *toggle;

@end
