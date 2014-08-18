//
//  ARTEasterEggViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/13/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTViewController.h"

@interface ARTViewController ()

@end

@implementation ARTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Creator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
