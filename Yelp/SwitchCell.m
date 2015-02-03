//
//  SwitchCell.m
//  Yelp
//
//  Created by Casing Chu on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()

@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

- (IBAction)switchValueChanged:(id)sender;
- (void)updateBackgroudColor;

@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [self.toggleSwitch setOn:on animated:animated];
    [self updateBackgroudColor];
}

- (IBAction)switchValueChanged:(id)sender {
    [self updateBackgroudColor];
    [self.delegate switchCell:self didUpdateValue:self.toggleSwitch.on];
}

- (void)updateBackgroudColor {
    if (self.toggleSwitch.on) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}
@end
