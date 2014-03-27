//
//  NCSCommentViewController.h
//  HNReader
//
//  Created by Nathan Speller on 3/26/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCSPost.h"

@interface NCSCommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NCSPost *post;
@end
