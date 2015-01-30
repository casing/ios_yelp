//
//  SegmentedCell.h
//  Yelp
//
//  Created by Casing Chu on 1/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentedCell;

@protocol SegmentedCellDelegate <NSObject>

- (void)segmentedCell:(SegmentedCell *)segmentedCell didValueChanged:(int)index;

@end

@interface SegmentedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,weak) id<SegmentedCellDelegate> delegate;

@end
