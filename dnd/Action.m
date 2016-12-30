//
//  Action.m
//  dnd
//
//  Created by Devon Tivona on 11/20/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "Action.h"

@implementation Action

+ (NSString *)primaryKey { return @"identifier"; }

- (NSString *)attackDiceRoll
{
    NSString *string = [self.attack componentsSeparatedByString:@"|"][2];
    return ([string isEqualToString:@""]) ? nil : string;
}

- (NSString *)attackDiceRollAverage
{
    NSString *string = [self.attack componentsSeparatedByString:@"|"][1];
    return ([string isEqualToString:@""]) ? nil : string;
}

@end
