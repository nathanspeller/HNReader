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

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ([post.points floatValue]), [NCSPostCell heightForPost:post prototype:self])];
    lineView.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.94 alpha:1.0];
    lineView.tag = POINTS_TAG;
    [self.contentView insertSubview:lineView belowSubview:[self.contentView.subviews objectAtIndex:0]];
}

+ (CGFloat)heightForPost:(NCSPost *)post prototype:(NCSPostCell *)prototype{
    CGFloat nameWidth = prototype.title.frame.size.width;
    UIFont *font = prototype.title.font;
    CGSize constrainedSize = CGSizeMake(nameWidth, 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName, nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:post.title attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return 50+requiredHeight.size.height;
}

@end
