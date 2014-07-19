//
//  NCSPostsController.m
//  HNReader
//
//  Created by Nathan Speller on 3/20/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSPostsController.h"
#import "NCSPostCell.h"
#import "NCSFrontPagePostCell.h"
#import "NCSPostsController.h"
#import "NCSPost.h"
#import "NCSWebViewController.h"
#import "NCSThreadViewController.h"
#import "MBProgressHUD.h"
#import "NCSClient.h"

@interface NCSPostsController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, strong) NCSPostCell *prototype;
@property (nonatomic, strong) NCSFrontPagePostCell *frontPagePrototype;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *listTitle;
@property (nonatomic, strong) NSString *feedSource;
@end

@implementation NCSPostsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.articles = [NSMutableArray array];
    }
    return self;
}

- (id)initWithFeedSource:(NSString *)feedSource
{
    self = [super init];
    if (self) {
        self.feedSource = feedSource;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Hacker News";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchData)
                                                 name:@"updatedFeedSource"
                                               object:nil];

    [self.tableView setSeparatorColor:[UIColor colorWithRed:1.000 green:0.396 blue:0.000 alpha:0.500]];
    
    UINib *postCellNib = [UINib nibWithNibName:@"NCSPostCell" bundle:nil];
    [self.tableView registerNib:postCellNib forCellReuseIdentifier:@"PostCell"];
    self.prototype = [postCellNib instantiateWithOwner:self options:nil][0];
    
    UINib *frontPagePostCellNib = [UINib nibWithNibName:@"NCSFrontPagePostCell" bundle:nil];
    [self.tableView registerNib:frontPagePostCellNib forCellReuseIdentifier:@"FrontPagePostCell"];
    self.frontPagePrototype = [frontPagePostCellNib instantiateWithOwner:self options:nil][0];
    
    // show loading HUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self fetchData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
    
    if ([self.feedSource isEqualToString:@"karma"]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    // pull-to-refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self fetchData];
    [refreshControl endRefreshing];
}

- (void)fetchData {
    self.articles = [[NCSClient instance] getPosts];
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
    NCSWebViewController *webViewController = [[NCSWebViewController alloc] init];
    webViewController.post = self.articles[indexPath.row];
    [self.view.window.rootViewController presentViewController:webViewController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.feedSource  isEqual: @"karma"]) {
        NCSPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
        
        UISwipeGestureRecognizer* sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
        [sgr setDirection:UISwipeGestureRecognizerDirectionLeft];
        [cell addGestureRecognizer:sgr];
        
        NCSPost *post = [self.articles objectAtIndex:indexPath.row];
        [cell setPost:post];
        //        cell.rank.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
        return cell;
    } else {
        NCSFrontPagePostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FrontPagePostCell"];
        
        UISwipeGestureRecognizer* sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
        [sgr setDirection:UISwipeGestureRecognizerDirectionLeft];
        [cell addGestureRecognizer:sgr];
        
        NCSPost *post = [self.articles objectAtIndex:indexPath.row];
        [cell setPost:post];
        cell.rank.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NCSPost *post = self.articles[indexPath.row];
    if ([self.feedSource isEqualToString:@"karma"]) {
        return [NCSPostCell heightForPost:post prototype:self.prototype];
    } else {
        return [NCSFrontPagePostCell heightForPost:post prototype:self.frontPagePrototype];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //move title paralax
    CGRect newFrame = CGRectMake(0,-0.5*self.tableView.contentOffset.y-20, 320, 130);
    self.headerView.alpha = 1-self.tableView.contentOffset.y/120;
    self.headerView.frame = newFrame;
}

- (void)cellSwiped:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
        
        NCSThreadViewController *commentsViewController = [[NCSThreadViewController alloc] init];
        commentsViewController.post = [self.articles objectAtIndex:swipedIndexPath.row];
        [self.navigationController pushViewController:commentsViewController animated:YES];
    }
}
- (IBAction)onMenuButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMenu" object:nil];
}



@end
