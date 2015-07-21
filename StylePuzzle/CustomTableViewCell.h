//
//  CustomTableViewCell.h
//  StylePuzzle
//
//  Created by Kevin Moy on 7/16/15.
//  Copyright (c) 2015 Kevin Moy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell <UIScrollViewDelegate> {
    UIPageControl       *pageControl;
}
- (void)setupPageView:(NSArray *)array;

@property (nonatomic, retain) UIScrollView *itemScrollView;
@property (nonatomic, retain) UILabel *categoryLabel;
@property (nonatomic, retain) UILabel *brandLabel;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UIImageView *profileImage;
@property (nonatomic, retain) UIPageControl *imagePageControl;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@end
