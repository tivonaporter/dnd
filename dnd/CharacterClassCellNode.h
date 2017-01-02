//
//  CharacterClassCellNode.h
//  dnd
//
//  Created by Katie Porter on 1/1/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CharacterClass;

@interface CharacterClassCellNode : ASCellNode

- (instancetype)initWithCharacterClass:(CharacterClass *)characterClass detailed:(BOOL)detailed;

@end
