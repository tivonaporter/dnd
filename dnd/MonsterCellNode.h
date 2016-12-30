//
//  MonsterCellNode.h
//  dnd
//
//  Created by Devon Tivona on 11/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Monster;

@interface MonsterCellNode : ASCellNode

- (instancetype)initWithMonster:(Monster *)monster detailed:(BOOL)detailed;

@end
