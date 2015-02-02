//
//  UIImageView+FadeNetworkImage.m
//
//  Created by Casing Chu on 1/25/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import "UIImageView+FadeNetworkImage.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (FadeNetworkImage)

- (void)setImageWithURL:(NSURL*)url withPlaceHolderURL:(NSURL*)placeHolderUrl withFadeDuration:(float)duration {
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    NSData *placeholderImageData = [NSData dataWithContentsOfURL:placeHolderUrl];
    UIImage *placeholder = [UIImage imageWithData:placeholderImageData];
    [self setImageWithURLRequest:request placeholderImage:placeholder success:
     ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         // Fade In
         if (placeholder == nil) {
             self.alpha = 0;
             [self setImage:image];
             [UIView animateWithDuration:duration animations:^{
                 self.alpha = 1;
             } completion:^(BOOL finished) {
             }];
         } else {
             [self setImage:image];
         }
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         NSLog(@"%@", [error description]);
     }];
}

@end
