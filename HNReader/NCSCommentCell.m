//
//  NCSCommentCell.m
//  HNReader
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSCommentCell.h"
#import "NCSThreadViewController.h"

#define INDENT_TAG 2342

@implementation NCSCommentCell

static CGFloat lineHeight = 20.f;

- (void)awakeFromNib
{
    // Initialization code
    self.childViews = [NSMutableArray array];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForComment:(NCSComment *)comment prototype:(NCSCommentCell *)prototype{
    CGFloat nameWidth = prototype.commentText.frame.size.width;
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14.f];
    CGSize constrainedSize = CGSizeMake(nameWidth, 9999);
    
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = lineHeight;
    style.maximumLineHeight = lineHeight;
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          style, NSParagraphStyleAttributeName, nil];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:comment.commentText attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGFloat offset = comment.replies.count > 0 ? 83 : 50;
    
    return offset+(requiredHeight.size.height);
}

- (void)refreshUI{
    self.author.text = self.comment.author;
    self.commentText.text = self.comment.commentText;
    
    self.commentText.font = [UIFont fontWithName:@"Helvetica Neue" size:14.f];
    self.commentText.lineHeightMultiple = 1.215;
    
    if (self.comment.replies.count > 0) {
        self.repliesButton.hidden = NO;
        [self.repliesButton setTitle:[NSString stringWithFormat:@"%d responses", self.comment.replies.count] forState:UIControlStateNormal];
    } else {
        self.repliesButton.hidden = YES;
    }
    
    NSString *string = self.comment.commentText;
    [self.commentText setText:string afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString){
        
        self.commentText.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        
        return mutableAttributedString;
    }];

    
    if (self.parentView != nil) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
    }
}

@end
