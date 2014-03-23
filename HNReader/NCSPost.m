//
//  NCSPost.m
//  HNReader
//
//  Created by Nathan Speller on 3/22/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSPost.h"

@implementation NCSPost

- (id) initWithTitle:(NSString *)title{
    self = [super init];
    if (self){
        self.itemid = nil;
        self.title = title;
        self.submitter = nil;
        self.domain = nil;
        self.date = nil;
        self.url = nil;
        self.comments = 0;
        self.points = 0;
    }
    return self;
}

+ (id) entryWithTitle:(NSString *)title{
    return [[self alloc] initWithTitle:title];
}

@end
