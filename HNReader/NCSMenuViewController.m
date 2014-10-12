//
//  NCSMenuViewController.m
//  HNReader
//
//  Created by Nathan Speller on 5/13/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSMenuViewController.h"
#import "NCSPostsController.h"

@interface NCSMenuViewController ()
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UINavigationController *frontPageNavigationController;
@property (nonatomic, strong) UINavigationController *karmaNavigationController;
@end

@implementation NCSMenuViewController

static float openMenuPosition = 268; //open menu x position

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.frontPageNavigationController = [[UINavigationController alloc] init];
        self.frontPageNavigationController.navigationBarHidden = YES;
        NCSPostsController *frontPageController = [[NCSPostsController alloc] initWithFeedSource:@"frontPage"];
        [self.frontPageNavigationController setViewControllers:@[frontPageController]];
        
        self.karmaNavigationController = [[UINavigationController alloc] init];
        self.karmaNavigationController.navigationBarHidden = YES;
        NCSPostsController *karmaController = [[NCSPostsController alloc] initWithFeedSource:@"karma"];
        [self.karmaNavigationController setViewControllers:@[karmaController]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.container = [[UIView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.container];
    [self.container addSubview:self.karmaNavigationController.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu) name:@"toggleMenu" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleMenu
{
    float xPos = (self.container.frame.origin.x == 0) ? openMenuPosition : 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.container.frame = CGRectMake( xPos, 0, self.container.frame.size.width, self.container.frame.size.height);
    } completion:nil];
}

- (IBAction)setFrontPage:(id)sender {
    [self.container addSubview:self.frontPageNavigationController.view];
    [self toggleMenu];
}

- (IBAction)setTopFifty:(id)sender {
    [self.container addSubview:self.karmaNavigationController.view];
    [self toggleMenu];
}

@end
