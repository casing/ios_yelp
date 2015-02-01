//
//  Business.h
//  Yelp
//
//  Created by Casing Chu on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Business : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingsImageUrl;
@property (nonatomic, assign) NSInteger numReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *neighborhoods;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *stateCode;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *snippetImageUrl;
@property (nonatomic, strong) NSString *snippet;

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries;

@end
