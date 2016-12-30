//
//  ActionNode.m
//  dnd
//
//  Created by Devon Tivona on 12/26/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "ActionNode.h"
#import "Action.h"
#import "NSString+Extra.h"
#import "ASTextNode+Extra.h"

@interface ActionNode ()

@property (nonatomic, strong) ASTextNode *nameNode;
@property (nonatomic, strong) ASTextNode *textNode;
@property (nonatomic, strong) ASTextNode *attackNode;
@property (nonatomic, strong) ASTextNode *subtitleNode;

@end

@implementation ActionNode

- (instancetype)initWithAction:(Action *)action
{
    if (!(self = [super init])) return nil;
    
    self.automaticallyManagesSubnodes = YES;
    
    self.nameNode = [[ASTextNode alloc] init];
    self.nameNode.attributedText = [action.name stringWithTextStyle:UIFontTextStyleHeadline];
    
    self.subtitleNode = [[ASTextNode alloc] init];
    self.subtitleNode.attributedText = [@"Action" stringWithTextStyle:UIFontTextStyleCaption2];

    self.textNode = [ASTextNode linkedTextNodeWithAttributedString:[action.text stringWithBodyTextStyle]];
    
    if (action.attack) {
        NSString *string = [action attackDiceRoll];
        if ([action attackDiceRollAverage]) {
            string = [NSString stringWithFormat:@"%@ (%@)", string, [action attackDiceRollAverage]];
        }
        self.attackNode = [ASTextNode linkedTextNodeWithAttributedString:[[action attackDiceRoll] stringWithBodyTextStyle]];
    }
    
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
    
    NSMutableArray *verticalChildren = [@[nameSpec, self.textNode] mutableCopy];
    if (self.attackNode) [verticalChildren addObject:self.attackNode];
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:10.0f
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStretch
                                                                          children:verticalChildren];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f) child:stackSpec];
}

@end
