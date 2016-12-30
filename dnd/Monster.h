//
//  Monster.h
//  dnd
//
//  Created by Devon Tivona on 11/20/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "Trait.h"
#import "Action.h"

@interface Monster : RLMObject

@property NSString *name;
@property NSString *size;
@property NSString *type;
@property NSString *alignment;
@property NSString *AC;
@property NSString *HP;
@property NSString *speed;
@property NSNumber<RLMInt> *strength;
@property NSNumber<RLMInt> *dexterity;
@property NSNumber<RLMInt> *constitution;
@property NSNumber<RLMInt> *intelligence;
@property NSNumber<RLMInt> *wisdom;
@property NSNumber<RLMInt> *charisma;
@property NSString *resist;
@property NSString *immune;
@property NSString *conditionImmune;
@property NSString *senses;
@property NSNumber<RLMInt> *passiveWisdom;
@property NSString *languages;
@property NSString *spells;
@property NSNumber<RLMFloat> *challengeRating;
@property RLMArray<Trait *><Trait> *traits;
@property RLMArray<Action *><Action> *actions;

@end
