//
//  NCSPostCell.m
//  HNReader
//
//  Created by Nathan Speller on 3/20/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSPostCell.h"

#define POINTS_TAG 9017

@implementation NCSPostCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(NCSPost *)post {
    [[self.contentView viewWithTag:POINTS_TAG]removeFromSuperview];
    NSMutableString *encodedString = [NSMutableString stringWithString: post.title];
    [encodedString replaceOccurrencesOfString:@"&#039;" withString:@"’" options:NSCaseInsensitiveSearch range:(NSRange){0,[encodedString length]}];
    self.title.text = encodedString;
    self.comments.text = [NSString stringWithFormat:@"%@", post.comments];
    if ([post.domain length] == 0) {
        self.details.text = post.submitter;
    } else {
        self.details.text = [NSString stringWithFormat:@"%@ pts · %@",post.points , post.domain];
    }

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ([post.points floatValue]), 3)];
    lineView.backgroundColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.0 alpha:1.0];
    lineView.tag = POINTS_TAG;
    [self.contentView addSubview:lineView];
}

@end
