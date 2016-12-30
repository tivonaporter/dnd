//
//  RollManager.m
//  dnd
//
//  Created by Devon Tivona on 12/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "RollManager.h"

@implementation RollManager

+ (NSUInteger)resultOfRollString:(NSString *)string
{
    NSUInteger result = 0;
    NSArray *rolls = [string componentsSeparatedByString:@"+"];
    for (NSString *roll in rolls) {
        NSString *trimmedRoll = [roll stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *components = [trimmedRoll componentsSeparatedByString:@"d"];
        if (components.count == 1) {
            result += [components[0] integerValue];
        } else if (components.count == 2) {
            for (NSUInteger index = 0; index < [components[0] integerValue]; index++) {
                result += arc4random_uniform((uint32_t)[components[1] integerValue]) + 1;
            }
        }
    }
    return result;
}

@end
