//
//  ViewController.m
//  StylePuzzle
//
//  Created by Kevin Moy on 7/16/15.
//  Copyright (c) 2015 Kevin Moy. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

static NSString *const baseUrl = @"https://cdn.rawgit.com/tobiaslei/c5c186ea75d05de6a195/raw/f40a5c0e4eb6106fa650dee82478999a65010ab9/feed.json";
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *datasourceArray;
@property (nonatomic, strong) NSMutableDictionary *categoryNameMap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    itemTableView.estimatedRowHeight = 200;
    itemTableView.rowHeight = UITableViewAutomaticDimension;
    self.datasourceArray = [NSMutableArray array];
    self.categoryNameMap = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"pants", @"a sweater", @"a dress", @"a top", @"shorts", nil] forKeys:[NSArray arrayWithObjects:@"pants", @"sweaters", @"dresses", @"tops", @"shorts", nil]];
    [self getItemData:baseUrl];
}

- (void)viewWillLayoutSubviews {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(itemTableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemTableView]|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[itemTableView]|" options:0 metrics:nil views:viewsDictionary]];
}

#pragma mark - Data
- (void)getItemData: (NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dictionary = responseObject;
        NSArray *feed = dictionary[@"feed"];
        for (NSDictionary *itemInformation in feed) {
            
            // Item information
            NSString *itemCategory = itemInformation[@"category"];
            NSString *itemBrand = itemInformation[@"brand"];
            NSString *itemTitle = itemInformation[@"sale_title"];
            NSString *itemPrice = itemInformation[@"sale_price"];
            NSString *itemDescription = itemInformation[@"sale_description"];
            
            NSMutableArray *itemImages = [NSMutableArray array];
            // Get images
            NSArray *imageArray = itemInformation[@"images"];
            for (NSDictionary *itemUrl in imageArray) {
                NSString *imageString = itemUrl[@"image"];
                [itemImages addObject:imageString];
            }
            
            // Fashionist information
            NSString *fashionistName = itemInformation[@"fashionista"][@"full_name"];
            NSString *fashionistLocation = itemInformation[@"fashionista"][@"location"];
            NSString *fashionistProfileImage = itemInformation[@"fashionista"][@"profile_image"];
            
            
            // Convert Date
            NSString *postDate = itemInformation[@"released_at"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [formatter dateFromString:postDate];
            NSTimeInterval timeInterval = [dateFromString timeIntervalSinceNow] / -86400;
            NSInteger roundedDays = round(timeInterval);
            NSString *itemDate = [NSString stringWithFormat:@"%ld", (long)roundedDays];

            // Store item info
            NSDictionary *displayInformation = @{@"category":itemCategory,
                                                 @"brand":itemBrand,
                                                 @"title": itemTitle,
                                                 @"price": itemPrice,
                                                 @"description": itemDescription,
                                                 @"date": itemDate,
                                                 @"name": fashionistName,
                                                 @"location": fashionistLocation,
                                                 @"profileImage": fashionistProfileImage,
                                                 @"itemImages": itemImages,
                                                 };
            [self.datasourceArray addObject:displayInformation];
        }
        [itemTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)setupTableView {
    self.datasourceArray = [NSMutableArray array];
    itemTableView = [[UITableView alloc] init];
    [itemTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    itemTableView.delegate = self;
    itemTableView.dataSource = self;
    itemTableView.allowsSelection = NO;
    itemTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:itemTableView];
}

- (NSString *)getSinglarity:(NSString *)string {
    if ([self.categoryNameMap objectForKey:string]) {
        return self.categoryNameMap[string];
    }
    else
        return string;
}

#pragma mark - TableView Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomTableViewCell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = (CustomTableViewCell *)[[CustomTableViewCell alloc] init];
    }
    [self setupCell:(CustomTableViewCell *)cell indexPath:indexPath];
    return cell;
}

- (void)setupCell:(CustomTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = self.datasourceArray[indexPath.row];
    cell.nameLabel.text = itemInfo[@"name"];
    cell.locationLabel.text = itemInfo[@"location"];
    
    
   // [self getSinglarity:itemInfo[@"category"]];
    
    cell.categoryLabel.text = [@"has found " stringByAppendingString:[self getSinglarity:itemInfo[@"category"]]];
    cell.brandLabel.text = [itemInfo[@"brand"] stringByAppendingString:@" |"];
    NSString *priceString = [itemInfo[@"price"] stringValue];
    cell.priceLabel.text = [@"CN¥" stringByAppendingString:priceString];
    cell.descriptionLabel.text = itemInfo[@"description"];
    cell.dateLabel.text = [itemInfo[@"date"] stringByAppendingString:@"d"];

    pageControlImages = itemInfo[@"itemImages"];
    
    [cell setupPageView:pageControlImages];
    // Async image loading
    dispatch_async(kBgQueue, ^{
        NSDictionary *info = itemInfo;
        NSData *profileImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:info[@"profileImage"]]];
        if (profileImgData) {
            UIImage *image = [UIImage imageWithData:profileImgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CustomTableViewCell *updateCell = (id)[itemTableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.profileImage.image = image;
                    });
                }
            }
        });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = self.datasourceArray[indexPath.row];
    NSString *description = itemInfo[@"description"];
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    CGRect textRect = [description boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:font}
                                                context:nil];
    
    
    return textRect.size.height + 440;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidLayoutSubviews {
    if ([itemTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [itemTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([itemTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [itemTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
