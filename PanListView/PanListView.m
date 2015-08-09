//
//  PanListView.m
//  PanListView
//
//  Created by Hotaru on 2015/8/9.
//  Copyright (c) 2015年 Hotaru.I. All rights reserved.
//

#import "PanListView.h"

#define screenHeight [[UIScreen mainScreen] bounds].size.height
#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define halfScreenHeight screenHeight/2
#define tapViewHeight 44
#define withTopConstraint [[UIScreen mainScreen] bounds].size.height * 0.3

#define upArrowImgName @"icon_up"
#define downArrowImgName @"icon_down"

#define BottomscrollPoint4 [[UIScreen mainScreen] bounds].size.height * 0.3
#define BottomscrollPoint3 ([[UIScreen mainScreen] bounds].size.height/2) - (tapViewHeight*2)
#define BottomscrollPoint2 [[UIScreen mainScreen] bounds].size.height - tapViewHeight
#define BottomscrollPoint1 [[UIScreen mainScreen] bounds].size.height

#define HalfscrollPoint4 [[UIScreen mainScreen] bounds].size.height * 0.3
#define HalfscrollPoint3 ([[UIScreen mainScreen] bounds].size.height/2) - (tapViewHeight*2)
#define HalfscrollPoint2 ([[UIScreen mainScreen] bounds].size.height/2) + tapViewHeight
#define HalfscrollPoint1 [[UIScreen mainScreen] bounds].size.height

#define TopscrollPoint4 [[UIScreen mainScreen] bounds].size.height * 0.3
#define TopscrollPoint3 [[UIScreen mainScreen] bounds].size.height - (tapViewHeight*2)
#define TopscrollPoint2 [[UIScreen mainScreen] bounds].size.height/2 - tapViewHeight
#define TopscrollPoint1 [[UIScreen mainScreen] bounds].size.height

@implementation PanListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        myListStatus = vListStatusIsTop;
        
        originViewHeight = screenHeight - withTopConstraint;
        
        self.window = ((AppDelegate*) [UIApplication sharedApplication].delegate).window;
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:_panGesture];
    }
    return self;
}


-(void)changePlaceListStatus:(ListStatus )nowlistStatue{
    
    switch (nowlistStatue) {
        case vListStatusIsTop:{
            [self moveToTop];
        }
            break;
        case vListStatusIsHalf:{
            [self moveToHalf];
        }
            break;
        case vListStatusIsBottom:{
            [self moveToBottom];
        }
            break;
        default:
            break;
    }
    [self.delegate changeListStatus:myListStatus];
}


#pragma mark ------set position------

-(void)moveToTop{
    self.hidden = NO;
    self.centerArrowImg.image = [UIImage imageNamed:downArrowImgName];
    [self.tapBtn setTitle:@"" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.frame = CGRectMake(0, withTopConstraint, self.frame.size.width, originViewHeight);
                         
                     } completion:^(BOOL finished) {
                         self.centerArrowImg.hidden = NO;
                         self.rightArrowImg.hidden = YES;
                         self.tableView.frame = CGRectMake(0, tapViewHeight, self.bounds.size.width, self.bounds.size.height-tapViewHeight);
                         
                     }];
    myListStatus = vListStatusIsTop;
}
-(void)moveToHalf{
    
    self.centerArrowImg.image = [UIImage imageNamed:upArrowImgName];
    [self.tapBtn setTitle:@"" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.frame = CGRectMake(0, screenHeight/2 - tapViewHeight , self.bounds.size.width, screenHeight/2+tapViewHeight);
                         
                     } completion:^(BOOL finished) {
                         self.centerArrowImg.hidden = NO;
                         self.rightArrowImg.hidden = YES;
                         self.tableView.frame = CGRectMake(0, tapViewHeight, self.bounds.size.width, screenHeight/2);
                         
                     }];
    myListStatus = vListStatusIsHalf;
}
-(void)moveToBottom{
    
    self.rightArrowImg.image = [UIImage imageNamed:upArrowImgName];
    
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.frame = CGRectMake(0, screenHeight-tapViewHeight, self.bounds.size.width, originViewHeight);
                         
                     } completion:^(BOOL finished) {
                         self.rightArrowImg.hidden = NO;
                         self.centerArrowImg.hidden = YES;
                         [self.tapBtn setTitle:@"More" forState:UIControlStateNormal];
                     }];
    myListStatus = vListStatusIsBottom;
}

#pragma mark ------IBAction------

- (IBAction)tabAction:(id)sender{
    
    if (myListStatus == vListStatusIsTop) {
        [self changePlaceListStatus:vListStatusIsBottom];
        
    }else if (myListStatus == vListStatusIsHalf ){
        [self changePlaceListStatus:vListStatusIsTop];
        
    }else if (myListStatus == vListStatusIsBottom ){
        [self changePlaceListStatus:vListStatusIsHalf];
    }
    
}

#pragma mark ------UITableView Delegate------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark ------Gesture Recognizer------

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    static NSTimeInterval lastTime;
    static NSTimeInterval beganTime;
    CGPoint translation = [pan translationInView:self.window];
    
    float panLocationY = [pan locationInView:self.window].y;
    
    
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:{
            
            beganTime = [NSDate timeIntervalSinceReferenceDate];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            if (panLocationY < withTopConstraint) {
                return;
            }
            
            self.frame = CGRectMake(0, panLocationY, self.frame.size.width, screenHeight - panLocationY);
        }
            break;
        case UIGestureRecognizerStateEnded:{
            
        }
        case UIGestureRecognizerStateCancelled:{
            
            lastTime = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval seconds = lastTime - beganTime;
            CGRect f = self.frame;
            if ( seconds < 0.1 ){
                
                if (translation.y > 0) {//往下pan
                    [self changePlaceListStatus:vListStatusIsBottom];
                }else{
                    [self changePlaceListStatus:vListStatusIsTop];
                }
                return;
            }
            
            switch (myListStatus) {
                case vListStatusIsTop:{
                    
                    if ( TopscrollPoint2 < f.origin.y  && f.origin.y < TopscrollPoint1) {
                        [self changePlaceListStatus:vListStatusIsBottom];
                    }else if( TopscrollPoint3 < f.origin.y  && f.origin.y < TopscrollPoint2){
                        [self changePlaceListStatus:vListStatusIsHalf];
                    }else if( TopscrollPoint4 < f.origin.y  && f.origin.y < TopscrollPoint3){
                        [self changePlaceListStatus:vListStatusIsTop];
                    }
                }
                    break;
                case vListStatusIsHalf:{
                    
                    if ( HalfscrollPoint2 < f.origin.y  && f.origin.y < HalfscrollPoint1) {
                        [self changePlaceListStatus:vListStatusIsBottom];
                    }else if( HalfscrollPoint3 < f.origin.y  && f.origin.y < HalfscrollPoint2){
                        [self changePlaceListStatus:vListStatusIsHalf];
                    }else if( HalfscrollPoint4 < f.origin.y  && f.origin.y < HalfscrollPoint3){
                        [self changePlaceListStatus:vListStatusIsTop];
                    }
                }
                    break;
                case vListStatusIsBottom:{
                    
                    if ( BottomscrollPoint2 < f.origin.y  && f.origin.y < BottomscrollPoint1) {
                        [self changePlaceListStatus:vListStatusIsBottom];
                    }else if( BottomscrollPoint3 < f.origin.y  && f.origin.y < BottomscrollPoint2){
                        [self changePlaceListStatus:vListStatusIsHalf];
                    }else if( BottomscrollPoint4 < f.origin.y  && f.origin.y < BottomscrollPoint3){
                        [self changePlaceListStatus:vListStatusIsTop];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

@end
