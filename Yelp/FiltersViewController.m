//
//  FiltersViewController.m
//  Yelp
//
//  Created by Casing Chu on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

- (void)initCategories;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onApplyButton)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.categories[indexPath.row][@"name"];
    cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - SwitchCellDelegate Methods
- (void)switchCell:(SwitchCell *)switchCell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:switchCell];
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

#pragma mark - Private Methods
- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
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

- (void)onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCategories {
    self.categories =
    @[@{@"name":@"Afghan", @"code":@"afghani"},
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
      @{@"name":@"Yugoslav", @"code":@"yugoslav"}];
    
}

@end
