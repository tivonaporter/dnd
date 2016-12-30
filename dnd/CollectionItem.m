//
//  CollectionItem.m
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "CollectionItem.h"

@implementation CollectionItem

+ (NSString *)primaryKey { return @"identifier"; }

+ (NSDictionary *)defaultPropertyValues
{
    return @{ @"identifier" : [[NSUUID UUID] UUIDString] };
}

@end
