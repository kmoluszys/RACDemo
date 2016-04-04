//
//  DataManager.m
//  Demo
//
//  Created by Karol Moluszys on 04.04.2016.
//  Copyright © 2016 Karol Moluszys. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (RACSignal *)makeRequestWithUrl:(NSString *)url {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:url] sessionConfiguration:configuration];
        
        sessionManager.securityPolicy.allowInvalidCertificates = YES;
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setAllowInvalidCertificates:YES];
        securityPolicy.validatesDomainName = NO;
        sessionManager.securityPolicy = securityPolicy;
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableURLRequest *request = [sessionManager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
        
        NSURLSessionDataTask *sessionDataTask = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, NSData *responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
                return;
            }
            
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        }];
        
        [sessionDataTask resume];
        
        return nil;
    }];
}

+ (RACSignal *)getPeople {
    NSString *url = @"http://localhost:3000/people";
    return [self makeRequestWithUrl:url];
}

+ (RACSignal *)getDetails {
    NSString *url = @"http://localhost:3000/details";
    return [self makeRequestWithUrl:url];
}

+ (RACSignal *)ZIPgetPeopleWithDetails {
    return [RACSignal zip:@[[self getPeople], [self getDetails]]];
}

+ (RACSignal *)MERGEgetPeopleWithDetails {
    return [RACSignal merge:@[[self getPeople], [self getDetails]]];
}

+ (RACSignal *)FLATTENMAPgetPersonWithDetail {
    NSString *personUrl = @"http://localhost:3000/people/1";
    NSString *detailUrl = @"http://localhost:3000/details?user_id=1";
    NSMutableDictionary *response = [NSMutableDictionary new];
    
    return [[[self makeRequestWithUrl:personUrl] flattenMap:^RACStream *(NSArray *value) {
        [response addEntriesFromDictionary:value.firstObject];
        return [self makeRequestWithUrl:detailUrl];
    }] map:^id(NSArray *value) {
        [response addEntriesFromDictionary:value.firstObject];
        return response;
    }];
}

+ (RACSignal *)CATCHgetPersonWithDetailOK {
    return [[self errorSignal:@"This is not a drill!"] catch:^RACSignal *(NSError *error) {
        return [RACSignal return:@"This is not a bug, this is a feature!"];
    }];
}

+ (RACSignal *)CATCHgetPersonWithDetailNOTOK {
    return [self errorSignal:@"This is not a drill!"];
}

+ (RACSignal *)DEFERexampleOK {
    __block NSArray *dataArray = nil;
    
    RACSignal *getDetailSignal = [RACSignal defer:^RACSignal *{
        NSMutableArray *tmpSignalsArray = [NSMutableArray new];
        for (NSDictionary *person in dataArray) {
            NSString *url = [NSString stringWithFormat:@"http://localhost:3000/details?user_id=%@", person[@"id"]];
            [tmpSignalsArray addObject:[self makeRequestWithUrl:url]];
        }
        
        if (!tmpSignalsArray.firstObject) {
            return [self errorSignal:@"Empty array"];
        }
        
        return [RACSignal zip:tmpSignalsArray];
    }];
    
    return [[self getPeople] flattenMap:^RACStream *(NSArray *value) {
        dataArray = value;
        return getDetailSignal;
    }];
}

+ (RACSignal *)DEFERexampleNOTOK {
    __block NSArray *dataArray = nil;
    
    RACSignal *getDetailSignal = [[RACSignal return:dataArray] flattenMap:^RACStream *(NSArray *value) {
        NSMutableArray *tmpSignalsArray = [NSMutableArray new];
        for (NSDictionary *person in value) {
            NSString *url = [NSString stringWithFormat:@"http://localhost:3000/details?user_id=%@", person[@"id"]];
            [tmpSignalsArray addObject:[self makeRequestWithUrl:url]];
        }
        
        if (!tmpSignalsArray.firstObject) {
            return [self errorSignal:@"Empty array"];
        }
        
        return [RACSignal zip:tmpSignalsArray];
    }];
    
    return [[self getPeople] flattenMap:^RACStream *(NSArray *value) {
        dataArray = value;
        return getDetailSignal;
    }];
}

+ (RACSignal *)errorSignal:(NSString *)reason {
    return [RACSignal error:[self error:reason]];
}

+ (NSError *)error:(NSString *)reason {
    return [NSError errorWithDomain:@"pl.speednet.error" code:-1 userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Opps! It's supposed to work :( (%@)", reason]}];
}

@end
