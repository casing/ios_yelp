//
//  Business.m
//  Yelp
//
//  Created by Casing Chu on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    
    if (self) {
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        
        NSArray *streetArray = [dictionary valueForKeyPath:@"location.address"];
        if (streetArray.count != 0) {
            self.address = streetArray[0];
        }
        NSArray *neighborhoodArray = [dictionary valueForKeyPath:@"location.neighborhoods"];
        if (neighborhoodArray.count != 0) {
            self.neighborhoods = neighborhoodArray[0];
        }
        self.city = [dictionary valueForKeyPath:@"location.city"];
        self.stateCode = [dictionary valueForKeyPath:@"location.state_code"];
        
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingsImageUrl = dictionary[@"rating_img_url"];
        float milesPerMeter = 0.000621371;
        self.distance = [dictionary[@"distance"] integerValue] * milesPerMeter;

        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[dictionary valueForKeyPath:@"location.coordinate.latitude"] doubleValue];
        coordinate.longitude = [[dictionary valueForKeyPath:@"location.coordinate.longitude"] doubleValue];
        self.coordinate = coordinate;
        
        self.snippet = dictionary[@"snippet_text"];
        self.snippetImageUrl = dictionary[@"snippet_image_url"];
    }
    
    return self;
}

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *businessess = [NSMutableArray array];
    
    for (NSDictionary *dictionary in dictionaries) {
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        [businessess addObject:business];
    }
    
    return businessess;
}

@end
