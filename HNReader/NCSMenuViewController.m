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
@property (nonatomic, strong) UINavigationController *navigationController;
@end

@implementation NCSMenuViewController

static float openMenuPosition = 268; //open menu x position

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController = [[UINavigationController alloc] init];
        self.navigationController.navigationBarHidden = YES;
        NCSPostsController *postsController = [[NCSPostsController alloc] init];
        [self.navigationController setViewControllers:@[postsController]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.container = [[UIView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.container];
    [self.container addSubview:self.navigationController.view];
    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"frontPage" forKey:@"feedSource"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedFeedSource" object:self];
    [self toggleMenu];
}

- (IBAction)setTopFifty:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"karma" forKey:@"feedSource"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedFeedSource" object:self];
    [self toggleMenu];
}

@end
