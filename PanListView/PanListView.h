//
//  PanListView.h
//  PanListView
//
//  Created by Hotaru on 2015/8/9.
//  Copyright (c) 2015年 Hotaru.I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

typedef enum
{
    vListStatusIsTop = 0,
    vListStatusIsHalf,
    vListStatusIsBottom
}ListStatus;

@protocol PanListOperationDelegate <NSObject>

-(void)changeListStatus:(ListStatus)liststatus;
@end


@interface PanListView : UIView<UITableViewDataSource,UITableViewDelegate>{
    ListStatus myListStatus;
    float originViewHeight;
}
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *tapBtn;
@property (weak, nonatomic) IBOutlet UIImageView *centerArrowImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImg;

@property (nonatomic, retain) id<PanListOperationDelegate> delegate;

-(void)moveToTop;
-(void)moveToHalf;
-(void)moveToBottom;
@end
