//
//  CompendiumCellNode.m
//  dnd
//
//  Created by Katie Porter on 2/4/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <UIImage_Additions/UIImage+Additions.h>
#import <UIColor_HexString/UIColor+HexString.h>

#import "CompendiumCellNode.h"
#import "NSString+Extra.h"

@interface CompendiumCellNode ()

@property (nonatomic, strong) ASDisplayNode *gradientNode;
@property (nonatomic, strong) ASTextNode *nameNode;
@property (nonatomic, strong) ASImageNode *imageNode;

@end

@implementation CompendiumCellNode

+ (instancetype)compendiumNodeWithType:(CompendiumNodeType)type
{
    CompendiumCellNode *node = [[CompendiumCellNode alloc] init];
    
    node.automaticallyManagesSubnodes = YES;
    node.clipsToBounds = NO;
    
    CGFloat cornerRadius = 5.0f;
    
    NSString *name;
    UIImage *image;
    UIColor *firstColor;
    UIColor *secondColor;
    
    switch (type) {
        case CompendiumNodeTypeItem:
            name = @"Items";
            image = [UIImage imageNamed:@"item-card-icon"];
            firstColor = [UIColor colorWithHexString:@"26D0CE"];
            secondColor = [UIColor colorWithHexString:@"1A2980"];
            break;
        case CompendiumNodeTypeSpell:
            name = @"Spells";
            image = [UIImage imageNamed:@"spell-card-icon"];
            firstColor = [UIColor colorWithHexString:@"F736AD"];
            secondColor = [UIColor colorWithHexString:@"61045F"];
            break;
        case CompendiumNodeTypeMonster:
            name = @"Monsters";
            image = [UIImage imageNamed:@"monster-card-icon"];
            firstColor = [UIColor colorWithHexString:@"F8E04E"];
            secondColor = [UIColor colorWithHexString:@"FF5F00"];
            break;
        case CompendiumNodeTypeClass:
            name = @"Classes";
            image = [UIImage imageNamed:@"class-card-icon"];
            firstColor = [UIColor colorWithHexString:@"FF8C51"];
            secondColor = [UIColor colorWithHexString:@"DD2476"];
            break;
        case CompendiumNodeTypeRace:
            name = @"Races";
            image = [UIImage imageNamed:@"race-card-icon"];
            firstColor = [UIColor colorWithHexString:@"69E396"];
            secondColor = [UIColor colorWithHexString:@"0C886E"];
            break;
    }
    
    node.gradientNode = [[ASDisplayNode alloc] initWithLayerBlock:^CALayer * _Nonnull{
        CAGradientLayer *layer = [[CAGradientLayer alloc] init];
        layer.colors = @[(id)firstColor.CGColor, (id)secondColor.CGColor];
        layer.startPoint = CGPointMake(0.0f, 0.0f);
        layer.endPoint = CGPointMake(1.0f, 1.0f);
        layer.masksToBounds = NO;
        layer.cornerRadius = cornerRadius;
        layer.shadowRadius = 20.0f;
        layer.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.15f].CGColor;
        layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        layer.shadowOpacity = 1.0f;
        
        return layer;
    }];
    
    node.nameNode = [[ASTextNode alloc] init];
    node.nameNode.attributedText = [name stringWithSecondaryTitleTextStyle];
    
    node.imageNode = [[ASImageNode alloc] init];
    node.imageNode.image = [image add_tintedImageWithColor:[UIColor whiteColor] style:ADDImageTintStyleKeepingAlpha];
    node.imageNode.style.preferredSize = CGSizeMake(40.0f, 40.0f);
    
    return node;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    CGFloat inset = 10.0f;
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(inset, inset, inset, inset) child:self.imageNode];
    ASAbsoluteLayoutSpec *staticSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[insetSpec]];
    ASBackgroundLayoutSpec *backgroundSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:staticSpec background:self.gradientNode];
    backgroundSpec.style.flexGrow = 1.0f;
    
    ASStackLayoutSpec *verticalSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                              spacing:8.0f
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems:ASStackLayoutAlignItemsStretch
                                                                             children:@[
                                                                                        backgroundSpec,
                                                                                        self.nameNode
                                                                                        ]];
    
    return verticalSpec;
}

@end
