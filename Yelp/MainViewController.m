//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "BusinessCell.h"
#import "YelpClient.h"
#import "Business.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"DB6QCDtQLZI-ErPThGa4vw";
NSString * const kYelpConsumerSecret = @"7s-4EhTFdtRksOzYMBpdVMU4gZo";
NSString * const kYelpToken = @"C-jE7n1NLpCXxV1LbIpikQkuFDx5DYig";
NSString * const kYelpTokenSecret = @"237Knry48skM4MSQDthMpHEbYyc";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSMutableArray *searchedBusinesses;
@property (nonatomic, strong) UISearchBar *searchBar;

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;
- (NSUInteger)getBusinessessCount;
- (Business *)getBusiness:(int)index;
- (void)searchBusinessData;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"Yelp";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onFilterButton)];
    self.searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getBusinessessCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = [self getBusiness:(int)indexPath.row];
    return cell;
}

#pragma mark - FiltersViewControllerDelegate methods

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
    
}

#pragma mark - SearchBar Methods

- (void) searchBusinessData {
    [self.searchedBusinesses removeAllObjects];
    // TODO: We need to add a proper filtering for a list of Business Objects
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", self.searchBar.text];
    NSPredicate *addressPredicate = [NSPredicate predicateWithFormat:@"SELF.address contains[c] %@", self.searchBar.text];
    NSPredicate *categoriesPredicate = [NSPredicate predicateWithFormat:@"SELF.categories contains[c] %@", self.searchBar.text];
    NSArray *predicates = [NSArray arrayWithObjects:namePredicate, addressPredicate, categoriesPredicate, nil];
    NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    self.searchedBusinesses = [NSMutableArray arrayWithArray:[self.businesses filteredArrayUsingPredicate:predicate]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchBusinessData];
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (NSUInteger)getBusinessessCount {
    if ([self.searchBar.text length] == 0) {
        return self.businesses.count;
    } else {
        return self.searchedBusinesses.count;
    }
}

- (Business *)getBusiness:(int)index {
    if ([self.searchBar.text length] == 0) {
        return self.businesses[index];
    } else {
        return self.searchedBusinesses[index];
    }
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        self.businesses = [Business businessesWithDictionaries:businessDictionaries];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}

- (void)onFilterButton {
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
