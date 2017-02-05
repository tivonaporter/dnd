//
//  CompendiumCellNode.h
//  dnd
//
//  Created by Katie Porter on 2/4/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

typedef enum : NSUInteger {
    CompendiumNodeTypeSpell,
    CompendiumNodeTypeItem,
    CompendiumNodeTypeMonster,
    CompendiumNodeTypeClass
} CompendiumNodeType;

@interface CompendiumCellNode : ASCellNode

+ (instancetype)compendiumNodeWithType:(CompendiumNodeType)type;

@end
