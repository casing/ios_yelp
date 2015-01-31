//
//  BusinessCell.h
//  Yelp
//
//  Created by Casing Chu on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessCell : UITableViewCell

@property (nonatomic, strong) Business *business;
@property (nonatomic) NSInteger cellNumber;

@end
