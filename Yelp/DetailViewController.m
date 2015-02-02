//
//  DetailViewController.m
//  Yelp
//
//  Created by Casing Chu on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "DetailViewController.h"
#import "UIImageView+FadeNetworkImage.h"

@interface DetailViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfReviewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *snippetImageView;
@property (weak, nonatomic) IBOutlet UILabel *snippetLabel;

- (NSString *)buildAddressLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.thumbnailImageView setImageWithURL:[NSURL URLWithString:self.business.imageUrl] withPlaceHolderURL:nil withFadeDuration:2.0];
    self.nameLabel.text = self.business.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingsImageUrl] withPlaceHolderURL:nil withFadeDuration:2.0];
    self.numberOfReviewsLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
    self.addressLabel.text = [self buildAddressLabel];
    self.categoryLabel.text = self.business.categories;
    [self.snippetImageView setImageWithURL:[NSURL URLWithString:self.business.snippetImageUrl] withPlaceHolderURL:nil withFadeDuration:2.0];
    self.snippetLabel.text = self.business.snippet;
    
    // MapView Setup
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    NSArray *array = [[NSArray alloc] initWithObjects:self.business, nil];
    [self.mapView showAnnotations:array animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapViewDelegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[Business class]]) {
        Business *business = annotation;
        MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:business.name];
        return pin;
    }
    return nil;
}

#pragma mark - Private Methods

- (NSString *)buildAddressLabel {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (self.business.address) {
        [array addObject:self.business.address];
    }
    if (self.business.city) {
        [array addObject:self.business.city];
    }
    if (self.business.stateCode) {
        [array addObject:self.business.stateCode];
    }
    if (self.business.neighborhoods) {
        [array addObject:self.business.neighborhoods];
    }
    return [array componentsJoinedByString:@", "];
}

@end
