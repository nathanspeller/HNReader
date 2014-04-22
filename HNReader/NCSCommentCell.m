//
//  NCSCommentCell.m
//  HNReader
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSCommentCell.h"

@implementation NCSCommentCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForComment:(NCSComment *)comment prototype:(NCSCommentCell *)prototype{
    CGFloat nameWidth = prototype.commentText.frame.size.width;
    UIFont *font = prototype.commentText.font;
    CGSize constrainedSize = CGSizeMake(nameWidth, 9999);
    
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 19.f;
    style.maximumLineHeight = 19.f;
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          style, NSParagraphStyleAttributeName, nil];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:comment.commentText attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return 45+(requiredHeight.size.height);
}

- (void)setComment:(NCSComment *)comment{
    _comment = comment;
    self.author.text = self.comment.author;
    self.commentText.text = self.comment.commentText;
    CGFloat commentOffset = (self.comment.depth+1)*15.0;
    if (self.comment.depth > 0){
        self.backgroundColor =[UIColor colorWithRed:0.1 green:0.0 blue:0.0 alpha:0.05];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    for(NSLayoutConstraint *constraint in self.contentView.constraints){
        if (constraint.firstAttribute == NSLayoutAttributeLeft){
            [self.contentView removeConstraint:constraint];
        }
    }
    
    NSLayoutConstraint *authorConstraint = [NSLayoutConstraint constraintWithItem:self.author
                                                                        attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:commentOffset];
    
    NSLayoutConstraint *commentConstraint = [NSLayoutConstraint constraintWithItem:self.commentText
                                                                        attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:commentOffset];

    [self.contentView addConstraint:commentConstraint];
    [self.contentView addConstraint:authorConstraint];
    
    self.commentText.numberOfLines = 0;
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 19.f;
    style.maximumLineHeight = 19.f;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName : style,};
    self.commentText.attributedText = [[NSAttributedString alloc] initWithString:comment.commentText attributes:attributes];
    [self.commentText sizeToFit];
}
@end
