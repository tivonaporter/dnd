//
//  ItemCellNode.h
//  dnd
//
//  Created by Devon Tivona on 11/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Item;

@interface ItemCellNode : ASCellNode

- (instancetype)initWithItem:(Item *)item detailed:(BOOL)detailed;

@end
