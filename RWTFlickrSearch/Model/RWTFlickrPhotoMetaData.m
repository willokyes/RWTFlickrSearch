//
//  RWTFlickrPhotoMetaData.m
//  RWTFlickrSearch
//
//  Created by 八月夏木 on 2018/9/10.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrPhotoMetaData.h"

@implementation RWTFlickrPhotoMetaData

- (NSString *)description
{
    return [NSString stringWithFormat:@"metadata: comments = %lU, faves = %lU", self.comments, self.favorites];
}

@end
