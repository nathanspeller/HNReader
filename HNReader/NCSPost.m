//
//  NCSPost.m
//  HNReader
//
//  Created by Nathan Speller on 3/22/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSPost.h"
#import "NSString+HTML.h"

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

// iHackerNews
- (id) initWithiHNDictionary:(NSDictionary *)dict{
    self = [super init];
    self.title     = dict[@"title"];
    self.title     = [self.title stringByDecodingHTMLEntities];
    self.date      = nil;
    self.itemid    = dict[@"id"];
    self.submitter = dict[@"postedBy"];
    self.domain    = @"http://www.google.com";
    self.points    = dict[@"points"];
    self.comments  = dict[@"commentCount"];
    self.url       = dict[@"url"];
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    self.title     = dict[@"title"];
    self.title     = [self.title stringByDecodingHTMLEntities];
    self.date      = dict[@"date"];
    self.itemid    = dict[@"itemid"];
    self.submitter = dict[@"submitter"];
    self.domain    = dict[@"domain"];
    self.points    = dict[@"points"];
    self.comments  = dict[@"comments"];
    self.url       = dict[@"url"];
    return self;
}

@end
