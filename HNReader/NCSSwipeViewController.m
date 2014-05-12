//
//  NCSSwipeViewController.m
//  HNReader
//
//  Created by Nathan Speller on 5/10/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSSwipeViewController.h"
#import "MBProgressHUD.h"
#import "NCSCommentCell.h"
#import "NCSComment.h"

@interface NCSSwipeViewController ()
@property (nonatomic, strong) NCSCommentCell *prototype;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, assign) CGPoint panStartingPoint;
@property (nonatomic, assign) CGPoint viewStartingPoint;
@property (nonatomic, assign) BOOL isVerticalPan;
@end

@implementation NCSSwipeViewController

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
    [self.view setClipsToBounds:YES];
    // Do any additional setup after loading the view from its nib.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self fetchData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%lu", (unsigned long)self.comments.count);
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"NCSCommentCell"
                                                                 owner:self
                                                               options:nil];
            self.prototype = [nibContents objectAtIndex:0];
            
            [self drawComments:self.comments visible:YES offset:0 parent:nil];
            [self.view bringSubviewToFront:self.backButton];
        });
    });
}

- (void)drawComments:(NSMutableArray *)array visible:(BOOL)visible offset:(CGFloat)offset parent:(NCSCommentCell *)parent{
    NSMutableArray *views = [NSMutableArray array];
    for (NCSComment *comment in array) {
        //make some views
        BOOL visibleReply = visible && (comment == array[0]);
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"NCSCommentCell"
                                                             owner:self
                                                           options:nil];
        NCSCommentCell *commentView = [nibContents objectAtIndex:0];
        CGFloat x = visibleReply ? 0 : 320;
        CGFloat y = offset;
        CGFloat height = [NCSCommentCell heightForComment:comment prototype:self.prototype];
        commentView.frame = CGRectMake(x,y,320, height);
        commentView.comment = comment;
        commentView.parentView = parent;
        [commentView refreshUI];
        [self.view addSubview:commentView];
        [parent.childViews addObject:commentView];
        [views addObject:commentView];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCommentPan:)];
        [commentView addGestureRecognizer:panGestureRecognizer];
        
        [self drawComments:comment.replies visible:visibleReply offset:height+offset parent:commentView];
    }
    for (int i=0; i<views.count; i++) {
        NCSCommentCell *commentView = views[i];
        if (commentView != views[0]) {
            commentView.leftSibling = views[i-1];
        }
        if (commentView != views[views.count-1]){
            commentView.rightSibling = views[i+1];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    NSURL *commentsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://node-hnapi.azurewebsites.net/item/%@", self.post.itemid]];
    NSData *jsonData = [NSData dataWithContentsOfURL:commentsURL];
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSArray *commentsArray = [dataDictionary objectForKey:@"comments"];
    
    self.comments = [self parseComments:commentsArray depth:0];
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

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCommentPan:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    NCSCommentCell *view = (NCSCommentCell *)panGestureRecognizer.view;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartingPoint = point;
        self.viewStartingPoint = panGestureRecognizer.view.frame.origin;
        self.isVerticalPan = fabs(velocity.y) > fabs(velocity.x);
    } else if (self.isVerticalPan) {
        if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGRect frame = view.frame;
            frame.origin.y = self.viewStartingPoint.y + (point.y - self.panStartingPoint.y);
            [view scrollFrame:frame];
            
        } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {

        }
    } else { // horizontal pan only
        if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGRect frame = view.frame;
            frame.origin.x = self.viewStartingPoint.x + (point.x - self.panStartingPoint.x);
            if ((view.leftSibling == nil && frame.origin.x > 0) || (view.rightSibling == nil && frame.origin.x < 0)) {
                frame.origin.x /= 3.0;
            }
            [view slideFrame:frame];
        } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = view.frame;
                if (velocity.x > 0 && frame.origin.x > 0 && view.leftSibling != nil) {
                    frame.origin.x = 320;
                } else if (velocity.x < 0 && frame.origin.x < 0 && view.rightSibling != nil) {
                    frame.origin.x = -320;
                } else {
                    frame.origin.x = 0;
                }
                [view slideFrame:frame];
            }];
        }
    }
}

@end