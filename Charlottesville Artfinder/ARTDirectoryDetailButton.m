//
//  ARTDirectoryDetailButton.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/27/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTDirectoryDetailButton.h"
#import "UIColor+Theme.h"
#import <QuartzCore/QuartzCore.h>

@implementation ARTDirectoryDetailButton

+ (CALayer *)buttonWithType:(UIButtonType)type
{
    return [super buttonWithType:UIButtonTypeCustom];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self drawButton];
        [self drawInnerGlow];
        [self drawBackgroundLayer];
        [self drawHighlightBackgroundLayer];
        
        _highlightBackgroundLayer.hidden = YES;
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)drawButton
{
    // Get the root layer (any UIView subclass comes with one)
    CALayer *layer = self.layer;
    
    layer.cornerRadius = 4.5f;
    layer.borderWidth = 1;
    layer.borderColor = [UIColor ARTOrange].CGColor;
}

- (void)drawBackgroundLayer
{
    // Check if the property has been set already
    if (!_backgroundLayer)
    {
        // Instantiate the gradient layer
        _backgroundLayer = [CAGradientLayer layer];
        
        // Set the colors
        _backgroundLayer.colors = (@[
                                     (id)[UIColor ARTOrange].CGColor,
                                     (id)[UIColor ARTDarkOrange].CGColor
                                     ]);
        
        // Set the stops
        _backgroundLayer.locations = (@[
                                        @0.0f,
                                        @1.0f
                                        ]);
        
        // Add the gradient to the layer hierarchy
        [self.layer insertSublayer:_backgroundLayer atIndex:0];
    }
}

-(void)drawHighlightBackgroundLayer
{
    // Check if the property has been set already
    if (!_highlightBackgroundLayer)
    {
        // Instantiate the gradient layer
        _highlightBackgroundLayer = [CAGradientLayer layer];
        
        // Set the colors
        _highlightBackgroundLayer.colors = (@[
                                     (id)[UIColor ARTDarkOrange].CGColor,
                                     (id)[UIColor ARTDarkOrange].CGColor
                                     ]);
        
        // Set the stops
        _highlightBackgroundLayer.locations = (@[
                                        @0.0f,
                                        @1.0f
                                        ]);
        
        // Add the gradient to the layer hierarchy
        [self.layer insertSublayer:_highlightBackgroundLayer atIndex:1];
    }
}

- (void)drawInnerGlow
{
    if (!_innerGlow)
    {
        // Instantiate the innerGlow layer
        _innerGlow = [CALayer layer];
        
        _innerGlow.cornerRadius= 4.5f;
        _innerGlow.borderWidth = 1;
        _innerGlow.borderColor = [[UIColor whiteColor] CGColor];
        _innerGlow.opacity = 0.5;
        
        [self.layer insertSublayer:_innerGlow atIndex:2];
    }
}

- (void)layoutSubviews
{
    // Set inner glow frame (1pt inset)
    _innerGlow.frame = CGRectInset(self.bounds, 1, 1);
    
    // Set gradient frame (fill the whole button))
    _backgroundLayer.frame = self.bounds;
    
    // Set inverted gradient frame
    _highlightBackgroundLayer.frame = self.bounds;
    
    [super layoutSubviews];
    
    UIImageView *buttonIcon = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 2.5, 35.0,35.0)];
    UIImage *image = nil;
    
    if (self.frame.origin.x < 100)
    {
        image = [UIImage imageNamed:@"btn_map"];
    }
    else if (self.frame.origin.x < 200)
    {
        image = [UIImage imageNamed:@"btn_directions"];
    }
    else
    {
        image = [UIImage imageNamed:@"btn_phone"];
    }
    
    [buttonIcon setContentMode:UIViewContentModeScaleAspectFit];
    [buttonIcon setImage:image];
    [self addSubview:buttonIcon];
}

- (void)setHighlighted:(BOOL)highlighted
{
    // Disable implicit animations
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    // Hide/show inverted gradient
    _highlightBackgroundLayer.hidden = !highlighted;
    
    [CATransaction commit];
    
    [super setHighlighted:highlighted];
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
