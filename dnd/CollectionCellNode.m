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
#import "CollectionItem.h"

@interface CollectionCellNode ()

@property (nonatomic, strong) ASTextNode *nameLabel;
@property (nonatomic, strong) ASTextNode *detailLabel;

@end

@implementation CollectionCellNode

+ (instancetype)collectionCellNodeWithCollection:(Collection *)collection
{
    CollectionCellNode *node = [[CollectionCellNode alloc] init];
    
    node.automaticallyManagesSubnodes = YES;
    node.nameLabel = [[ASTextNode alloc] init];
    node.nameLabel.attributedText = [collection.name stringWithPrimaryTitleTextStyle];
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (CollectionItem *item in collection.items) {
        NSString *name;
        if (item.spell) {
            name = item.spell.name;
        } else if (item.item) {
            name = item.item.name;
        } else if (item.monster) {
            name = item.monster.name;
        } else if (item.characterClass) {
            name = item.characterClass.name;
        } else {
            name = item.race.name;
        }
        [names addObject:name];
    }
    NSString *text;
    
    NSInteger maxSize = 5;
    
    if (names.count > maxSize) {
        text = [[names subarrayWithRange:NSMakeRange(0, maxSize)] componentsJoinedByString:@", "];
        text = [NSString stringWithFormat:@"%@, and %lu more", text, names.count - maxSize];
    } else if (names.count >= 3) {
        text = [[names subarrayWithRange:NSMakeRange(0, names.count - 1)] componentsJoinedByString:@", "];
        text = [NSString stringWithFormat:@"%@, and %@", text, names[collection.items.count - 1]];
    } else if (names.count == 2) {
        text = [NSString stringWithFormat:@"%@ and %@", names[0], names[1]];
    } else if (names.count == 1) {
        text = names[0];
    } else if (names.count == 0) {
        text = @"Empty collection";
    }
    
    node.detailLabel = [[ASTextNode alloc] init];
    node.detailLabel.attributedText = [text stringWithTextStyle:UIFontTextStyleCaption1];

    return node;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *verticalSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                              spacing:0.0f
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems:ASStackLayoutAlignItemsStretch
                                                                             children:@[
                                                                                        self.nameLabel,
                                                                                        self.detailLabel
                                                                                        ]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f)
                                                                                 child:verticalSpec];
}

@end
