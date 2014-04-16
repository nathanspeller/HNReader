//
//  NCSAppDelegate.m
//  HNReader
//
//  Created by Nathan Speller on 3/20/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSAppDelegate.h"
#import "NCSPostsController.h"
#import "CRGradientNavigationBar.h"

@implementation NCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    NCSPostsController *postsController = [[NCSPostsController alloc] init];
    [navigationController setViewControllers:@[postsController]];
    [self styleNavigationController:navigationController];
    
    self.window.rootViewController = navigationController;
    return YES;
}

- (void)styleNavigationController:(UINavigationController *)navigationController{
    UIColor *topColor = [UIColor colorWithRed:1.000 green:0.396 blue:0.000 alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithRed:255.0f/255.0f green:90.0f/255.0f blue:58.0f/255.0f alpha:1.0f];
    NSArray *colors = [NSArray arrayWithObjects:topColor, bottomColor, nil];
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:colors];
    [[navigationController navigationBar] setTranslucent:NO];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
