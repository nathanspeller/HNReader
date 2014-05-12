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
    
    CGFloat offset = comment.replies.count > 0 ? 83 : 50;
    
    return offset+(requiredHeight.size.height);
}

- (void)refreshUI{
    self.author.text = self.comment.author;
    self.commentText.text = self.comment.commentText;
    if (self.comment.replies.count > 0) {
        self.repliesButton.hidden = NO;
        [self.repliesButton setTitle:[NSString stringWithFormat:@"%d responses", self.comment.replies.count] forState:UIControlStateNormal];
    } else {
        self.repliesButton.hidden = YES;
    }
    
    self.commentText.numberOfLines = 0;
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 19.f;
    style.maximumLineHeight = 19.f;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName : style,};
    self.commentText.attributedText = [[NSAttributedString alloc] initWithString:self.comment.commentText attributes:attributes];
    [self.commentText sizeToFit];
    
    if (self.parentView != nil) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
    }
}

- (void)scrollFrame:(CGRect)frame
{
    [self setFrame:frame];
    [self scrollChildFrames];
    [self scrollParentFrames];
}

- (void)scrollParentFrames
{
    CGFloat parentHeight = self.parentView.frame.size.height;
    [self.parentView setFrame:CGRectMake(self.parentView.frame.origin.x, self.frame.origin.y-parentHeight, self.parentView.frame.size.width, parentHeight)];
    [self.parentView scrollParentFrames];
}

- (void)scrollChildFrames
{
    //update all children's positions
    for (NCSCommentCell *childView in self.childViews) {
        CGRect childFrame = CGRectMake(childView.frame.origin.x, self.frame.origin.y + self.frame.size.height, childView.frame.size.width, childView.frame.size.height);
        [childView setFrame:childFrame];
        [childView scrollChildFrames];
    }
}

- (void)slideFrame:(CGRect)frame
{
    NSMutableArray *centerChildren = [self visibleChildren];
    NSMutableArray *leftChildren = [self.leftSibling visibleChildren];
    NSMutableArray *rightChildren = [self.rightSibling visibleChildren];
    
    [self setFrame:frame];
    for (NCSCommentCell *commentView in centerChildren) {
        CGRect commentFrame = commentView.frame;
        commentFrame.origin.x = frame.origin.x;
        [commentView setFrame:commentFrame];
    }
    
    // move left sibling and children
    CGRect leftFrame = self.leftSibling.frame;
    leftFrame.origin.x = frame.origin.x - 320;
    if (frame.origin.y <= 0) {
        leftFrame.origin.y = 0;
    }
    [self.leftSibling scrollFrame:leftFrame];
    
    [self.leftSibling setFrame:leftFrame];
    for (NCSCommentCell *commentView in leftChildren) {
        CGRect commentFrame = commentView.frame;
        commentFrame.origin.x = frame.origin.x-320;
        [commentView setFrame:commentFrame];
    }
    
    // move right sibling and children
    CGRect rightFrame = self.rightSibling.frame;
    rightFrame.origin.x = frame.origin.x + 320;
    if (frame.origin.y <= 0) {
        rightFrame.origin.y = 0;
    }
    [self.rightSibling scrollFrame:rightFrame];
    
    [self.rightSibling setFrame:rightFrame];
    for (NCSCommentCell *commentView in rightChildren) {
        CGRect commentFrame = commentView.frame;
        commentFrame.origin.x = frame.origin.x+320;
        [commentView setFrame:commentFrame];
    }
}

- (NSMutableArray *)visibleChildren
{
    NSMutableArray *results = [NSMutableArray array];
    for (NCSCommentCell *commentView in self.childViews) {
        if (commentView.frame.origin.x == self.frame.origin.x) {
            [results addObject:commentView];
            [results addObjectsFromArray:[commentView visibleChildren]];
            break;
        }
    }
    return results;
}

@end
