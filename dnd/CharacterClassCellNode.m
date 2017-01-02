//
//  CharacterClassCellNode.m
//  dnd
//
//  Created by Katie Porter on 1/1/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import "CharacterClassCellNode.h"
#import "DetailLabelNode.h"
#import "CharacterClass.h"
#import "NSString+Extra.h"
#import "ASStackLayoutSpec+Tokyo.h"
#import "ASTextNode+Extra.h"
#import "FeatureNode.h"

@interface CharacterClassCellNode ()

@property (nonatomic, strong) ASTextNode *nameLabel;
@property (nonatomic, strong) ASTextNode *detailLabel;
@property (nonatomic, strong) DetailLabelNode *hitDieLabel;
@property (nonatomic, strong) DetailLabelNode *proficiencyLabel;
@property (nonatomic, strong) DetailLabelNode *spellAbilityLabel;
@property (nonatomic, strong) ASImageNode *imageNode;
@property (nonatomic, assign) BOOL detailed;
@property (nonatomic, strong) NSArray *featureNodes;

@end

@implementation CharacterClassCellNode

- (instancetype)initWithCharacterClass:(CharacterClass *)characterClass detailed:(BOOL)detailed
{
    if (!(self = [super init])) return nil;
    
    self.detailed = detailed;
    
    self.automaticallyManagesSubnodes = YES;
    
    self.nameLabel = [[ASTextNode alloc] init];
    self.nameLabel.attributedText = [characterClass.name stringWithTextStyle:UIFontTextStyleTitle2];
    
    self.imageNode = [[ASImageNode alloc] init];
    self.imageNode.image = [UIImage imageNamed:@"class-icon"];
    
    if (self.detailed) {
        self.hitDieLabel = [[DetailLabelNode alloc] init];
        self.hitDieLabel.title = @"Hit Die";
        self.hitDieLabel.value = [characterClass.hitDie stringValue];
        
        self.proficiencyLabel = [[DetailLabelNode alloc] init];
        self.proficiencyLabel.title = @"Proficiency";
        self.proficiencyLabel.value = characterClass.proficiency;
        
        self.spellAbilityLabel = [[DetailLabelNode alloc] init];
        self.spellAbilityLabel.title = @"Spell Ability";
        self.spellAbilityLabel.value = characterClass.spellAbility;
    } else {
        self.detailLabel = [[ASTextNode alloc] init];
        self.detailLabel.attributedText = [characterClass.proficiency stringWithTextStyle:UIFontTextStyleCaption1];
    }
    
    NSMutableArray *featureNodes = [[NSMutableArray alloc] init];
    for (Feature *feature in [characterClass.features sortedResultsUsingProperty:@"level" ascending:YES]) {
        [featureNodes addObject:[[FeatureNode alloc] initWithFeature:feature]];
    }
    self.featureNodes = featureNodes;
    
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
        
        NSMutableArray *secondRowChildren = [@[
                                               self.hitDieLabel,
                                               self.proficiencyLabel
                                               ] mutableCopy];
        if (self.spellAbilityLabel.value) [secondRowChildren addObject:self.spellAbilityLabel];
        
        ASStackLayoutSpec *secondRow = [ASStackLayoutSpec gridSpecWithChildren:secondRowChildren
                                                                         width:constrainedSize.min.width - 40.0f];
        
        NSMutableArray  *verticalChildren = [@[nameInsetSpec, secondRow] mutableCopy];
        [verticalChildren addObjectsFromArray:self.featureNodes];
        
        child = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                        spacing:10.0f
                                                 justifyContent:ASStackLayoutJustifyContentStart
                                                     alignItems:ASStackLayoutAlignItemsStretch
                                                       children:verticalChildren];
    } else {
        ASStackLayoutSpec *nameSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                              spacing:0.0f
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems:ASStackLayoutAlignItemsStart
                                                                             children:@[self.detailLabel,
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
