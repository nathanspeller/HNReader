//
//  NCSCommentsViewController.h
//  HNReader
//
//  Created by Nathan Speller on 10/5/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCSPost.h"

@interface NCSCommentsViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) NCSPost *post;
@end
