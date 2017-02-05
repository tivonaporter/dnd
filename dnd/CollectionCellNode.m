//
//  CollectionCellNode.m
//  dnd
//
//  Created by Katie Porter on 12/30/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "NSString+Extra.h"
#import "CollectionCellNode.h"
#import "Collection.h"

@interface CollectionCellNode ()

@property (nonatomic, strong) ASTextNode *nameLabel;

@end

@implementation CollectionCellNode

+ (instancetype)collectionCellNodeWithCollection:(Collection *)collection
{
    CollectionCellNode *node = [[CollectionCellNode alloc] init];
    
    node.automaticallyManagesSubnodes = YES;
    node.nameLabel = [[ASTextNode alloc] init];
    node.nameLabel.attributedText = [collection.name stringWithSecondaryTitleTextStyle];
    
    return node;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f)
                                                                                 child:self.nameLabel];
}

@end
