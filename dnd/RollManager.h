//
//  RollManager.h
//  dnd
//
//  Created by Devon Tivona on 12/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    RollQualityTerrible,
    RollQualityBad,
    RollQualityAverage,
    RollQualityGood,
    RollQualityGreat
} RollQuality;

struct RollResult {
    NSInteger result;
    NSInteger bestResult;
    NSInteger worstResult;
    NSInteger averageResult;
    RollQuality quality;
};
typedef struct RollResult RollResult;

@interface RollManager : NSObject

+ (RollResult)resultOfRollString:(NSString *)string;
+ (void)showAlertForRollResult:(RollResult)roll;

@end
