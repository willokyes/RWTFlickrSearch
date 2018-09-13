//
//  RWTFlickrSearchViewModel.h
//  RWTFlickrSearch
//
//  Created by 八月夏木 on 2018/9/3.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RWTViewModelServices.h"

@interface RWTFlickrSearchViewModel : NSObject

@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) RACCommand *executeSearch;

- (instancetype)initWithServices:(id<RWTViewModelServices>)services;

@end
