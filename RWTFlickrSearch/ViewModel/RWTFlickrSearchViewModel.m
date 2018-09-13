//
//  RWTFlickrSearchViewModel.m
//  RWTFlickrSearch
//
//  Created by 八月夏木 on 2018/9/3.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"
#import "RWTSearchResultsViewModel.h"

@interface RWTFlickrSearchViewModel ()

@property (nonatomic, weak) id<RWTViewModelServices> services;

@end

@implementation RWTFlickrSearchViewModel

- (instancetype)initWithServices:(id<RWTViewModelServices>)services {
    self = [super init];
    if (self) {
        _services = services;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.title = @"Flicker Search";
    //self.searchText = @"search text";
    
    RACSignal *validSearchSignal =
        [[RACObserve(self, searchText)
              map:^id(NSString *text) {
                  return @(text.length > 3);
              }] distinctUntilChanged];
    
    [validSearchSignal subscribeNext:^(id x) {
        NSLog(@"search text is valid %@", x);
    }];
    
    //
    self.executeSearch = [[RACCommand alloc]
                          initWithEnabled:validSearchSignal
                          signalBlock:^RACSignal *(id input) {
                              return [self executeSearchSignal];
                          }];
    
    //
    
}

- (RACSignal *)executeSearchSignal {
    return [[[self.services getFlickrSearchService] flickrSearchSignal:self.searchText]
            doNext:^(id results) {
                RWTSearchResultsViewModel *resultsViewModel = [[RWTSearchResultsViewModel alloc] initWithSearchResults:results services:self.services];
                [self.services pushViewModel:resultsViewModel];
            }];
}

@end














