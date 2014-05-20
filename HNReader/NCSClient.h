//
//  NCSClient.h
//  HNReader
//
//  Created by Nathan Speller on 5/19/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCSPost.h"

@interface NCSClient : NSObject

+ (NCSClient *)instance;
- (NSMutableArray *)getFrontPage;
- (NSMutableArray *)getPosts;
- (NSMutableArray *)getCommentsForPost:(NCSPost *)post;

@end
