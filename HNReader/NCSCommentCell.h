//
//  NCSCommentCell.h
//  HNReader
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCSComment.h"
#import "TTTAttributedLabel.h"

@interface NCSCommentCell : UITableViewCell <TTTAttributedLabel, TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *commentText;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (nonatomic, strong) NCSComment *comment;
@property (weak, nonatomic) IBOutlet UIButton *repliesButton;
@property (nonatomic, strong) NCSCommentCell *parentView;
@property (nonatomic, strong) NSMutableArray *childViews;
@property (nonatomic, strong) NCSCommentCell *leftSibling;
@property (nonatomic, strong) NCSCommentCell *rightSibling;

+ (CGFloat)heightForComment:(NCSComment *)comment prototype:(NCSCommentCell *)prototype;
+ (NCSCommentCell *)eldestParent:(NCSCommentCell *)commentCell;

- (void)refreshUI;
- (void)scrollFrame:(CGRect)frame;
- (void)slideFrame:(CGRect)frame;
@end
