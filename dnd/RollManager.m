//
//  RollManager.m
//  dnd
//
//  Created by Devon Tivona on 12/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RollManager.h"

@implementation RollManager

+ (RollResult)resultOfRollString:(NSString *)string
{
    RollResult r = {.result = 0, .bestResult = 0, .worstResult = 0, .averageResult = 0, .quality = RollQualityAverage};
    
    NSArray *rolls = [string componentsSeparatedByString:@"+"];
    for (NSString *roll in rolls) {
        NSString *trimmedRoll = [roll stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *components = [trimmedRoll componentsSeparatedByString:@"d"];
        if (components.count == 1) {
            // This is a modifier
            NSInteger modifier = [components[0] integerValue];
            r.result += modifier;
            r.bestResult += modifier;
            r.worstResult += modifier;
            r.averageResult += modifier;
        } else if (components.count == 2) {
            // This is a roll
            for (NSUInteger index = 0; index < [components[0] integerValue]; index++) {
                NSUInteger dieSize = [components[1] integerValue];
                r.result += arc4random_uniform((uint32_t)dieSize) + 1;
                r.bestResult += dieSize;
                r.worstResult += 1;
                r.averageResult += (dieSize + 1) / 2;
            }
        }
    }
    
    CGFloat percentile = ((CGFloat)(r.result - r.worstResult)) / ((CGFloat)(r.bestResult - r.worstResult));
    if (percentile <= 0.20f) r.quality = RollQualityTerrible;
    else if (percentile <= 0.40f) r.quality = RollQualityBad;
    else if (percentile <= 0.60f) r.quality = RollQualityAverage;
    else if (percentile <= 0.80f) r.quality = RollQualityGood;
    else if (percentile <= 1.00f) r.quality = RollQualityGreat;
    
    return r;
}

@end
