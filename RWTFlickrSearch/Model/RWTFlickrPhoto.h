//
//  RWTFlickrPhoto.h
//  RWTFlickrSearch
//
//  Created by 八月夏木 on 2018/9/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickrPhoto : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *identifier;

@end
