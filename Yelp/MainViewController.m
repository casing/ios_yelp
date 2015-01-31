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
@property (nonatomic, strong) NSMutableArray *businesses;
@property (nonatomic, strong) NSMutableArray *searchedBusinesses;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) NSMutableDictionary *filters;

- (void)fetchBusinessesWithParams:(NSDictionary *)params offset:(int)offset;
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
        
        // Setup Data Structures
        self.businesses = [[NSMutableArray alloc] init];
        self.filters = [[NSMutableDictionary alloc] init];
        
        // Setup default filter
        [self.filters setObject:@"restaurants" forKey:@"term"];
        
        // Fetch initial Business list
        [self fetchBusinessesWithParams:self.filters offset:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Table Refresh control
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(onTableRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.tableRefreshControl atIndex:0];
    
    // TableView Setup
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Setup up title
    self.title = @"Yelp";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onFilterButton)];
    
    // UI SearchBar Setup
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

#pragma mark - RefreshControl
- (void)onTableRefresh {
    
    [self fetchBusinessesWithParams:self.filters offset:0];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getBusinessessCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // We are displaying last row
    if (indexPath.row == ([self getBusinessessCount] - 1)) {
        [self fetchBusinessesWithParams:self.filters offset:(int)self.businesses.count];
        [self searchBusinessData];
    }
    
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.cellNumber = indexPath.row + 1;
    cell.business = [self getBusiness:(int)indexPath.row];
    return cell;
}

#pragma mark - FiltersViewControllerDelegate methods

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    
    [self.filters addEntriesFromDictionary:filters];
    [self fetchBusinessesWithParams:self.filters offset:0];
    
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

- (void)fetchBusinessesWithParams:(NSDictionary *)params offset:(int)offset {
    [self.client searchWithParams:params offset:offset success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        
        if (offset == 0) {
            [self.businesses removeAllObjects];
        }
        
        [self.businesses addObjectsFromArray:[Business businessesWithDictionaries:businessDictionaries]];
        [self.tableRefreshControl endRefreshing];
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
