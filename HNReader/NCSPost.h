//
//  NCSPost.h
//  HNReader
//
//  Created by Nathan Speller on 3/22/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCSPost : NSObject
@property (nonatomic, strong) NSString *itemid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *submitter;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *points;
@property (nonatomic, strong) NSNumber *comments;
@property (nonatomic, strong) NSNumber *date;

// Designated Initializer
- (id) initWithTitle:(NSString *)title;
- (id) initWithHerokuDictionary:(NSDictionary *)dict;
- (id) initWithiHNDictionary:(NSDictionary *)dict;
- (id) initWithDictionary:(NSDictionary *)dict;
@end
