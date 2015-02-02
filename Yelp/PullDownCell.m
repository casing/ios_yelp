//
//  PullDownCell.m
//  Yelp
//
//  Created by Casing Chu on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "PullDownCell.h"

@interface PullDownCell()
- (IBAction)onButton:(id)sender;

@end

@implementation PullDownCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onButton:(id)sender {
    [self.delegate onPullDown:self];
}
@end
