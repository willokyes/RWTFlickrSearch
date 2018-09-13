//
//  RWTFlickrSearchImpl.m
//  RWTFlickrSearch
//
//  Created by 八月夏木 on 2018/9/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"
#import "RWTFlickrSearchResults.h"
#import "RWTFlickrPhoto.h"
#import <objectiveflickr/ObjectiveFlickr.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RWTFlickrPhotoMetaData.h"

@interface RWTFlickrSearchImpl () <OFFlickrAPIRequestDelegate>

@property (strong, nonatomic) NSMutableSet *requests;
@property (strong, nonatomic) OFFlickrAPIContext *flickrContext;

@end

@implementation RWTFlickrSearchImpl

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *OFSampleAppAPIKey = @"1eb3d067f9fb1c2912437406b5ede29c";
        NSString *OFSampleAppAPISharedSecret = @"82c6cebea4a2e2c5";
        
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OFSampleAppAPIKey sharedSecret:OFSampleAppAPISharedSecret];
        _requests = [NSMutableSet new];
    }
    return self;
}


- (RACSignal *)flickrSearchSignal:(NSString *)searchString {
    //
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //
        //NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Obama.plist"];
        NSString *path = [NSBundle.mainBundle pathForResource:@"Obama" ofType:@"plist"];
        
        NSDictionary *response = [NSDictionary dictionaryWithContentsOfFile:path];
        RWTFlickrSearchResults *results = [RWTFlickrSearchResults new];
        results.searchString = searchString;
        results.totalResults = [[response valueForKeyPath:@"photos.total"] integerValue];
        
        NSArray *photos = [response valueForKeyPath:@"photos.photo"];
        results.photos = [photos linq_select:^id(NSDictionary *jsonPhoto) {
            RWTFlickrPhoto *photo = [RWTFlickrPhoto new];
            photo.title = [jsonPhoto objectForKey:@"title"];
            photo.identifier = [jsonPhoto objectForKey:@"id"];
            photo.url = [self.flickrContext photoSourceURLFromDictionary:jsonPhoto size:OFFlickrSmallSize];
            return photo;
        }];
        
        [subscriber sendNext:results];
        [subscriber sendCompleted];
        
        return nil;
    }];
}

- (RACSignal *)flickrSearchSignal1:(NSString *)searchString {
    return [self signalFromAPIMethod:@"flickr.photos.search"
                           arguments:@{@"text": searchString, @"sort": @"interestingness-desc"}
                           transform:^id(NSDictionary *response) {
                               //
                               //NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Obama.plist"];
                               //[response writeToFile:path atomically:YES];
                               
                               //
                               RWTFlickrSearchResults *results = [RWTFlickrSearchResults new];
                               results.searchString = searchString;
                               results.totalResults = [[response valueForKeyPath:@"photos.total"] integerValue];
                               
                               NSArray *photos = [response valueForKeyPath:@"photos.photo"];
                               results.photos = [photos linq_select:^id(NSDictionary *jsonPhoto) {
                                   RWTFlickrPhoto *photo = [RWTFlickrPhoto new];
                                   photo.title = [jsonPhoto objectForKey:@"title"];
                                   photo.identifier = [jsonPhoto objectForKey:@"id"];
                                   photo.url = [self.flickrContext photoSourceURLFromDictionary:jsonPhoto size:OFFlickrSmallSize];
                                   return photo;
                               }];
                               
                               return results;
                           }];
}

- (RACSignal *)signalFromAPIMethod:(NSString *)method
                         arguments: (NSDictionary *)args
                         transform: (id (^)(NSDictionary *response))block {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //
        OFFlickrAPIRequest *flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
        flickrRequest.delegate = self;
        [self.requests addObject:flickrRequest];
        
        //
        RACSignal *successSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didCompleteWithResponse:)
                                                  fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        
        //
        [[[successSignal
           map:^id(RACTuple *tuple) {
               return tuple.second;
           }]
           map:block]
           subscribeNext:^(id x) {
               [subscriber sendNext:x];
               [subscriber sendCompleted];
           }];
        
        //
        [flickrRequest callAPIMethodWithGET:method arguments:args];
        
        //
        return [RACDisposable disposableWithBlock:^{
            [self.requests removeObject:flickrRequest];
        }];
    }];
}

- (RACSignal *)flickrImageMetaData:(NSString *)photoId {
    RACSignal *favourites =
        [self signalFromAPIMethod:@"flickr.photos.getFavorites"
                        arguments:@{@"photo_id": photoId}
                        transform:^id(NSDictionary *response) {
                            NSString *total = [response valueForKeyPath:@"photo.total"];
                            return total;
                        }];
    
    RACSignal *comments =
        [self signalFromAPIMethod:@"flickr.photos.getInfo"
                        arguments:@{@"photo_id": photoId}
                        transform:^id(NSDictionary *response) {
                            NSString *total = [response valueForKeyPath:@"photo.comments._text"];
                            return total;
                        }];
    
    return [[RACSignal combineLatest:@[favourites, comments]
                              reduce:^id(NSString *favs, NSString *coms){
                                  RWTFlickrPhotoMetaData *meta = [RWTFlickrPhotoMetaData new];
                                  meta.comments = [coms integerValue];
                                  meta.favorites = [favs integerValue];
                                  return meta;
                              }] logAll];
}

@end




























