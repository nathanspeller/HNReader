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
#import "NCSPostCell.h"
#import "NCSClient.h"

@interface NCSThreadViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NCSCommentCell *prototype;
@property (nonatomic, strong) NCSPostCell *postPrototype;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, assign) CGFloat dragPoint;
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
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, -20, 0);;
    
    UINib *commentCellNib = [UINib nibWithNibName:@"NCSCommentCell" bundle:nil];
    self.prototype = [commentCellNib instantiateWithOwner:self options:nil][0];
    [self.tableView registerNib:commentCellNib forCellReuseIdentifier:@"CommentCell"];
    // Do any additional setup after loading the view from its nib.
    
    UINib *postCellNib = [UINib nibWithNibName:@"NCSPostCell" bundle:nil];
    self.postPrototype = [postCellNib instantiateWithOwner:self options:nil][0];
    [self.tableView registerNib:postCellNib forCellReuseIdentifier:@"PostCell"];
    
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
    self.comments = [[NCSClient instance] getCommentsForPost:self.post];
    [self.tableView reloadData];
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
    [cell refreshUI];
    cell.repliesButton.tag = indexPath.row;
    [cell.repliesButton addTarget:self action:@selector(expandResponsesForComment:) forControlEvents:UIControlEventTouchUpInside];
    if (comment.depth > 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:0.945 green:0.937 blue:0.937 alpha:1.000]];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NCSComment *comment = self.comments[indexPath.row];
    return [NCSCommentCell heightForComment:comment prototype:self.prototype];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NCSPostCell *postCell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    [postCell setPost:self.post];
    [postCell setBackgroundColor: [UIColor whiteColor]];
    return postCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [NCSPostCell heightForPost:self.post prototype:self.postPrototype];
}

- (void)expandResponsesForComment:(UIButton *)button{
    if (button.tag == self.comments.count-1 || ((NCSComment *)self.comments[button.tag+1]).depth <= ((NCSComment *)self.comments[button.tag]).depth) {
        NCSComment *comment = self.comments[button.tag];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(button.tag+1, comment.replies.count)];
        [self.comments insertObjects:comment.replies atIndexes:indexSet];
        [self.tableView reloadData];
    } else {
        NCSComment *comment = self.comments[button.tag];
        int repliesCount = 0;
        int i = button.tag+1;
        while (i < self.comments.count) {
            if (((NCSComment *)self.comments[i]).depth <= comment.depth) {
                break;
            }
            repliesCount += 1;
            i += 1;
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(button.tag+1, repliesCount)];
        [self.comments removeObjectsAtIndexes:indexSet];
        [self.tableView reloadData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.dragPoint = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y < 100) {
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backButton.alpha = 1.0;
        } completion:nil];
    } else {
    if (scrollView.contentOffset.y >= self.dragPoint) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backButton.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.backButton.alpha = 1.0;
        }];
    }
    }
}


- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end