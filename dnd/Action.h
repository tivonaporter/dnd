//
//  Action.h
//  dnd
//
//  Created by Devon Tivona on 11/20/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <Realm/Realm.h>

@interface Action : RLMObject

@property NSString *identifier;
@property NSString *name;
@property NSString *text;
@property NSString *attack;

- (NSString *)attackDiceRoll;
- (NSString *)attackDiceRollAverage;

@end

RLM_ARRAY_TYPE(Action)
