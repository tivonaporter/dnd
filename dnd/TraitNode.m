//
//  TraitNode.m
//  dnd
//
//  Created by Devon Tivona on 12/26/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "TraitNode.h"
#import "Trait.h"
#import "NSString+Extra.h"

@interface TraitNode ()

@property (nonatomic, strong) ASTextNode *nameNode;
@property (nonatomic, strong) ASTextNode *textNode;
@property (nonatomic, strong) ASTextNode *subtitleNode;

@end

@implementation TraitNode

- (instancetype)initWithTrait:(Trait *)trait
{
    if (!(self = [super init])) return nil;
    
    self.automaticallyManagesSubnodes = YES;
    
    self.nameNode = [[ASTextNode alloc] init];
    self.nameNode.attributedText = [trait.name stringWithTextStyle:UIFontTextStyleHeadline];
    
    self.subtitleNode = [[ASTextNode alloc] init];
    self.subtitleNode.attributedText = [@"Trait" stringWithTextStyle:UIFontTextStyleCaption2];
    
    self.textNode = [[ASTextNode alloc] init];
    self.textNode.attributedText = [trait.text stringWithBodyTextStyle];
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    
    ASStackLayoutSpec *nameSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:0.0f
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStretch
                                                                          children:@[
                                                                                     self.subtitleNode,
                                                                                     self.nameNode]];
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:5.0f
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStretch
                                                                          children:@[
                                                                                     nameSpec,
                                                                                     self.textNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f) child:stackSpec];
}


@end
