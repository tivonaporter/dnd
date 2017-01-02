//
//  FeatureNode.m
//  dnd
//
//  Created by Katie Porter on 1/1/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import "FeatureNode.h"
#import "Feature.h"
#import "NSString+Extra.h"

@interface FeatureNode ()

@property (nonatomic, strong) ASTextNode *nameNode;
@property (nonatomic, strong) ASTextNode *textNode;
@property (nonatomic, strong) ASTextNode *subtitleNode;
@end

@implementation FeatureNode

- (instancetype)initWithFeature:(Feature *)feature
{
    if (!(self = [super init])) return nil;
    
    self.automaticallyManagesSubnodes = YES;
    
    self.nameNode = [[ASTextNode alloc] init];
    self.nameNode.attributedText = [feature.name stringWithTextStyle:UIFontTextStyleHeadline];
    
    NSString *subtitle = [NSString stringWithFormat:@"Level %lu%@", [feature.level unsignedLongValue], feature.optional ? @" (Optional)" : @""];
    self.subtitleNode = [[ASTextNode alloc] init];
    self.subtitleNode.attributedText = [subtitle stringWithTextStyle:UIFontTextStyleCaption2];
    
    self.textNode = [[ASTextNode alloc] init];
    self.textNode.attributedText = [feature.text stringWithBodyTextStyle];
    
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
