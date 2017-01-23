//
//  Item.h
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <Realm/Realm.h>

@interface Item : RLMObject

@property NSString *name;
@property NSString *type;
@property NSString *modifier;
@property NSString *weight;
@property NSString *strength;
@property NSString *AC;
@property NSString *damage;
@property NSString *damageType;
@property NSString *property;
@property NSString *range;
@property NSString *stealth;
@property NSString *text;
@property NSString *value;

- (NSString *)typeString;

@end
