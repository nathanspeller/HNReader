//
//  NCSWebViewController.m
//  HNReader
//
//  Created by Nathan Speller on 3/23/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "NCSWebViewController.h"
#import "NCSThreadViewController.h"

@interface NCSWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NCSWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *urlString = self.isReadable ? [NSString stringWithFormat:@"http://readability.com/api/content/v1/parser?url=%@&token=638795f11f38dc60749a6a43975996d296823e6b", self.post.url] : self.post.url;
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    UIBarButtonItem *commentsButton = [[UIBarButtonItem alloc] initWithTitle:@"Comments" style:UIBarButtonItemStylePlain target:self action:@selector(showComments:)];
    self.navigationItem.rightBarButtonItem = commentsButton;
}

- (void)showComments:(id)sender{
    NCSThreadViewController *commentsViewController = [[NCSThreadViewController alloc] init];
    commentsViewController.post = self.post;
    [self.navigationController pushViewController:commentsViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
