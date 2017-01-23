//
//  ItemCellNode.m
//  dnd
//
//  Created by Devon Tivona on 11/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "ItemCellNode.h"
#import "DetailLabelNode.h"
#import "Item.h"
#import "NSString+Extra.h"
#import "ASStackLayoutSpec+Tokyo.h"
#import "ASTextNode+Extra.h"

@interface ItemCellNode ()

@property (nonatomic, strong) ASTextNode *nameLabel;
@property (nonatomic, strong) ASTextNode *subtitleLabel;
@property (nonatomic, strong) DetailLabelNode *typeLabel;
@property (nonatomic, strong) DetailLabelNode *modifierLabel;
@property (nonatomic, strong) DetailLabelNode *weightLabel;
@property (nonatomic, strong) DetailLabelNode *strengthLabel;
@property (nonatomic, strong) DetailLabelNode *ACLabel;
@property (nonatomic, strong) DetailLabelNode *damageLabel;
@property (nonatomic, strong) DetailLabelNode *damageTypeLabel;
@property (nonatomic, strong) DetailLabelNode *propertyLabel;
@property (nonatomic, strong) DetailLabelNode *rangeLabel;
@property (nonatomic, strong) DetailLabelNode *stealthLabel;
@property (nonatomic, strong) ASTextNode *textLabel;
@property (nonatomic, strong) ASImageNode *imageNode;
@property (nonatomic, assign) BOOL detailed;

@end

@implementation ItemCellNode

- (instancetype)initWithItem:(Item *)item detailed:(BOOL)detailed
{
    if (!(self = [super init])) return nil;
    
    self.detailed = detailed;
    
    self.automaticallyManagesSubnodes = YES;
    
    NSString *nameString = item.name;
    if (item.value && ![item.value isEqualToString:@""]) {
        nameString = [NSString stringWithFormat:@"%@ (%@)", item.name, item.value];
    }
    
    self.nameLabel = [[ASTextNode alloc] init];
    self.nameLabel.attributedText = [nameString stringWithTextStyle:UIFontTextStyleTitle2];
    
    self.imageNode = [[ASImageNode alloc] init];
    self.imageNode.image = [UIImage imageNamed:@"item-icon"];
    
    if (self.detailed) {

        self.typeLabel = [[DetailLabelNode alloc] init];
        self.typeLabel.title = @"Type";
        self.typeLabel.value = [item typeString];
        
        self.modifierLabel = [[DetailLabelNode alloc] init];
        self.modifierLabel.title = @"Modifier";
        self.modifierLabel.value = item.modifier;
        
        self.weightLabel = [[DetailLabelNode alloc] init];
        self.weightLabel.title = @"Weight";
        self.weightLabel.value = item.weight;
        
        self.strengthLabel = [[DetailLabelNode alloc] init];
        self.strengthLabel.title = @"Strength";
        self.strengthLabel.value = item.strength;
        
        self.ACLabel = [[DetailLabelNode alloc] init];
        self.ACLabel.title = @"AC";
        self.ACLabel.value = item.AC;
        
        self.damageLabel = [[DetailLabelNode alloc] init];
        self.damageLabel.title = @"Damage";
        self.damageLabel.value = item.damage;
        
        self.damageTypeLabel = [[DetailLabelNode alloc] init];
        self.damageTypeLabel.title = @"Damage Type";
        self.damageTypeLabel.value = item.damageType;
        
        self.propertyLabel = [[DetailLabelNode alloc] init];
        self.propertyLabel.title = @"Property";
        self.propertyLabel.value = item.property;
        
        self.rangeLabel = [[DetailLabelNode alloc] init];
        self.rangeLabel.title = @"Range";
        self.rangeLabel.value = item.range;
        
        self.stealthLabel = [[DetailLabelNode alloc] init];
        self.stealthLabel.title = @"Stealth";
        self.stealthLabel.value = item.stealth;
        
        self.textLabel = [ASTextNode linkedTextNodeWithAttributedString:[item.text stringWithBodyTextStyle]];
    } else {
        self.subtitleLabel = [[ASTextNode alloc] init];
        self.subtitleLabel.attributedText = [[item typeString] stringWithTextStyle:UIFontTextStyleCaption1];
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    
    self.imageNode.style.preferredSize = CGSizeMake(30.0f, 30.0f);
    self.nameLabel.style.flexShrink = 1.0f;
    
    id<ASLayoutElement> child;
    
    if (self.detailed) {
        ASStackLayoutSpec *nameSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:10.0f
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems:ASStackLayoutAlignItemsStretch
                                                                             children:@[
                                                                                        self.nameLabel,
                                                                                        self.imageNode]];
        
        ASInsetLayoutSpec *nameInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f) child:nameSpec];
        
        NSMutableArray *secondRowChildren = [[NSMutableArray alloc] init];
        if (self.typeLabel.value) [secondRowChildren addObject:self.typeLabel];
        if (self.modifierLabel.value) [secondRowChildren addObject:self.modifierLabel];
        if (self.weightLabel.value) [secondRowChildren addObject:self.weightLabel];
        if (self.strengthLabel.value) [secondRowChildren addObject:self.strengthLabel];
        if (self.ACLabel.value) [secondRowChildren addObject:self.ACLabel];
        if (self.damageLabel.value) [secondRowChildren addObject:self.damageLabel];
        if (self.damageTypeLabel.value) [secondRowChildren addObject:self.damageTypeLabel];
        if (self.propertyLabel.value) [secondRowChildren addObject:self.propertyLabel];
        if (self.rangeLabel.value) [secondRowChildren addObject:self.rangeLabel];
        if (self.stealthLabel.value) [secondRowChildren addObject:self.stealthLabel];
        
        ASStackLayoutSpec *secondRow = [ASStackLayoutSpec gridSpecWithChildren:secondRowChildren width:constrainedSize.min.width - 40.0f];
        
        child = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                        spacing:10.0f
                                                 justifyContent:ASStackLayoutJustifyContentStart
                                                     alignItems:ASStackLayoutAlignItemsStretch
                                                       children:@[
                                                                  nameInsetSpec,
                                                                  secondRow,
                                                                  self.textLabel]];
    } else {
        ASStackLayoutSpec *nameSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                              spacing:0.0f
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems:ASStackLayoutAlignItemsStart
                                                                             children:@[self.subtitleLabel,
                                                                                        self.nameLabel]];
        nameSpec.style.flexShrink = 1.0f;
        
        ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                               spacing:10.0f
                                                                        justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                            alignItems:ASStackLayoutAlignItemsCenter
                                                                              children:@[nameSpec,
                                                                                         self.imageNode]];
        
        child = stackSpec;
    }
    
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f)
                                                                          child:child];
    return insetSpec;
}
@end
