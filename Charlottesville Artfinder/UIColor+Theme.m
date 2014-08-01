//
//  UIColor+Theme.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "UIColor+Theme.h"

//macro for setting RGB color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (Theme)

+(UIColor *)ARTBlue
{
    return UIColorFromRGB(0x3296B8);
}

+(UIColor *)ARTGreen
{
    return UIColorFromRGB(0x30A81B);
}

+(UIColor *)ARTIndigo
{
    return UIColorFromRGB(0x4640A8);
}

+(UIColor *)ARTOrange
{
    return UIColorFromRGB(0xEB5328);
}

+(UIColor *)ARTDarkOrange
{
    return UIColorFromRGB(0xD14A24);
}

+(UIColor *)ARTPurple
{
    return UIColorFromRGB(0xBF3E81);
}

+(UIColor *)ARTThemeColorForCategory:(NSString *)category
{
    if ([category caseInsensitiveCompare:@"Dance"] == NSOrderedSame)
    {
        return [self ARTGreen];
    }
    else if ([category caseInsensitiveCompare:@"Gallery"] == NSOrderedSame)
    {
        return [self ARTBlue];
    }
    else if ([category caseInsensitiveCompare:@"Music"] == NSOrderedSame)
    {
        return [self ARTOrange];
    }
    else if ([category caseInsensitiveCompare:@"Theatre"] == NSOrderedSame)
    {
        return [self ARTPurple];
    }
    else
    {
        return [self ARTIndigo];
    }
}

@end
