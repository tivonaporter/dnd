//
//  Item.m
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "Item.h"

@implementation Item

+ (NSString *)primaryKey { return @"name"; }

- (NSString *)typeString
{
    if ([self.type isEqualToString:@"W"]) return @"Wondrous Item";
    if ([self.type isEqualToString:@"LA"]) return @"Light Armor";
    if ([self.type isEqualToString:@"MA"]) return @"Medium Armor";
    if ([self.type isEqualToString:@"HA"]) return @"Heavy Armor";
    if ([self.type isEqualToString:@"$"]) return @"Money";
    if ([self.type isEqualToString:@"G"]) return @"Adventuring Gear";
    if ([self.type isEqualToString:@"R"]) return @"Ranged Weapon";
    if ([self.type isEqualToString:@"M"]) return @"Melee Weapon";
    if ([self.type isEqualToString:@"P"]) return @"Potion";
    if ([self.type isEqualToString:@"ST"]) return @"Staff";
    if ([self.type isEqualToString:@"RD"]) return @"Rod";
    if ([self.type isEqualToString:@"RG"]) return @"Ring";
    if ([self.type isEqualToString:@"SC"]) return @"Scroll";
    if ([self.type isEqualToString:@"WD"]) return @"Wand";
    if ([self.type isEqualToString:@"S"]) return @"Shield";
    if ([self.type isEqualToString:@"A"]) return @"Ammunition";
    return @"Unknown";
}

@end
