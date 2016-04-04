//
//  DataManager.h
//  Demo
//
//  Created by Karol Moluszys on 04.04.2016.
//  Copyright © 2016 Karol Moluszys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
+ (RACSignal *)getPeople;
+ (RACSignal *)getDetails;
+ (RACSignal *)ZIPgetPeopleWithDetails;
+ (RACSignal *)MERGEgetPeopleWithDetails;
+ (RACSignal *)FLATTENMAPgetPersonWithDetail;
+ (RACSignal *)CATCHgetPersonWithDetailOK;
+ (RACSignal *)CATCHgetPersonWithDetailNOTOK;
+ (RACSignal *)DEFERexampleOK;
+ (RACSignal *)DEFERexampleNOTOK;
@end
