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
    NSUInteger result;
    NSUInteger bestResult;
    NSUInteger worstResult;
    NSUInteger averageResult;
    RollQuality quality;
};
typedef struct RollResult RollResult;

@interface RollManager : NSObject

+ (RollResult)resultOfRollString:(NSString *)string;

@end
