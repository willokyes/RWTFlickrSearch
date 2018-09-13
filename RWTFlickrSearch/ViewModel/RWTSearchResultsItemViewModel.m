//
//  RWTSearchResultsItemViewModel.m
//  RWTFlickrSearch
//
//  Created by 八月夏木 on 2018/9/10.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsItemViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "RWTFlickrPhotoMetaData.h"

@interface RWTSearchResultsItemViewModel ()

@property (weak, nonatomic) id<RWTViewModelServices> services;
@property (strong, nonatomic) RWTFlickrPhoto *photo;

@end

@implementation RWTSearchResultsItemViewModel

- (instancetype)initWithPhoto:(RWTFlickrPhoto *)photo services:(id<RWTViewModelServices>)services {
    if (self = [super init]) {
        _title = photo.title;
        _url = photo.url;
        _services = services;
        _photo = photo;
        
        [self initialize];
    }
    return self;
}

- (void)initialize {
    RACSignal *fetchMetaData =
        [RACObserve(self, isVisible)
            filter:^BOOL(NSNumber *visible) {
                return [visible boolValue];
            }];
    
    @weakify(self)
    [fetchMetaData subscribeNext:^(id x) {
        @strongify(self)
        [[[self.services getFlickrSearchService]
             flickrImageMetaData: self.photo.identifier]
                 subscribeNext:^(RWTFlickrPhotoMetaData *x) {
                     self.favorites = @(x.favorites);
                     self.comments = @(x.comments);
                 }];
    }];
    
}

@end












