//
//  CustomTableViewCell.m
//  StylePuzzle
//
//  Created by Kevin Moy on 7/16/15.
//  Copyright (c) 2015 Kevin Moy. All rights reserved.
//

#import "CustomTableViewCell.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define IMAGE_WIDTH 320.0
#define IMAGE_HEIGHT 320.0

@implementation CustomTableViewCell
@synthesize categoryLabel;
@synthesize brandLabel;
@synthesize titleLabel;
@synthesize priceLabel;
@synthesize descriptionLabel;
@synthesize dateLabel;
@synthesize nameLabel;
@synthesize locationLabel;
@synthesize profileImage;
@synthesize itemScrollView;
@synthesize imagePageControl;
@synthesize spinner;

- (id)init {
    if (self = [super init]) {
        [self setCellView];
    }
    return self;
}

- (void)setCellView {
    
    itemScrollView = [[UIScrollView alloc] init];
    [itemScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    itemScrollView.delegate = self;
    itemScrollView.pagingEnabled = YES;
    
    categoryLabel = [[UILabel alloc] init];
    [categoryLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    categoryLabel.font = [UIFont fontWithName:@"Arial" size:14];

    brandLabel = [[UILabel alloc] init];
    [brandLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    brandLabel.font = [UIFont fontWithName:@"Arial" size:14];
    brandLabel.adjustsFontSizeToFitWidth = YES;
    
    titleLabel = [[UILabel alloc] init];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    priceLabel = [[UILabel alloc] init];
    [priceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    priceLabel.font = [UIFont fontWithName:@"Arial" size:14];
    priceLabel.textColor =[UIColor purpleColor];

    descriptionLabel = [[UILabel alloc] init];
    [descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    descriptionLabel.font = [UIFont fontWithName:@"Arial" size:12];
    descriptionLabel.numberOfLines = 0;
    
    dateLabel = [[UILabel alloc] init];
    [dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    dateLabel.font = [UIFont fontWithName:@"Arial" size:12];
    dateLabel.textColor =[UIColor purpleColor];
    
    nameLabel = [[UILabel alloc] init];
    [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    nameLabel.font = [UIFont fontWithName:@"Arial" size:14];
    nameLabel.textColor =[UIColor purpleColor];
    
    locationLabel = [[UILabel alloc] init];
    [locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    locationLabel.font = [UIFont fontWithName:@"Arial" size:12];

    profileImage = [[UIImageView alloc] init];
    [profileImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    profileImage.contentMode = UIViewContentModeScaleAspectFit;
    profileImage.layer.cornerRadius = 22.0f;
    profileImage.clipsToBounds = YES;
    
    imagePageControl = [[UIPageControl alloc] init];
    [imagePageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    imagePageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    
    // Spinner
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(IMAGE_WIDTH / 2, IMAGE_HEIGHT / 2 , 50 , 50);
    [spinner startAnimating];

    [self addSubview:imagePageControl];
    [self addSubview:categoryLabel];
    [self addSubview:brandLabel];
    [self addSubview:titleLabel];
    [self addSubview:priceLabel];
    [self addSubview:descriptionLabel];
    [self addSubview:dateLabel];
    [self addSubview:nameLabel];
    [self addSubview:locationLabel];
    [self addSubview:profileImage];
    [self addSubview:itemScrollView];

    [self addSubview:spinner];
    [self cellLayout];
}

- (void)setupPageView:(NSArray *)array {
    imagePageControl.currentPage = 0;
    imagePageControl.numberOfPages = [array count];
    [itemScrollView setContentSize:CGSizeMake([array count] * IMAGE_WIDTH, IMAGE_HEIGHT)];
    for (int i = 0; i < [array count]; i++) {
        dispatch_async(kBgQueue, ^{
            NSData *itemImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[array objectAtIndex:i]]];
            [spinner startAnimating];
            if (itemImgData) {
                UIImage *image = [UIImage imageWithData:itemImgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                        imageView.frame = CGRectMake(i * IMAGE_WIDTH, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
                        imageView.contentMode = UIViewContentModeScaleAspectFit;
                        [itemScrollView addSubview:imageView];
                        [spinner removeFromSuperview];
                    });
                }
            }
        });
    }
}

- (void)cellLayout {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(itemScrollView, categoryLabel, brandLabel, titleLabel, priceLabel, descriptionLabel, dateLabel, nameLabel, locationLabel, profileImage, imagePageControl);
    
    // User constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[profileImage(44)]-[nameLabel]-3-[categoryLabel]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[profileImage]-10-[locationLabel]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[nameLabel]-2-[locationLabel]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[categoryLabel]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dateLabel]-20-|"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[dateLabel]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[profileImage(44)]-[itemScrollView(320)]-10-[brandLabel]-[descriptionLabel]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:itemScrollView
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1.0
                                                       constant:0.0]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[itemScrollView(320)]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    
    // Info constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[brandLabel]-3-[priceLabel]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[itemScrollView]-10-[priceLabel]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[descriptionLabel]-15-|"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    
    // Page View
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imagePageControl
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imagePageControl(20)]-15-[brandLabel]"
                                                                 options:0 metrics:nil views:viewsDictionary]];
    [self bringSubviewToFront:imagePageControl];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = itemScrollView.frame.size.width;
    float fractionalPage = itemScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    imagePageControl.currentPage = page;
}

@end
