//
//  NCSCommentViewController.m
//  HNReader
//
//  Created by Nathan Speller on 3/26/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSThreadViewController.h"
#import "NCSCommentCell.h"
#import "NCSComment.h"
#import "MBProgressHUD.h"

@interface NCSThreadViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NCSCommentCell *prototype;
@end

@implementation NCSThreadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.comments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *commentCellNib = [UINib nibWithNibName:@"NCSCommentCell" bundle:nil];
    self.prototype = [commentCellNib instantiateWithOwner:self options:nil][0];
    [self.tableView registerNib:commentCellNib forCellReuseIdentifier:@"CommentCell"];
    // Do any additional setup after loading the view from its nib.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self fetchData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
}

- (void)fetchData {
    NSURL *commentsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://node-hnapi.azurewebsites.net/item/%@", self.post.itemid]];
    NSData *jsonData = [NSData dataWithContentsOfURL:commentsURL];
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSArray *commentsArray = [dataDictionary objectForKey:@"comments"];
    [self parseComments:commentsArray depth:0];
    [self.tableView reloadData];
}

- (void)parseComments:(NSArray *)array depth:(CGFloat)depth{
    for (NSDictionary *dict in array) {
        NCSComment *comment = [[NCSComment alloc] initWithDictionary:dict];
        comment.depth = depth;
        [self.comments addObject:comment];
        NSArray *nestedComments = [dict objectForKey:@"comments"];
        if (nestedComments.count > 0){
            [self parseComments:nestedComments depth:depth+1];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    NCSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    NCSComment *comment = self.comments[indexPath.row];
    [cell setComment:comment];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NCSComment *comment = self.comments[indexPath.row];
    return [NCSCommentCell heightForComment:comment prototype:self.prototype];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
