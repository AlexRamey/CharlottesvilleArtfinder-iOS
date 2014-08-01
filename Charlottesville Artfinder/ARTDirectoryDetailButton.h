//
//  ARTDirectoryDetailButton.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/27/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTDirectoryDetailButton : UIButton

@property (strong,nonatomic) CAGradientLayer *backgroundLayer, *highlightBackgroundLayer;
@property (strong,nonatomic) CALayer *innerGlow;

@end
