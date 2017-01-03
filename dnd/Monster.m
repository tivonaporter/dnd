//
//  Monster.m
//  dnd
//
//  Created by Devon Tivona on 11/20/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "Monster.h"

@implementation Monster

+ (NSString *)primaryKey { return @"name"; }

- (NSUInteger)XP
{
    if ([self.challengeRating floatValue] == 0.0f) return 10;
    if ([self.challengeRating floatValue] == 0.125f) return 25;
    if ([self.challengeRating floatValue] == 0.25f) return 50;
    if ([self.challengeRating floatValue] == 0.5f) return 100;
    if ([self.challengeRating floatValue] == 1.0f) return 200;
    if ([self.challengeRating floatValue] == 2.0f) return 450;
    if ([self.challengeRating floatValue] == 3.0f) return 700;
    if ([self.challengeRating floatValue] == 4.0f) return 1100;
    if ([self.challengeRating floatValue] == 5.0f) return 1800;
    if ([self.challengeRating floatValue] == 6.0f) return 2300;
    if ([self.challengeRating floatValue] == 7.0f) return 2900;
    if ([self.challengeRating floatValue] == 8.0f) return 3900;
    if ([self.challengeRating floatValue] == 9.0f) return 5000;
    if ([self.challengeRating floatValue] == 10.0f) return 5900;
    if ([self.challengeRating floatValue] == 11.0f) return 7200;
    if ([self.challengeRating floatValue] == 12.0f) return 8400;
    if ([self.challengeRating floatValue] == 13.0f) return 10000;
    if ([self.challengeRating floatValue] == 14.0f) return 11500;
    if ([self.challengeRating floatValue] == 15.0f) return 13000;
    if ([self.challengeRating floatValue] == 16.0f) return 15000;
    if ([self.challengeRating floatValue] == 17.0f) return 18000;
    if ([self.challengeRating floatValue] == 18.0f) return 20000;
    if ([self.challengeRating floatValue] == 19.0f) return 22000;
    if ([self.challengeRating floatValue] == 20.0f) return 25000;
    if ([self.challengeRating floatValue] == 21.0f) return 33000;
    if ([self.challengeRating floatValue] == 22.0f) return 41000;
    if ([self.challengeRating floatValue] == 23.0f) return 50000;
    if ([self.challengeRating floatValue] == 24.0f) return 62000;
    if ([self.challengeRating floatValue] == 25.0f) return 75000;
    if ([self.challengeRating floatValue] == 26.0f) return 90000;
    if ([self.challengeRating floatValue] == 27.0f) return 105000;
    if ([self.challengeRating floatValue] == 28.0f) return 120000;
    if ([self.challengeRating floatValue] == 29.0f) return 135000;
    if ([self.challengeRating floatValue] == 30.0f) return 155000;
    return 0;
}

@end
