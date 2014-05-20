//
//  NCSFrontPagePostCell.h
//  HNReader
//
//  Created by Nathan Speller on 5/19/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCSPost.h"

@interface NCSFrontPagePostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topDetails;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *details;
@property (weak, nonatomic) IBOutlet UILabel *comments;

+ (CGFloat)heightForPost:(NCSPost *)post prototype:(NCSFrontPagePostCell *)prototype;

- (void)setPost:(NCSPost *)post;

@end
