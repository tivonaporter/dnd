//
//  CharacterClass.h
//  dnd
//
//  Created by Katie Porter on 1/1/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <Realm/Realm.h>
#import "Feature.h"

@interface CharacterClass : RLMObject

@property NSString *name;
@property NSNumber<RLMInt> *hitDie;
@property NSString *proficiency;
@property NSString *spellAbility;
@property RLMArray<Feature *><Feature> *features;

@end
