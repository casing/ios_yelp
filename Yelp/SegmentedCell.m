//
//  SegmentedCell.m
//  Yelp
//
//  Created by Casing Chu on 1/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SegmentedCell.h"

@interface SegmentedCell()


- (IBAction)valueChanged:(id)sender;

@end

@implementation SegmentedCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)valueChanged:(id)sender {
    [self.delegate segmentedCell:self
                 didValueChanged:(int)self.segmentedControl.selectedSegmentIndex];
}
@end
