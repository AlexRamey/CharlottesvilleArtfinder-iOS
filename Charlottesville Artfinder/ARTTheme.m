//
//  ARTTheme.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTTheme.h"
#import "UIColor+Theme.h"

@implementation ARTTheme

#warning - Consider changing the font to AmericanTypewriter

+(void)setupTheme
{
    UINavigationBar* t = [UINavigationBar appearance];
    t.barStyle = UIBarStyleDefault;
    
    //Set navigation bar's background color to theme blue and button tints to white
    t.barTintColor = [UIColor ARTBlue];
    t.tintColor = [UIColor whiteColor];
    
    //Sets navigation bar's title font and configures title shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    t.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] ,
                              NSShadowAttributeName : shadow,
                              NSFontAttributeName : [UIFont fontWithName:@"ArialMT" size:21.0] };
    
    //Configure Status Bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

@end
