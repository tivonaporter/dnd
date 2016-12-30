//
//  CollectionItem.h
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <Realm/Realm.h>
#import "Spell.h"
#import "Item.h"
#import "Monster.h"

@interface CollectionItem : RLMObject

@property Spell *spell;
@property Item *item;
@property Monster *monster;
@property NSString *identifier;

@end

RLM_ARRAY_TYPE(CollectionItem)
