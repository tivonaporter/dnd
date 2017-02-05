//
//  Race.h
//  dnd
//
//  Created by Katie Porter on 2/5/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <Realm/Realm.h>
#import "Trait.h"

@interface Race : RLMObject

@property NSString *name;
@property NSString *size;
@property NSNumber<RLMInt> *speed;
@property NSString *ability;
@property NSString *proficiency;
@property RLMArray<Trait *><Trait> *traits;

@end
