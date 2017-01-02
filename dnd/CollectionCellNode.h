//
//  CollectionCellNode.h
//  dnd
//
//  Created by Katie Porter on 12/30/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Collection;

@interface CollectionCellNode : ASCellNode

+ (instancetype)collectionCellNodeWithCollection:(Collection *)collection;

@end
