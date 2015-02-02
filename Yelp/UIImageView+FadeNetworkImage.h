//
//  UIImageView+FadeNetworkImage.h
//
//  Created by Casing Chu on 1/25/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FadeNetworkImage)

- (void)setImageWithURL:(NSURL*)url withPlaceHolderURL:(NSURL*)placeHolderUrl withFadeDuration:(float)duration;

@end
