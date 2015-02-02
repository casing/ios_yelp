//
//  PullDownCell.h
//  Yelp
//
//  Created by Casing Chu on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullDownCell;

@protocol PullDownCellDelegate <NSObject>

- (void)onPullDown:(PullDownCell *)cell;

@end

@interface PullDownCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak)id<PullDownCellDelegate> delegate;

@end
