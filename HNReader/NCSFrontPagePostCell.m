//
//  NCSFrontPagePostCell.m
//  HNReader
//
//  Created by Nathan Speller on 5/19/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSFrontPagePostCell.h"
#import "NCSPost.h"

#define POINTS_TAG 9017
#define BIG_POINTS_TAG 9018

@implementation NCSFrontPagePostCell

static CGFloat lineHeight = 24.f;

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
    self.title.numberOfLines = 0;
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = lineHeight;
    style.maximumLineHeight = lineHeight;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName : style,};
    self.title.attributedText = [[NSAttributedString alloc] initWithString:post.title
                                                                attributes:attributes];
    [self.title sizeToFit];
    self.topDetails.text = ([post.domain length] == 0) ? @"news.ycombinator.com": post.domain;
    
    self.comments.text = [NSString stringWithFormat:@"%@", post.comments];
    if ([post.domain length] == 0) {
        self.details.text = post.submitter;
    } else {
        self.details.text = [NSString stringWithFormat:@"%@ pts by %@",post.points , post.submitter];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self drawBackgroundPoints:post];
}

- (void)drawBackgroundPoints:(NCSPost *)post{
//    [[self.contentView viewWithTag:POINTS_TAG] removeFromSuperview];
//    [[self.contentView viewWithTag:BIG_POINTS_TAG] removeFromSuperview];
//    
//    // draw darker background for posts with more than 320 points
//    if ([post.points doubleValue] > 320) {
//        UIView *bigLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (([post.points floatValue]-320)/1.0f), 8)];
//        bigLineView.backgroundColor = [UIColor colorWithRed:1.0 green:0.396 blue:0.0 alpha:0.10];
//        bigLineView.tag = BIG_POINTS_TAG;
//        [self.contentView insertSubview:bigLineView belowSubview:[self.contentView.subviews objectAtIndex:0]];
//    }
//    
//    //draw background bar for post points
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ([post.points floatValue]), 8)];
//    lineView.backgroundColor = [UIColor colorWithRed:1.0 green:0.396 blue:0.0 alpha:0.10];
//    lineView.tag = POINTS_TAG;
//    [self.contentView insertSubview:lineView belowSubview:[self.contentView.subviews objectAtIndex:0]];
}


+ (CGFloat)heightForPost:(NCSPost *)post prototype:(NCSFrontPagePostCell *)prototype{
    CGFloat nameWidth = prototype.title.frame.size.width;
    UIFont *font = prototype.title.font;
    CGSize constrainedSize = CGSizeMake(nameWidth, 9999);
    
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = lineHeight;
    style.maximumLineHeight = lineHeight;
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          style, NSParagraphStyleAttributeName, nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:post.title attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return 76+(requiredHeight.size.height);
}

@end
