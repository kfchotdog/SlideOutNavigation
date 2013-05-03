//
//  MainViewController.h
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
#import "LeftPanelViewController.h"
#import "RightPanelViewController.h"

#define CENTER_TAG      1
#define LEFT_PANEL_TAG  2
#define RIGHT_PANEL_TAG 3

@interface MainViewController : UIViewController<CenterViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CenterViewController *centerViewController;

@property (nonatomic, strong) LeftPanelViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;

@property (nonatomic, strong) RightPanelViewController *rightPanelViewController;
@property (nonatomic, assign) BOOL showingRightPanel;

@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;

@end
