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
#import "NCSWebViewController.h"
#import "NCSCommentsViewController.h"
#import "MBProgressHUD.h"

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
//    [self.tableView setSeparatorColor:[UIColor colorWithRed:1.000 green:0.396 blue:0.000 alpha:0.500]];
    
    // show loading HUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self fetchData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
    
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
    NSURL *articlesURL = [NSURL URLWithString:@"http://hnapp.com/api/items/json/40f0eed66f239ed673554fb1e6b97315"];
    NSData *jsonData = [NSData dataWithContentsOfURL:articlesURL];
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSArray *articlesArray = [dataDictionary objectForKey:@"results"];
    
    self.articles = [NSMutableArray array];
    
    for (NSDictionary *dict in articlesArray) {
        NCSPost *post = [[NCSPost alloc] initWithDictionary:dict];
        [self.articles addObject:post];
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
    
    //one
    NCSWebViewController *webView = [[NCSWebViewController alloc] init];
    webView.post = self.articles[indexPath.row];
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:webView];
    firstNavigationController.tabBarItem.title = @"Web";
    
    //two
    NCSWebViewController *readingView = [[NCSWebViewController alloc] init];
    readingView.post = self.articles[indexPath.row];
    readingView.isReadable = YES;
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:readingView];
    secondNavigationController.tabBarItem.title = @"Reading";
    
    //comments
    NCSCommentsViewController *commentsView = [[NCSCommentsViewController alloc] init];
    commentsView.post = self.articles[indexPath.row];
    UINavigationController *thirdNavigationController = [[UINavigationController alloc] initWithRootViewController:commentsView];
    thirdNavigationController.tabBarItem.title = @"Comments";
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[firstNavigationController, secondNavigationController, thirdNavigationController];
    [tabBarController setSelectedIndex:1];
    [self.navigationController pushViewController:tabBarController animated:YES];
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
    [cell setPost:post];
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
    
    return 56+requiredHeight.size.height;
}




@end
