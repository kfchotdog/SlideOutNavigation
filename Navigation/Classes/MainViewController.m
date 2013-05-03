//
//  MainViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "MainViewController.h"

#import <QuartzCore/QuartzCore.h>

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
#define CORNER_RADIUS 4

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Setup View

- (void)setupView
{
    // setup center view
    self.centerViewController = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
    
    self.centerViewController.view.tag = CENTER_TAG;
    self.centerViewController.delegate = self;
    
    if (SystemVersionGreaterOrEqualThan(5.0)) {
        [_centerViewController willMoveToParentViewController:self];
    }
    
    if (!SystemVersionGreaterOrEqualThan(5.0)) [_centerViewController viewWillAppear:NO];
    [self.view addSubview:self.centerViewController.view];
    if (!SystemVersionGreaterOrEqualThan(5.0)) [_centerViewController viewDidAppear:NO];
    
    if (SystemVersionGreaterOrEqualThan(5.0)) {
        [self addChildViewController:_centerViewController];
        [_centerViewController didMoveToParentViewController:self];
    }
    
    [self setupGestures];
}

- (void)showCenterViewWithShadow:(BOOL)showShadow withOffset:(double)offset
{
    if (showShadow) {
        [_centerViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerViewController.view.layer setOpacity:0.8];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    } else {
        [_centerViewController.view.layer setCornerRadius:0];
        [_centerViewController.view.layer setShadowOffset:CGSizeZero];
    }
}

- (void)resetMainView
{
    if (_leftPanelViewController != nil) {
        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
    }
    
    _centerViewController.leftButton.tag = 1;
    self.showingLeftPanel = NO;
    
    if (_rightPanelViewController != nil) {
        [self.rightPanelViewController.view removeFromSuperview];
        self.rightPanelViewController = nil;
    }
    _centerViewController.rightButton.tag = 1;
    self.showingRightPanel = NO;
    
    [self showCenterViewWithShadow:NO withOffset:0];
}

- (UIView *)getLeftView
{    
    if (_leftPanelViewController == nil) {
        self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate = _centerViewController;
        
        if (SystemVersionGreaterOrEqualThan(5.0)) {
            [self.leftPanelViewController willMoveToParentViewController:self];
            [self addChildViewController:_leftPanelViewController];
        }
        
        if (!SystemVersionGreaterOrEqualThan(5.0)) {
            [_leftPanelViewController viewWillAppear:YES];
        }
        
        [self.view insertSubview:_leftPanelViewController.view belowSubview:_centerViewController.view];
        
        if (!SystemVersionGreaterOrEqualThan(5.0)) {
            [_leftPanelViewController viewDidAppear:YES];
        }
        
        if (SystemVersionGreaterOrEqualThan(5.0)) {
            [_leftPanelViewController didMoveToParentViewController:self];
        }
    }
    
    self.showingLeftPanel = YES;
    
    UIView *view = self.leftPanelViewController.view;
    
    return view;
}

- (UIView *)getRightView
{     
    if (_rightPanelViewController == nil) {
        self.rightPanelViewController = [[RightPanelViewController alloc] initWithNibName:@"RightPanelViewController" bundle:nil];
        
        self.rightPanelViewController.view.tag = RIGHT_PANEL_TAG;
        self.rightPanelViewController.delegate = _centerViewController;
        
        if (SystemVersionGreaterOrEqualThan(5.0)) {
            [self.rightPanelViewController willMoveToParentViewController:self];
            [self addChildViewController:_rightPanelViewController];
        }
        
        if (!SystemVersionGreaterOrEqualThan(5.0)) {
            [_rightPanelViewController viewWillAppear:YES];
        }
        
        [self.view insertSubview:_rightPanelViewController.view belowSubview:_centerViewController.view];
        
        if (!SystemVersionGreaterOrEqualThan(5.0)) {
            [_rightPanelViewController viewDidAppear:YES];
        }
        
        if (SystemVersionGreaterOrEqualThan(5.0)) {
            [_rightPanelViewController didMoveToParentViewController:self];
        }
    }
    
    self.showingRightPanel = YES;
    
    UIView *view = self.rightPanelViewController.view;
    
    return view;
}

#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

- (void)setupGestures
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [panGestureRecognizer setDelegate:self];
    
    [_centerViewController.view addGestureRecognizer:panGestureRecognizer];
}

-(void)movePanel:(id)sender
{
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        if(velocity.x > 0) {
            if (!_showingRightPanel) {
                childView = [self getLeftView];
            }
        } else {
            if (!_showingLeftPanel) {
                childView = [self getRightView];
            }
        }
        // Make sure the view you're working with is front and center.
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        } else {
            if (_showingLeftPanel) {
                [self movePanelRight];
            }  else if (_showingRightPanel) {
                [self movePanelLeft];
            }
        }
    }
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        // Are you more than halfway? If so, show the panel when done dragging by setting this value to YES (1).
        _showPanel = abs([sender view].center.x - _centerViewController.view.frame.size.width/2) > _centerViewController.view.frame.size.width/2;
        // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        
        // If you needed to check for a change in direction, you could use this code to do so.              if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y &gt; 0) {
        // NSLog(@"same direction");
    } else {
        // NSLog(@"opposite direction");
    }
    _preVelocity = velocity;
}

#pragma mark -
#pragma mark Delegate Actions

- (void)movePanelLeft // to show right panel
{
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerViewController.view.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _centerViewController.rightButton.tag = 0;
        }
    }];
    
    [self showCenterViewWithShadow:YES withOffset:2];
}

- (void)movePanelRight // to show left panel
{
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _centerViewController.leftButton.tag = 0;
        }
    }];
    
    [self showCenterViewWithShadow:YES withOffset:2];
}

- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self resetMainView];
        }
    }];
}

#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
