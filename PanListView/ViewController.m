//
//  ViewController.m
//  PanListView
//
//  Created by Hotaru on 2015/8/9.
//  Copyright (c) 2015年 Hotaru.I. All rights reserved.
//

#import "ViewController.h"
#import "PanListView.h"
@interface ViewController ()<PanListOperationDelegate>
@property (strong, nonatomic) PanListView *panListView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *viewIndexArray = [[NSBundle mainBundle] loadNibNamed:@"PanListView"
                                                            owner:self
                                                          options:nil];
    self.panListView = [viewIndexArray objectAtIndex:0];
    self.panListView.delegate = self;
    self.panListView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.view addSubview:self.panListView];
    
    CGRect newRect = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height * 0.3, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-[[UIScreen mainScreen] bounds].size.height * 0.3);
    [self.view addSubview:self.panListView];
    [UIView animateWithDuration:0.6f animations:^{
        self.panListView.frame = newRect;
    }];
}
-(void)changeListStatus:(ListStatus)liststatus
{
    NSLog(@"changeListStatus liststatus : %d", liststatus);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
