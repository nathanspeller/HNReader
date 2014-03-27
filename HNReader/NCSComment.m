//
//  NCSComment.m
//  HNReader
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSComment.h"

@implementation NCSComment

- (id) initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    self.commentText = dict[@"comment_text"];
    self.author = dict[@"author"];
    return self;
}

@end
