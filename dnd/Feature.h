//
//  Feature.h
//  dnd
//
//  Created by Katie Porter on 1/1/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <Realm/Realm.h>

@interface Feature : RLMObject

@property NSString *identifier;
@property NSString *name;
@property NSString *text;
@property NSNumber<RLMInt> *level;
@property BOOL optional;

@end

RLM_ARRAY_TYPE(Feature);
