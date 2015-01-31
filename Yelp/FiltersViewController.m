//
//  FiltersViewController.m
//  Yelp
//
//  Created by Casing Chu on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "SegmentedCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, SegmentedCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSArray *sectionTitles;

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *categoryFilters;
@property (nonatomic) NSInteger distance;
@property (nonatomic) NSInteger sortMode;
@property (nonatomic) BOOL deal;
@property (nonatomic) NSInteger categoryIndex;

- (void)initCategories;
- (void)initCategoryFilters;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.distance = 0;
        self.sortMode = -1;
        self.categoryIndex = 0;
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
        [self initCategoryFilters];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup Data structures
    self.sectionTitles = @[@"Most Popular", @"Distance",  @"Sort By", @"Category", @"Category Filters"];
    
    // Navigation Setup
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onSearchButton)];
    
    // TableView Setup
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SegmentedCell" bundle:nil] forCellReuseIdentifier:@"SegmentedCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 1;
        case 3:
            return self.categories.count;
        case 4:
        {
            NSArray *array = self.categoryFilters[self.categoryIndex];
            return array.count;
        }
        default:
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.titleLabel.text = @"Offering a Deal";
            cell.on = self.deal;
            return cell;
        }
        case 1://Distance
        {
            SegmentedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentedCell" forIndexPath:indexPath];
            [cell.segmentedControl setTitle:@"5 KM" forSegmentAtIndex:0];
            [cell.segmentedControl setTitle:@"25 KM" forSegmentAtIndex:1];
            [cell.segmentedControl setTitle:@"40 KM" forSegmentAtIndex:2];
            cell.delegate = self;
            return cell;
        }
        case 2://Sort By
        {
            SegmentedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentedCell" forIndexPath:indexPath];
            [cell.segmentedControl setTitle:@"Best Match" forSegmentAtIndex:0];
            [cell.segmentedControl setTitle:@"Distance" forSegmentAtIndex:1];
            [cell.segmentedControl setTitle:@"Highest Rated" forSegmentAtIndex:2];
            cell.delegate = self;
            return cell;
        }
        case 3://Category
        {
            SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.titleLabel.text = self.categories[indexPath.row][@"name"];
            cell.on = (indexPath.row == self.categoryIndex);
            return cell;
        }
        case 4://Category Filters
        {
            SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            cell.delegate = self;
            NSArray *categoryFilterArray = self.categoryFilters[self.categoryIndex];
            cell.titleLabel.text = categoryFilterArray[indexPath.row][@"name"];
            cell.on = [self.selectedCategories containsObject:categoryFilterArray[indexPath.row]];
            return cell;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - SwitchCellDelegate Methods
- (void)switchCell:(SwitchCell *)switchCell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:switchCell];
    if (indexPath.section == 0) {
        self.deal = value;
    } else if(indexPath.section == 3) {
        if (value) {
            self.categoryIndex = indexPath.row;
        } else {
            self.categoryIndex = 0;
        }
        [self.tableView reloadData];
    } else if (indexPath.section == 4) {
        NSArray *categoryFilterArray = self.categoryFilters[self.categoryIndex];
        if (value) {
            [self.selectedCategories addObject:categoryFilterArray[indexPath.row]];
        } else {
            [self.selectedCategories removeObject:categoryFilterArray[indexPath.row]];
        }
    }
}

#pragma mark - SegmentedCellDelegate Methods
- (void)segmentedCell:(SegmentedCell *)segmentedCell didValueChanged:(int)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:segmentedCell];
    if (indexPath.section == 1) { //Distance
        switch (index) {
            case 0:
                self.distance = 5000; //5 KM
                break;
            case 1:
                self.distance = 25000; //25 KM
                break;
            case 2:
                self.distance = 40000; //40 KM
                break;
            default:
                self.distance = 0;
                break;
        }
    } else if (indexPath.section == 2) { //Sort By
        self.sortMode = index;
    }
}

#pragma mark - Private Methods
- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    // Deals
    if (self.deal) {
        [filters setObject:@NO forKey:@"deals_filter"];
    }
    
    // Distance
    if (self.distance > 0) {
        [filters setObject:[NSNumber numberWithInt:(int)self.distance] forKey:@"radius_filter"];
    }
    
    // Sort
    if (self.sortMode >= 0) {
        [filters setObject:[NSNumber numberWithInt:(int)self.sortMode] forKey:@"sort"];
    }
    
    // Category Term
    if (self.categoryIndex >= 0 && self.categoryIndex < self.categories.count) {
        [filters setObject:self.categories[self.categoryIndex][@"code"] forKey:@"term"];
    }
    
    // Filter Categories
    if (self.selectedCategories.count > 0) {
        NSMutableArray *codes = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [codes addObject:category[@"code"]];
        }
        NSString *categoryFilter = [codes componentsJoinedByString:@", "];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    return filters;
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSearchButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCategories {
    self.categories =
    @[@{@"name":@"Restaurants", @"code":@"restaurants"},
      @{@"name":@"Active Life", @"code":@"active"},
      @{@"name":@"Arts & Entertainment", @"code":@"arts"}];
}

- (void)initCategoryFilters {
    self.categoryFilters =
    
    // Restaurant category Filters
    @[@[@{@"name":@"Afghan", @"code":@"afghani"},
        @{@"name":@"African", @"code":@"african"},
        @{@"name":@"Senegalese", @"code":@"senegalese"},
        @{@"name":@"South African", @"code":@"southafrican"},
        @{@"name":@"American (New)", @"code":@"newamerican"},
        @{@"name":@"American (Traditional)", @"code":@"tradamerican"},
        @{@"name":@"Arabian", @"code":@"arabian"},
        @{@"name":@"Arab Pizza", @"code":@"arabpizza"},
        @{@"name":@"Argentine", @"code":@"argentine"},
        @{@"name":@"Armenian", @"code":@"armenian"},
        @{@"name":@"Asian Fusion", @"code":@"asianfusion"},
        @{@"name":@"Asturian", @"code":@"asturian"},
        @{@"name":@"Australian", @"code":@"australian"},
        @{@"name":@"Austrian", @"code":@"austrian"},
        @{@"name":@"Baguettes", @"code":@"baguettes"},
        @{@"name":@"Bangladeshi", @"code":@"bangladeshi"},
        @{@"name":@"Barbeque", @"code":@"bbq"},
        @{@"name":@"Basque", @"code":@"basque"},
        @{@"name":@"Bavarian", @"code":@"bavarian"},
        @{@"name":@"Beer Garden", @"code":@"beergarden"},
        @{@"name":@"Beer Hall", @"code":@"beerhall"},
        @{@"name":@"Beisl", @"code":@"beisl"},
        @{@"name":@"Belgian", @"code":@"belgian"},
        @{@"name":@"Flemish", @"code":@"flemish"},
        @{@"name":@"Bistros", @"code":@"bistros"},
        @{@"name":@"Black Sea", @"code":@"blacksea"},
        @{@"name":@"Brasseries", @"code":@"brasseries"},
        @{@"name":@"Brazilian", @"code":@"brazilian"},
        @{@"name":@"Brazilian Empanadas", @"code":@"brazilianempanadas"},
        @{@"name":@"Central Brazilian", @"code":@"centralbrazilian"},
        @{@"name":@"Northeastern Brazilian", @"code":@"northeasternbrazilian"},
        @{@"name":@"Northern Brazilian", @"code":@"northernbrazilian"},
        @{@"name":@"Rodizios", @"code":@"rodizios"},
        @{@"name":@"Breakfast & Brunch", @"code":@"breakfast_brunch"},
        @{@"name":@"British", @"code":@"british"},
        @{@"name":@"Buffets", @"code":@"buffets"},
        @{@"name":@"Bulgarian", @"code":@"bulgarian"},
        @{@"name":@"Burgers", @"code":@"burgers"},
        @{@"name":@"Burmese", @"code":@"burmese"},
        @{@"name":@"Cafes", @"code":@"cafes"},
        @{@"name":@"Cafeteria", @"code":@"cafeteria"},
        @{@"name":@"Cajun/Creole", @"code":@"cajun"},
        @{@"name":@"Cambodian", @"code":@"cambodian"},
        @{@"name":@"Canadian (New)", @"code":@"newcanadian"},
        @{@"name":@"Canteen", @"code":@"canteen"},
        @{@"name":@"Caribbean", @"code":@"caribbean"},
        @{@"name":@"Dominican", @"code":@"dominican"},
        @{@"name":@"Haitian", @"code":@"haitian"},
        @{@"name":@"Puerto Rican", @"code":@"puertorican"},
        @{@"name":@"Trinidadian", @"code":@"trinidadian"},
        @{@"name":@"Catalan", @"code":@"catalan"},
        @{@"name":@"Chech", @"code":@"chech"},
        @{@"name":@"Cheesesteaks", @"code":@"cheesesteaks"},
        @{@"name":@"Chicken Shop", @"code":@"chickenshop"},
        @{@"name":@"Chicken Wings", @"code":@"chicken_wings"},
        @{@"name":@"Chilean", @"code":@"chilean"},
        @{@"name":@"Chinese", @"code":@"chinese"},
        @{@"name":@"Cantonese", @"code":@"cantonese"},
        @{@"name":@"Congee", @"code":@"congee"},
        @{@"name":@"Dim Sum", @"code":@"dimsum"},
        @{@"name":@"Fuzhou", @"code":@"fuzhou"},
        @{@"name":@"Hakka", @"code":@"hakka"},
        @{@"name":@"Henghwa", @"code":@"henghwa"},
        @{@"name":@"Hokkien", @"code":@"hokkien"},
        @{@"name":@"Hunan", @"code":@"hunan"},
        @{@"name":@"Pekinese", @"code":@"pekinese"},
        @{@"name":@"Shanghainese", @"code":@"shanghainese"},
        @{@"name":@"Szechuan", @"code":@"szechuan"},
        @{@"name":@"Teochew", @"code":@"teochew"},
        @{@"name":@"Comfort Food", @"code":@"comfortfood"},
        @{@"name":@"Corsican", @"code":@"corsican"},
        @{@"name":@"Creperies", @"code":@"creperies"},
        @{@"name":@"Cuban", @"code":@"cuban"},
        @{@"name":@"Curry Sausage", @"code":@"currysausage"},
        @{@"name":@"Cypriot", @"code":@"cypriot"},
        @{@"name":@"Czech", @"code":@"czech"},
        @{@"name":@"Czech/Slovakian", @"code":@"czechslovakian"},
        @{@"name":@"Danish", @"code":@"danish"},
        @{@"name":@"Delis", @"code":@"delis"},
        @{@"name":@"Diners", @"code":@"diners"},
        @{@"name":@"Dumplings", @"code":@"dumplings"},
        @{@"name":@"Eastern European", @"code":@"eastern_european"},
        @{@"name":@"Ethiopian", @"code":@"ethiopian"},
        @{@"name":@"Fast Food", @"code":@"hotdogs"},
        @{@"name":@"Filipino", @"code":@"filipino"},
        @{@"name":@"Fischbroetchen", @"code":@"fischbroetchen"},
        @{@"name":@"Fish & Chips", @"code":@"fishnchips"},
        @{@"name":@"Fondue", @"code":@"fondue"},
        @{@"name":@"Food Court", @"code":@"food_court"},
        @{@"name":@"Food Stands", @"code":@"foodstands"},
        @{@"name":@"French", @"code":@"french"},
        @{@"name":@"Alsatian", @"code":@"alsatian"},
        @{@"name":@"Auvergnat", @"code":@"auvergnat"},
        @{@"name":@"Berrichon", @"code":@"berrichon"},
        @{@"name":@"Bourguignon", @"code":@"bourguignon"},
        @{@"name":@"Nicoise", @"code":@"nicois"},
        @{@"name":@"Provencal", @"code":@"provencal"},
        @{@"name":@"French Southwest", @"code":@"sud_ouest"},
        @{@"name":@"Galician", @"code":@"galician"},
        @{@"name":@"Gastropubs", @"code":@"gastropubs"},
        @{@"name":@"Georgian", @"code":@"georgian"},
        @{@"name":@"German", @"code":@"german"},
        @{@"name":@"Baden", @"code":@"baden"},
        @{@"name":@"Eastern German", @"code":@"easterngerman"},
        @{@"name":@"Hessian", @"code":@"hessian"},
        @{@"name":@"Northern German", @"code":@"northerngerman"},
        @{@"name":@"Palatine", @"code":@"palatine"},
        @{@"name":@"Rhinelandian", @"code":@"rhinelandian"},
        @{@"name":@"Giblets", @"code":@"giblets"},
        @{@"name":@"Gluten-Free", @"code":@"gluten_free"},
        @{@"name":@"Greek", @"code":@"greek"},
        @{@"name":@"Halal", @"code":@"halal"},
        @{@"name":@"Hawaiian", @"code":@"hawaiian"},
        @{@"name":@"Heuriger", @"code":@"heuriger"},
        @{@"name":@"Himalayan/Nepalese", @"code":@"himalayan"},
        @{@"name":@"Hong Kong Style Cafe", @"code":@"hkcafe"},
        @{@"name":@"Hot Dogs", @"code":@"hotdog"},
        @{@"name":@"Hot Pot", @"code":@"hotpot"},
        @{@"name":@"Hungarian", @"code":@"hungarian"},
        @{@"name":@"Iberian", @"code":@"iberian"},
        @{@"name":@"Indian", @"code":@"indpak"},
        @{@"name":@"Indonesian", @"code":@"indonesian"},
        @{@"name":@"International", @"code":@"international"},
        @{@"name":@"Irish", @"code":@"irish"},
        @{@"name":@"Island Pub", @"code":@"island_pub"},
        @{@"name":@"Israeli", @"code":@"israeli"},
        @{@"name":@"Italian", @"code":@"italian"},
        @{@"name":@"Abruzzese", @"code":@"abruzzese"},
        @{@"name":@"Altoatesine", @"code":@"altoatesine"},
        @{@"name":@"Apulian", @"code":@"apulian"},
        @{@"name":@"Calabrian", @"code":@"calabrian"},
        @{@"name":@"Cucina campana", @"code":@"cucinacampana"},
        @{@"name":@"Emilian", @"code":@"emilian"},
        @{@"name":@"Friulan", @"code":@"friulan"},
        @{@"name":@"Ligurian", @"code":@"ligurian"},
        @{@"name":@"Lumbard", @"code":@"lumbard"},
        @{@"name":@"Napoletana", @"code":@"napoletana"},
        @{@"name":@"Piemonte", @"code":@"piemonte"},
        @{@"name":@"Roman", @"code":@"roman"},
        @{@"name":@"Sardinian", @"code":@"sardinian"},
        @{@"name":@"Sicilian", @"code":@"sicilian"},
        @{@"name":@"Tuscan", @"code":@"tuscan"},
        @{@"name":@"Venetian", @"code":@"venetian"},
        @{@"name":@"Japanese", @"code":@"japanese"},
        @{@"name":@"Blowfish", @"code":@"blowfish"},
        @{@"name":@"Conveyor Belt Sushi", @"code":@"conveyorsushi"},
        @{@"name":@"Donburi", @"code":@"donburi"},
        @{@"name":@"Gyudon", @"code":@"gyudon"},
        @{@"name":@"Oyakodon", @"code":@"oyakodon"},
        @{@"name":@"Hand Rolls", @"code":@"handrolls"},
        @{@"name":@"Horumon", @"code":@"horumon"},
        @{@"name":@"Izakaya", @"code":@"izakaya"},
        @{@"name":@"Japanese Curry", @"code":@"japacurry"},
        @{@"name":@"Kaiseki", @"code":@"kaiseki"},
        @{@"name":@"Kushikatsu", @"code":@"kushikatsu"},
        @{@"name":@"Oden", @"code":@"oden"},
        @{@"name":@"Okinawan", @"code":@"okinawan"},
        @{@"name":@"Okonomiyaki", @"code":@"okonomiyaki"},
        @{@"name":@"Onigiri", @"code":@"onigiri"},
        @{@"name":@"Ramen", @"code":@"ramen"},
        @{@"name":@"Robatayaki", @"code":@"robatayaki"},
        @{@"name":@"Soba", @"code":@"soba"},
        @{@"name":@"Sukiyaki", @"code":@"sukiyaki"},
        @{@"name":@"Takoyaki", @"code":@"takoyaki"},
        @{@"name":@"Tempura", @"code":@"tempura"},
        @{@"name":@"Teppanyaki", @"code":@"teppanyaki"},
        @{@"name":@"Tonkatsu", @"code":@"tonkatsu"},
        @{@"name":@"Udon", @"code":@"udon"},
        @{@"name":@"Unagi", @"code":@"unagi"},
        @{@"name":@"Western Style Japanese Food", @"code":@"westernjapanese"},
        @{@"name":@"Yakiniku", @"code":@"yakiniku"},
        @{@"name":@"Yakitori", @"code":@"yakitori"},
        @{@"name":@"Jewish", @"code":@"jewish"},
        @{@"name":@"Kebab", @"code":@"kebab"},
        @{@"name":@"Korean", @"code":@"korean"},
        @{@"name":@"Kosher", @"code":@"kosher"},
        @{@"name":@"Kurdish", @"code":@"kurdish"},
        @{@"name":@"Laos", @"code":@"laos"},
        @{@"name":@"Laotian", @"code":@"laotian"},
        @{@"name":@"Latin American", @"code":@"latin"},
        @{@"name":@"Colombian", @"code":@"colombian"},
        @{@"name":@"Salvadoran", @"code":@"salvadoran"},
        @{@"name":@"Venezuelan", @"code":@"venezuelan"},
        @{@"name":@"Live/Raw Food", @"code":@"raw_food"},
        @{@"name":@"Lyonnais", @"code":@"lyonnais"},
        @{@"name":@"Malaysian", @"code":@"malaysian"},
        @{@"name":@"Mamak", @"code":@"mamak"},
        @{@"name":@"Nyonya", @"code":@"nyonya"},
        @{@"name":@"Meatballs", @"code":@"meatballs"},
        @{@"name":@"Mediterranean", @"code":@"mediterranean"},
        @{@"name":@"Falafel", @"code":@"falafel"},
        @{@"name":@"Mexican", @"code":@"mexican"},
        @{@"name":@"Eastern Mexican", @"code":@"easternmexican"},
        @{@"name":@"Jaliscan", @"code":@"jaliscan"},
        @{@"name":@"Northern Mexican", @"code":@"northernmexican"},
        @{@"name":@"Oaxacan", @"code":@"oaxacan"},
        @{@"name":@"Pueblan", @"code":@"pueblan"},
        @{@"name":@"Tacos", @"code":@"tacos"},
        @{@"name":@"Tamales", @"code":@"tamales"},
        @{@"name":@"Yucatan", @"code":@"yucatan"},
        @{@"name":@"Middle Eastern", @"code":@"mideastern"},
        @{@"name":@"Egyptian", @"code":@"egyptian"},
        @{@"name":@"Lebanese", @"code":@"lebanese"},
        @{@"name":@"Milk Bars", @"code":@"milkbars"},
        @{@"name":@"Modern Australian", @"code":@"modern_australian"},
        @{@"name":@"Modern European", @"code":@"modern_european"},
        @{@"name":@"Mongolian", @"code":@"mongolian"},
        @{@"name":@"Moroccan", @"code":@"moroccan"},
        @{@"name":@"New Zealand", @"code":@"newzealand"},
        @{@"name":@"Night Food", @"code":@"nightfood"},
        @{@"name":@"Norcinerie", @"code":@"norcinerie"},
        @{@"name":@"Open Sandwiches", @"code":@"opensandwiches"},
        @{@"name":@"Oriental", @"code":@"oriental"},
        @{@"name":@"Pakistani", @"code":@"pakistani"},
        @{@"name":@"Parent Cafes", @"code":@"eltern_cafes"},
        @{@"name":@"Parma", @"code":@"parma"},
        @{@"name":@"Persian/Iranian", @"code":@"persian"},
        @{@"name":@"Peruvian", @"code":@"peruvian"},
        @{@"name":@"Pita", @"code":@"pita"},
        @{@"name":@"Pizza", @"code":@"pizza"},
        @{@"name":@"Polish", @"code":@"polish"},
        @{@"name":@"Pierogis", @"code":@"pierogis"},
        @{@"name":@"Portuguese", @"code":@"portuguese"},
        @{@"name":@"Alentejo", @"code":@"alentejo"},
        @{@"name":@"Algarve", @"code":@"algarve"},
        @{@"name":@"Azores", @"code":@"azores"},
        @{@"name":@"Beira", @"code":@"beira"},
        @{@"name":@"Fado Houses", @"code":@"fado_houses"},
        @{@"name":@"Madeira", @"code":@"madeira"},
        @{@"name":@"Minho", @"code":@"minho"},
        @{@"name":@"Ribatejo", @"code":@"ribatejo"},
        @{@"name":@"Tras-os-Montes", @"code":@"tras_os_montes"},
        @{@"name":@"Potatoes", @"code":@"potatoes"},
        @{@"name":@"Poutineries", @"code":@"poutineries"},
        @{@"name":@"Pub Food", @"code":@"pubfood"},
        @{@"name":@"Rice", @"code":@"riceshop"},
        @{@"name":@"Romanian", @"code":@"romanian"},
        @{@"name":@"Rotisserie Chicken", @"code":@"rotisserie_chicken"},
        @{@"name":@"Rumanian", @"code":@"rumanian"},
        @{@"name":@"Russian", @"code":@"russian"},
        @{@"name":@"Salad", @"code":@"salad"},
        @{@"name":@"Sandwiches", @"code":@"sandwiches"},
        @{@"name":@"Scandinavian", @"code":@"scandinavian"},
        @{@"name":@"Scottish", @"code":@"scottish"},
        @{@"name":@"Seafood", @"code":@"seafood"},
        @{@"name":@"Serbo Croatian", @"code":@"serbocroatian"},
        @{@"name":@"Signature Cuisine", @"code":@"signature_cuisine"},
        @{@"name":@"Singaporean", @"code":@"singaporean"},
        @{@"name":@"Slovakian", @"code":@"slovakian"},
        @{@"name":@"Soul Food", @"code":@"soulfood"},
        @{@"name":@"Soup", @"code":@"soup"},
        @{@"name":@"Southern", @"code":@"southern"},
        @{@"name":@"Spanish", @"code":@"spanish"},
        @{@"name":@"Arroceria / Paella", @"code":@"arroceria_paella"},
        @{@"name":@"Steakhouses", @"code":@"steak"},
        @{@"name":@"Sushi Bars", @"code":@"sushi"},
        @{@"name":@"Swabian", @"code":@"swabian"},
        @{@"name":@"Swedish", @"code":@"swedish"},
        @{@"name":@"Swiss Food", @"code":@"swissfood"},
        @{@"name":@"Tabernas", @"code":@"tabernas"},
        @{@"name":@"Taiwanese", @"code":@"taiwanese"},
        @{@"name":@"Tapas Bars", @"code":@"tapas"},
        @{@"name":@"Tapas/Small Plates", @"code":@"tapasmallplates"},
        @{@"name":@"Tex-Mex", @"code":@"mex"},
        @{@"name":@"Thai", @"code":@"thai"},
        @{@"name":@"Traditional Norwegian", @"code":@"norwegian"},
        @{@"name":@"Traditional Swedish", @"code":@"traditional_swedish"},
        @{@"name":@"Trattorie", @"code":@"trattorie"},
        @{@"name":@"Turkish", @"code":@"turkish"},
        @{@"name":@"Chee Kufta", @"code":@"cheekufta"},
        @{@"name":@"Gozleme", @"code":@"gozleme"},
        @{@"name":@"Turkish Ravioli", @"code":@"turkishravioli"},
        @{@"name":@"Ukrainian", @"code":@"ukrainian"},
        @{@"name":@"Uzbek", @"code":@"uzbek"},
        @{@"name":@"Vegan", @"code":@"vegan"},
        @{@"name":@"Vegetarian", @"code":@"vegetarian"},
        @{@"name":@"Venison", @"code":@"venison"},
        @{@"name":@"Vietnamese", @"code":@"vietnamese"},
        @{@"name":@"Wok", @"code":@"wok"},
        @{@"name":@"Wraps", @"code":@"wraps"},
        @{@"name":@"Yugoslav", @"code":@"yugoslav"}],
      
      // Active Life Category Filters
      @[@{@"name":@"ATV Rentals/Tours", @"code": @"atvrentals"},
        @{@"name":@"Amateur Sports Teams", @"code": @"amateursportsteams"},
        @{@"name":@"Amusement Parks", @"code": @"amusementparks"},
        @{@"name":@"Aquariums", @"code": @"aquariums"},
        @{@"name":@"Archery", @"code": @"archery"},
        @{@"name":@"Badminton", @"code": @"badminton"},
        @{@"name":@"Basketball Courts", @"code": @"basketballcourts"},
        @{@"name":@"Bathing Area", @"code": @"bathing_area"},
        @{@"name":@"Batting Cages", @"code": @"battingcages"},
        @{@"name":@"Beach Volleyball", @"code": @"beachvolleyball"},
        @{@"name":@"Beaches", @"code": @"beaches"},
        @{@"name":@"Bicycle Paths", @"code": @"bicyclepaths"},
        @{@"name":@"Bike Rentals", @"code": @"bikerentals"},
        @{@"name":@"Boating", @"code": @"boating"},
        @{@"name":@"Bowling", @"code": @"bowling"},
        @{@"name":@"Bungee Jumping", @"code": @"bungeejumping"},
        @{@"name":@"Challenge Courses", @"code": @"challengecourses"},
        @{@"name":@"Climbing", @"code": @"climbing"},
        @{@"name":@"Cycling Classes", @"code": @"cyclingclasses"},
        @{@"name":@"Day Camps", @"code": @"daycamps"},
        @{@"name":@"Disc Golf", @"code": @"discgolf"},
        @{@"name":@"Diving", @"code": @"diving"},
        @{@"name":@"Free Diving", @"code": @"freediving"},
        @{@"name":@"Scuba Diving", @"code": @"scuba"},
        @{@"name":@"Experiences", @"code": @"experiences"},
        @{@"name":@"Fencing Clubs", @"code": @"fencing"},
        @{@"name":@"Fishing", @"code": @"fishing"},
        @{@"name":@"Fitness & Instruction", @"code": @"fitness"},
        @{@"name":@"Barre Classes", @"code": @"barreclasses"},
        @{@"name":@"Boot Camps", @"code": @"bootcamps"},
        @{@"name":@"Boxing", @"code": @"boxing"},
        @{@"name":@"Dance Studios", @"code": @"dancestudio"},
        @{@"name":@"Gyms", @"code": @"gyms"},
        @{@"name":@"Martial Arts", @"code": @"martialarts"},
        @{@"name":@"Meditation Centers", @"code": @"meditationcenters"},
        @{@"name":@"Pilates", @"code": @"pilates"},
        @{@"name":@"Swimming Lessons/Schools", @"code": @"swimminglessons"},
        @{@"name":@"Tai Chi", @"code": @"taichi"},
        @{@"name":@"Trainers", @"code": @"healthtrainers"},
        @{@"name":@"Yoga", @"code": @"yoga"},
        @{@"name":@"Flyboarding", @"code": @"flyboarding"},
        @{@"name":@"Gliding", @"code": @"gliding"},
        @{@"name":@"Go Karts", @"code": @"gokarts"},
        @{@"name":@"Golf", @"code": @"golf"},
        @{@"name":@"Gun/Rifle Ranges", @"code": @"gun_ranges"},
        @{@"name":@"Gymnastics", @"code": @"gymnastics"},
        @{@"name":@"Hang Gliding", @"code": @"hanggliding"},
        @{@"name":@"Hiking", @"code": @"hiking"},
        @{@"name":@"Horse Racing", @"code": @"horseracing"},
        @{@"name":@"Horseback Riding", @"code": @"horsebackriding"},
        @{@"name":@"Hot Air Balloons", @"code": @"hot_air_balloons"},
        @{@"name":@"Indoor Playcentre", @"code": @"indoor_playcenter"},
        @{@"name":@"Jet Skis", @"code": @"jetskis"},
        @{@"name":@"Kids Activities", @"code": @"kids_activities"},
        @{@"name":@"Kiteboarding", @"code": @"kiteboarding"},
        @{@"name":@"Lakes", @"code": @"lakes"},
        @{@"name":@"Laser Tag", @"code": @"lasertag"},
        @{@"name":@"Lawn Bowling", @"code": @"lawn_bowling"},
        @{@"name":@"Leisure Centers", @"code": @"leisure_centers"},
        @{@"name":@"Mini Golf", @"code": @"mini_golf"},
        @{@"name":@"Mountain Biking", @"code": @"mountainbiking"},
        @{@"name":@"Nudist", @"code": @"nudist"},
        @{@"name":@"Paddleboarding", @"code": @"paddleboarding"},
        @{@"name":@"Paintball", @"code": @"paintball"},
        @{@"name":@"Parks", @"code": @"parks"},
        @{@"name":@"Dog Parks", @"code": @"dog_parks"},
        @{@"name":@"Skate Parks", @"code": @"skate_parks"},
        @{@"name":@"Playgrounds", @"code": @"playgrounds"},
        @{@"name":@"Public Plazas", @"code": @"publicplazas"},
        @{@"name":@"Rafting/Kayaking", @"code": @"rafting"},
        @{@"name":@"Recreation Centers", @"code": @"recreation"},
        @{@"name":@"Rock Climbing", @"code": @"rock_climbing"},
        @{@"name":@"Sailing", @"code": @"sailing"},
        @{@"name":@"Skating Rinks", @"code": @"skatingrinks"},
        @{@"name":@"Skiing", @"code": @"skiing"},
        @{@"name":@"Skydiving", @"code": @"skydiving"},
        @{@"name":@"Sledding", @"code": @"sledding"},
        @{@"name":@"Soccer", @"code": @"football"},
        @{@"name":@"Spin Classes", @"code": @"spinclasses"},
        @{@"name":@"Sport Equipment Hire", @"code": @"sport_equipment_hire"},
        @{@"name":@"Sports Clubs", @"code": @"sports_clubs"},
        @{@"name":@"Squash", @"code": @"squash"},
        @{@"name":@"Summer Camps", @"code": @"summer_camps"},
        @{@"name":@"Surf Lifesaving", @"code": @"surflifesaving"},
        @{@"name":@"Surfing", @"code": @"surfing"},
        @{@"name":@"Swimming Pools", @"code": @"swimmingpools"},
        @{@"name":@"Tennis", @"code": @"tennis"},
        @{@"name":@"Trampoline Parks", @"code": @"trampoline"},
        @{@"name":@"Tubing", @"code": @"tubing"},
        @{@"name":@"Volleyball", @"code": @"volleyball"},
        @{@"name":@"Wildlife Hunting Ranges", @"code": @"wildlifehunting"},
        @{@"name":@"Zoos", @"code": @"zoos"},
        @{@"name":@"Zorbing", @"code": @"zorbing"}],
      
      // Arts & Entertainment Category Filters
      @[@{@"name":@"Arcades", @"code": @"arcades"},
        @{@"name":@"Art Galleries", @"code": @"galleries"},
        @{@"name":@"Betting Centers", @"code": @"bettingcenters"},
        @{@"name":@"Botanical Gardens", @"code": @"gardens"},
        @{@"name":@"Cabaret", @"code": @"cabaret"},
        @{@"name":@"Casinos", @"code": @"casinos"},
        @{@"name":@"Castles", @"code": @"castles"},
        @{@"name":@"Choirs", @"code": @"choirs"},
        @{@"name":@"Cinema", @"code": @"movietheaters"},
        @{@"name":@"Cultural Center", @"code": @"culturalcenter"},
        @{@"name":@"Festivals", @"code": @"festivals"},
        @{@"name":@"Christmas Markets", @"code": @"xmasmarkets"},
        @{@"name":@"Fun Fair", @"code": @"funfair"},
        @{@"name":@"General Festivals", @"code": @"generalfestivals"},
        @{@"name":@"Trade Fairs", @"code": @"tradefairs"},
        @{@"name":@"Jazz & Blues", @"code": @"jazzandblues"},
        @{@"name":@"Mah Jong Halls", @"code": @"mahjong"},
        @{@"name":@"Marching Bands", @"code": @"marchingbands"},
        @{@"name":@"Museums", @"code": @"museums"},
        @{@"name":@"Music Venues", @"code": @"musicvenues"},
        @{@"name":@"Opera & Ballet", @"code": @"opera"},
        @{@"name":@"Pachinko", @"code": @"pachinko"},
        @{@"name":@"Performing Arts", @"code": @"theater"},
        @{@"name":@"Professional Sports Teams", @"code": @"sportsteams"},
        @{@"name":@"Psychics & Astrologers", @"code": @"psychic_astrology"},
        @{@"name":@"Race Tracks", @"code": @"racetracks"},
        @{@"name":@"Social Clubs", @"code": @"social_clubs"},
        @{@"name":@"Stadiums & Arenas", @"code": @"stadiumsarenas"},
        @{@"name":@"Street Art", @"code": @"streetart"},
        @{@"name":@"Tablao Flamenco", @"code": @"tablaoflamenco"},
        @{@"name":@"Ticket Sales", @"code": @"ticketsales"},
        @{@"name":@"Wineries", @"code": @"wineries"}]];
    
}

@end
