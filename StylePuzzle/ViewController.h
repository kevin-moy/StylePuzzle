//
//  ViewController.h
//  StylePuzzle
//
//  Created by Kevin Moy on 7/16/15.
//  Copyright (c) 2015 Kevin Moy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *itemTableView;
    UIPageViewController *pageViewController;
    NSArray             *pageControlImages;
}

@end

