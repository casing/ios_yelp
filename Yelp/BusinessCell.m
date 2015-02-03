//
//  BusinessCell.m
//  Yelp
//
//  Created by Casing Chu on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+FadeNetworkImage.h"

@interface BusinessCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingsImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

- (NSString *)buildAddressLabel;

@end

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
    
    // In here to fix TableCell layout issue when using UITableViewAutomaticDimension
    // But was this fix in the latest version?
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    
    self.thumbnailView.layer.cornerRadius = 5;
    self.thumbnailView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusiness:(Business *)business {
    _business = business;
    
    if (self.business.imageUrl) {
        [self.thumbnailView setImageWithURL:[NSURL URLWithString:self.business.imageUrl] withPlaceHolderURL:nil withFadeDuration:2.0];
    } else {
        [self.thumbnailView setImage:[UIImage imageNamed:@"camera.png"]];
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%ld. %@", self.cellNumber, self.business.name];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    [self.ratingsImageView setImageWithURL:[NSURL URLWithString:self.business.ratingsImageUrl] withPlaceHolderURL:nil withFadeDuration:2.0];
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
    self.addressLabel.text = [self buildAddressLabel];
    self.categoryLabel.text = self.business.categories;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // In here to fix TableCell layout issue when using UITableViewAutomaticDimension
    // But was this fix in the latest version?
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    
}

#pragma mark - Private Methods
- (NSString *)buildAddressLabel {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (self.business.address) {
        [array addObject:self.business.address];
    }
    if (self.business.neighborhoods) {
        [array addObject:self.business.neighborhoods];
    }
    return [array componentsJoinedByString:@", "];
}

@end
