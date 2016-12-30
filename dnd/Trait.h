//
//  Trait.h
//  dnd
//
//  Created by Devon Tivona on 11/20/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <Realm/Realm.h>

@interface Trait : RLMObject

@property NSString *identifier;
@property NSString *name;
@property NSString *text;

@end

RLM_ARRAY_TYPE(Trait)
