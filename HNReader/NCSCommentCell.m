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
    self.author.text = comment.author;
    self.commentText.text = comment.commentText;
    
    self.commentText.numberOfLines = 0;
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 19.f;
    style.maximumLineHeight = 19.f;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName : style,};
    self.commentText.attributedText = [[NSAttributedString alloc] initWithString:comment.commentText attributes:attributes];
    [self.commentText sizeToFit];
}
@end
