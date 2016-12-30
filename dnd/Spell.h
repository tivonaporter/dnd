//
//  Spell.h
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <Realm/Realm.h>

@interface Spell : RLMObject

@property NSString *name;
@property NSString *level;
@property NSString *school;
@property NSString *time;
@property NSString *range;
@property NSString *components;
@property NSString *duration;
@property NSString *classes;
@property NSString *text;

@end

RLM_ARRAY_TYPE(Spell)
