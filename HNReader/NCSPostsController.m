//
//  NCSPostsController.m
//  HNReader
//
//  Created by Nathan Speller on 3/20/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSPostsController.h"
#import "NCSPostCell.h"
#import "NCSPostsController.h"
#import "NCSPost.h"

#define POINTS_TAG 9017

@interface NCSPostsController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articles;
@end

@implementation NCSPostsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Hacker News";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1.0];
    
    NSURL *articlesURL = [NSURL URLWithString:@"http://hnapp.com/api/items/json/40f0eed66f239ed673554fb1e6b97315"];
    NSData *jsonData = [NSData dataWithContentsOfURL:articlesURL];
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    self.articles = [NSMutableArray array];
    
    NSArray *articlesArray = [dataDictionary objectForKey:@"results"];
    
    for (NSDictionary *bpDictionary in articlesArray) {
        NCSPost *en = [NCSPost entryWithTitle:[bpDictionary objectForKey:@"title"]];
        en.date = [bpDictionary objectForKey:@"date"];
        en.itemid = [bpDictionary objectForKey:@"itemid"];
        en.submitter = [bpDictionary objectForKey:@"submitter"];
        en.domain = [bpDictionary objectForKey:@"domain"];
        en.points = [bpDictionary objectForKey:@"points"];
        en.comments = [bpDictionary objectForKey:@"comments"];
        en.url = [NSURL URLWithString:[bpDictionary objectForKey:@"url"]];
        [self.articles addObject:en];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PostCell";
    
    NCSPostCell *cell = (NCSPostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NCSPostCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    NCSPost *post = [self.articles objectAtIndex:indexPath.row];
    
    [[cell.contentView viewWithTag:POINTS_TAG]removeFromSuperview];
    NSMutableString *encodedString = [NSMutableString stringWithString: post.title];
    [encodedString replaceOccurrencesOfString:@"&#039;" withString:@"’" options:NSCaseInsensitiveSearch range:(NSRange){0,[encodedString length]}];
    cell.title.text = encodedString;
    if ([post.domain length] == 0) {
        cell.details.text = post.submitter;
    } else {
        cell.details.text = [NSString stringWithFormat:@"%@ · %@",post.domain ,post.submitter];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ([post.points floatValue]/2), 3)];
    lineView.backgroundColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.0 alpha:1.0];
    
    lineView.tag = POINTS_TAG;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize constrainedSize = CGSizeMake(290, 9999);

    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"HelveticaNeue" size:18.0], NSFontAttributeName,
                                          nil];
    NCSPost *post = self.articles[indexPath.row];
    NSString *text = post.title;
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return 50+requiredHeight.size.height;
}




@end
