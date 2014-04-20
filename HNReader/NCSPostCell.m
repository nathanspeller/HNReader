//
//  NCSPostCell.m
//  HNReader
//
//  Created by Nathan Speller on 3/20/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSPostCell.h"

#define POINTS_TAG 9017
#define BIG_POINTS_TAG 9018

@implementation NCSPostCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setPost:(NCSPost *)post {
    self.title.numberOfLines = 0;
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 22.f;
    style.maximumLineHeight = 22.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    self.title.attributedText = [[NSAttributedString alloc] initWithString:post.title
                                                             attributes:attributtes];
    [self.title sizeToFit];
    
    self.comments.text = [NSString stringWithFormat:@"%@", post.comments];
    if ([post.domain length] == 0) {
        self.details.text = post.submitter;
    } else {
        self.details.text = [NSString stringWithFormat:@"%@ pts · %@",post.points , post.domain];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self drawBackgroundPoints:post];
}


- (void)drawBackgroundPoints:(NCSPost *)post{
    [[self.contentView viewWithTag:POINTS_TAG]removeFromSuperview];
    [[self.contentView viewWithTag:BIG_POINTS_TAG]removeFromSuperview];
    
    // draw darker background for posts with more than 320 points
    if ([post.points doubleValue] > 320) {
        UIView *bigLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (([post.points floatValue]-320)/1.0f), [NCSPostCell heightForPost:post prototype:self])];
        bigLineView.backgroundColor = [UIColor colorWithRed:1.0 green:0.396 blue:0.0 alpha:0.10];
        bigLineView.tag = BIG_POINTS_TAG;
        [self.contentView insertSubview:bigLineView belowSubview:[self.contentView.subviews objectAtIndex:0]];
    }
    
    //draw background bar for post points
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ([post.points floatValue]), [NCSPostCell heightForPost:post prototype:self])];
    lineView.backgroundColor = [UIColor colorWithRed:1.0 green:0.396 blue:0.0 alpha:0.10];
    lineView.tag = POINTS_TAG;
    [self.contentView insertSubview:lineView belowSubview:[self.contentView.subviews objectAtIndex:0]];
}


+ (CGFloat)heightForPost:(NCSPost *)post prototype:(NCSPostCell *)prototype{
    CGFloat nameWidth = prototype.title.frame.size.width;
    UIFont *font = prototype.title.font;
    CGSize constrainedSize = CGSizeMake(nameWidth, 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName, nil];
    
    NSMutableString *encodedString = [NSMutableString stringWithString:post.title];
    [encodedString replaceOccurrencesOfString:@"&#039;" withString:@"’" options:NSCaseInsensitiveSearch range:(NSRange){0,[encodedString length]}];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:encodedString attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return 50+(requiredHeight.size.height*1.05);
}

@end
