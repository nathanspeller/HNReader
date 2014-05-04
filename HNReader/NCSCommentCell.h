//
//  NCSCommentCell.h
//  HNReader
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCSComment.h"

@interface NCSCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentText;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (nonatomic, strong) NCSComment *comment;
@property (weak, nonatomic) IBOutlet UIButton *repliesButton;

+ (CGFloat)heightForComment:(NCSComment *)comment prototype:(NCSCommentCell *)prototype;

- (void)refreshUI;
@end
