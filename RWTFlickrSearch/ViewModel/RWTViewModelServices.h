//
//  RWTViewModelServices.h
//  RWTFlickrSearch
//
//  Created by 八月夏木 on 2018/9/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrSearch.h"

@protocol RWTViewModelServices <NSObject>

- (id<RWTFlickrSearch>)getFlickrSearchService;

- (void)pushViewModel:(id)viewModel;

@end
