//
//  SpellCellNode.h
//  dnd
//
//  Created by Devon Tivona on 11/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Spell;

@interface SpellCellNode : ASCellNode

- (instancetype)initWithSpell:(Spell *)spell detailed:(BOOL)detailed;

@end
