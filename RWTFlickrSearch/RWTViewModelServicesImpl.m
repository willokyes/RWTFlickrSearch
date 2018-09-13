//
//  RWTViewModelServicesImpl.m
//  RWTFlickrSearch
//
//  Created by 八月夏木 on 2018/9/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "RWTViewModelServicesImpl.h"
#import "RWTFlickrSearchImpl.h"
#import "RWTSearchResultsViewController.h"

@interface RWTViewModelServicesImpl ()

@property (strong, nonatomic) RWTFlickrSearchImpl *searchService;

@property (weak, nonatomic) UINavigationController *navigationController;

@end

@implementation RWTViewModelServicesImpl

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        _searchService = [RWTFlickrSearchImpl new];
        _navigationController = navigationController;
    }
    return self;
}

- (id<RWTFlickrSearch>)getFlickrSearchService {
    return self.searchService;
}

- (void)pushViewModel:(id)viewModel {
    id viewController;
    
    if ([viewModel isKindOfClass:RWTSearchResultsViewModel.class]) {
        viewController = [[RWTSearchResultsViewController alloc] initWithViewModel:viewModel];
    } else {
        NSLog(@"an unknown ViewModel was pushed!");
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}


@end














