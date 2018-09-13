//
//  RWTFlickrSearchResults.m
//  RWTFlickrSearch
//
//  Created by 八月夏木 on 2018/9/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResults.h"

@implementation RWTFlickrSearchResults

- (NSString *)description
{
    return [NSString stringWithFormat:@"searchString=%@, totalResults=%lU, photos=%@", self.searchString, self.totalResults, self.photos];
}

- (void)dealloc {
    NSLog(@"RWTFlickrSearchResults:dealloc");
}

@end
