//
//  NCSClient.m
//  HNReader
//
//  Created by Nathan Speller on 5/19/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSClient.h"
#import "NCSPost.h"
#import "NCSComment.h"

@implementation NCSClient

+ (NCSClient *)instance
{
    static NCSClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[NCSClient alloc] init];
    });
    
    return instance;
}



- (NSMutableArray *)getPosts
{
    NSMutableArray *articles = [NSMutableArray array];
    NSURL *articlesURL = [NSURL URLWithString:@"http://hnapp.com/api/items/json/40f0eed66f239ed673554fb1e6b97315"];
    NSData *jsonData = [NSData dataWithContentsOfURL:articlesURL];
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSArray *articlesArray = [dataDictionary objectForKey:@"results"];
    
    for (NSDictionary *dict in articlesArray) {
        NCSPost *post = [[NCSPost alloc] initWithDictionary:dict];
        [articles addObject:post];
    }
    return articles;
}

- (NSMutableArray *)getCommentsForPost:(NCSPost *)post
{
    NSMutableArray *comments = [NSMutableArray array];
    NSURL *commentsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://node-hnapi.azurewebsites.net/item/%@", post.itemid]];
    NSData *jsonData = [NSData dataWithContentsOfURL:commentsURL];
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSArray *commentsArray = [dataDictionary objectForKey:@"comments"];
    comments = [self parseComments:commentsArray depth:0];
    return comments;
}

- (NSMutableArray *)parseComments:(NSArray *)array depth:(CGFloat)depth{
    NSMutableArray *comments = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        NCSComment *comment = [[NCSComment alloc] initWithDictionary:dict];
        comment.depth = depth;
        [comments addObject:comment];
        NSArray *nestedComments = [dict objectForKey:@"comments"];
        if (nestedComments.count > 0){
            comment.replies = [self parseComments:nestedComments depth:depth+1];
        }
    }
    return comments;
}
@end
