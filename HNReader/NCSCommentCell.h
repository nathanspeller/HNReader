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

+ (CGFloat)heightForComment:(NCSComment *)comment prototype:(NCSCommentCell *)prototype;

- (void)setComment:(NCSComment *)comment;
@end
