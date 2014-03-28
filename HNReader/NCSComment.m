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
    self.commentText = [dict[@"content"] substringFromIndex:3];
    NSDictionary *stringReplacements = @{@"<p>": @"\n\n",
                                         @"&gt;": @">",
                                         @"<i>" : @"",
                                         @"</i>" : @""
                                         };
    for(NSString *key in stringReplacements){
        self.commentText = [self.commentText stringByReplacingOccurrencesOfString:key withString:[stringReplacements objectForKey:key]];
    }
    
    
    self.author = dict[@"user"];
    return self;
}

@end
