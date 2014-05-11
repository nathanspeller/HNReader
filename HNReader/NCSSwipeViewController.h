//
//  NCSSwipeViewController.h
//  HNReader
//
//  Created by Nathan Speller on 5/10/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCSPost.h"

@interface NCSSwipeViewController : UIViewController
@property (nonatomic, strong) NCSPost *post;
@property (nonatomic, strong) NSMutableArray *comments;
@end
