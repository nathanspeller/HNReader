//
//  NCSWebViewController.h
//  HNReader
//
//  Created by Nathan Speller on 3/23/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCSPost.h"

@interface NCSWebViewController : UIViewController
@property (nonatomic, strong) NCSPost *post;
@property (nonatomic, assign) BOOL isReadable;
@end
