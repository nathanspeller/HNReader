//
//  NCSComment.m
//  HNReader
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSComment.h"
#import "NSString+HTML.h"

@implementation NCSComment

- (id) initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    self.commentText = dict[@"content"];
    self.commentText = [self.commentText stringByDecodingHTMLEntities];
    
    NSDictionary *stringReplacements = @{@"<p>": @"\n\n",
                                         @"<i>" : @"",
                                         @"</i>" : @""
                                         };
    for(NSString *key in stringReplacements){
        self.commentText = [self.commentText stringByReplacingOccurrencesOfString:key withString:[stringReplacements objectForKey:key]];
    }
    
    NSString *searchedString = self.commentText;
    NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *pattern = @"<a href=\"(.+?)\".*?</a>";
    NSError  *error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
    for (NSTextCheckingResult* match in matches) {
        NSString* matchText = [searchedString substringWithRange:[match range]];
        NSLog(@"match: %@", matchText);
        NSRange group1 = [match rangeAtIndex:1];
        NSLog(@"group1: %@", [searchedString substringWithRange:group1]);
        self.commentText = [regex stringByReplacingMatchesInString:self.commentText options:0 range:NSMakeRange(0, [self.commentText length]) withTemplate:@"$1"];
    }
    
    //remove trailing new lines
    self.commentText = [self.commentText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    self.author = dict[@"user"];
    return self;
}

@end
