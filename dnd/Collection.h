//
//  Collection.h
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <Realm/Realm.h>
#import "CollectionItem.h"

@interface Collection : RLMObject

@property NSString *name;
@property RLMArray<CollectionItem *><CollectionItem> *items;

@end
