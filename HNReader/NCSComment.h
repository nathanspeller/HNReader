//
//  NCSComment.h
//  HNReader
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCSComment : NSObject
@property (nonatomic, strong) NSString *commentText;
@property (nonatomic, strong) NSString *author;

- (id) initWithDictionary:(NSDictionary *)dict;
@end
