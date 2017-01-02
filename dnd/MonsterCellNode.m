//
//  MonsterCellNode.m
//  dnd
//
//  Created by Devon Tivona on 11/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "MonsterCellNode.h"
#import "DetailLabelNode.h"
#import "Monster.h"
#import "NSString+Extra.h"
#import "TraitNode.h"
#import "Trait.h"
#import "ActionNode.h"
#import "Action.h"
#import "ASStackLayoutSpec+Tokyo.h"

@interface MonsterCellNode ()

@property (nonatomic, strong) ASTextNode *nameLabel;
@property (nonatomic, strong) ASTextNode *detailLabel;
@property (nonatomic, strong) DetailLabelNode *strengthLabel;
@property (nonatomic, strong) DetailLabelNode *dexterityLabel;
@property (nonatomic, strong) DetailLabelNode *constitutionLabel;
@property (nonatomic, strong) DetailLabelNode *intelligenceLabel;
@property (nonatomic, strong) DetailLabelNode *wisdomLabel;
@property (nonatomic, strong) DetailLabelNode *charismaLabel;

@property (nonatomic, strong) DetailLabelNode *sizeLabel;
@property (nonatomic, strong) DetailLabelNode *alignmentLabel;
@property (nonatomic, strong) DetailLabelNode *ACLabel;
@property (nonatomic, strong) DetailLabelNode *HPLabel;
@property (nonatomic, strong) DetailLabelNode *passiveWisdomLabel;
@property (nonatomic, strong) DetailLabelNode *challengeRatingLabel;
@property (nonatomic, strong) DetailLabelNode *typeLabel;
@property (nonatomic, strong) DetailLabelNode *speedLabel;
@property (nonatomic, strong) DetailLabelNode *languagesLabel;
@property (nonatomic, strong) DetailLabelNode *resistLabel;
@property (nonatomic, strong) DetailLabelNode *immuneLabel;
@property (nonatomic, strong) DetailLabelNode *conditionImmuneLabel;
@property (nonatomic, strong) DetailLabelNode *sensesLabel;
@property (nonatomic, strong) DetailLabelNode *spellsLabel;
@property (nonatomic, strong) ASImageNode *imageNode;
@property (nonatomic, strong) NSArray *traitNodes;
@property (nonatomic, strong) NSArray *actionNodes;
@property (nonatomic, assign) BOOL detailed;

@end

@implementation MonsterCellNode

- (instancetype)initWithMonster:(Monster *)monster detailed:(BOOL)detailed
{
    if (!(self = [super init])) return nil;
    
    self.automaticallyManagesSubnodes = YES;
    
    self.detailed = detailed;
    
    self.nameLabel = [[ASTextNode alloc] init];
    self.nameLabel.attributedText = [monster.name stringWithTextStyle:UIFontTextStyleTitle2];
    
    self.imageNode = [[ASImageNode alloc] init];
    self.imageNode.image = [UIImage imageNamed:@"monster-icon"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 1;
    formatter.minimumFractionDigits = 0;
    formatter.minimumIntegerDigits = 1;
    NSString *challengeRatingString = [formatter stringFromNumber:monster.challengeRating];
    
    if (self.detailed) {
        
        self.strengthLabel = [[DetailLabelNode alloc] init];
        self.strengthLabel.title = @"STR";
        self.strengthLabel.value = [monster.strength stringValue];
        
        self.dexterityLabel = [[DetailLabelNode alloc] init];
        self.dexterityLabel.title = @"DEX";
        self.dexterityLabel.value = [monster.dexterity stringValue];
        
        self.constitutionLabel = [[DetailLabelNode alloc] init];
        self.constitutionLabel.title = @"CON";
        self.constitutionLabel.value = [monster.constitution stringValue];
        
        self.intelligenceLabel = [[DetailLabelNode alloc] init];
        self.intelligenceLabel.title = @"INT";
        self.intelligenceLabel.value = [monster.intelligence stringValue];
        
        self.wisdomLabel = [[DetailLabelNode alloc] init];
        self.wisdomLabel.title = @"WIS";
        self.wisdomLabel.value = [monster.wisdom stringValue];
        
        self.charismaLabel = [[DetailLabelNode alloc] init];
        self.charismaLabel.title = @"CHA";
        self.charismaLabel.value = [monster.charisma stringValue];
        self.charismaLabel.alignment = NSTextAlignmentRight;
        
        self.sizeLabel = [[DetailLabelNode alloc] init];
        self.sizeLabel.title = @"Size";
        self.sizeLabel.value = [monster.size capitalizedString];
        
        self.alignmentLabel = [[DetailLabelNode alloc] init];
        self.alignmentLabel.title = @"Alignment";
        self.alignmentLabel.value = [monster.alignment capitalizedString];
        
        self.ACLabel = [[DetailLabelNode alloc] init];
        self.ACLabel.title = @"AC";
        self.ACLabel.value = monster.AC;
        
        self.HPLabel = [[DetailLabelNode alloc] init];
        self.HPLabel.title = @"HP";
        self.HPLabel.value = monster.HP;
        
        self.passiveWisdomLabel = [[DetailLabelNode alloc] init];
        self.passiveWisdomLabel.title = @"Passive Wisdom";
        self.passiveWisdomLabel.value = [monster.passiveWisdom stringValue];
        
        self.challengeRatingLabel = [[DetailLabelNode alloc] init];
        self.challengeRatingLabel.title = @"CR";
        self.challengeRatingLabel.value = challengeRatingString;
        
        self.typeLabel = [[DetailLabelNode alloc] init];
        self.typeLabel.title = @"Type";
        self.typeLabel.value = [monster.type capitalizedString];
        
        self.speedLabel = [[DetailLabelNode alloc] init];
        self.speedLabel.title = @"Speed";
        self.speedLabel.value = [monster.speed capitalizedString];
        
        self.languagesLabel = [[DetailLabelNode alloc] init];
        self.languagesLabel.title = @"Languages";
        self.languagesLabel.value = [monster.languages capitalizedString];
        
        self.resistLabel = [[DetailLabelNode alloc] init];
        self.resistLabel.title = @"Resitances";
        self.resistLabel.value = [monster.resist capitalizedString];
        
        self.immuneLabel = [[DetailLabelNode alloc] init];
        self.immuneLabel.title = @"Immunities";
        self.immuneLabel.value = [monster.immune capitalizedString];
        
        self.conditionImmuneLabel = [[DetailLabelNode alloc] init];
        self.conditionImmuneLabel.title = @"Condition Immunities";
        self.conditionImmuneLabel.value = [monster.conditionImmune capitalizedString];
        
        self.sensesLabel = [[DetailLabelNode alloc] init];
        self.sensesLabel.title = @"Senses";
        self.sensesLabel.value = [monster.senses capitalizedString];
        
        self.spellsLabel = [[DetailLabelNode alloc] init];
        self.spellsLabel.title = @"Spells";
        self.spellsLabel.value = [monster.spells capitalizedString];
        
        NSMutableArray *traitNodes = [[NSMutableArray alloc] init];
        for (Trait *trait in monster.traits) {
            [traitNodes addObject:[[TraitNode alloc] initWithTrait:trait]];
        }
        self.traitNodes = traitNodes;
        
        NSMutableArray *actionNodes = [[NSMutableArray alloc] init];
        for (Action *action in monster.actions) {
            [actionNodes addObject:[[ActionNode alloc] initWithAction:action]];
        }
        self.actionNodes = actionNodes;
    } else {
        self.detailLabel = [[ASTextNode alloc] init];
        self.detailLabel.attributedText = [[NSString stringWithFormat:@"CR %@", challengeRatingString] stringWithTextStyle:UIFontTextStyleCaption1];
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
        
        ASStackLayoutSpec *firstRow = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:10.0f
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems:ASStackLayoutAlignItemsStretch
                                                                             children:@[
                                                                                        self.strengthLabel,
                                                                                        self.dexterityLabel,
                                                                                        self.constitutionLabel,
                                                                                        self.intelligenceLabel,
                                                                                        self.wisdomLabel,
                                                                                        self.charismaLabel
                                                                                        ]];
        NSMutableArray *secondRowChildren = [[NSMutableArray alloc] init];
        if (self.sizeLabel.value) [secondRowChildren addObject:self.sizeLabel];
        if (self.ACLabel.value) [secondRowChildren addObject:self.ACLabel];
        if (self.HPLabel.value) [secondRowChildren addObject:self.HPLabel];
        if (self.passiveWisdomLabel.value) [secondRowChildren addObject:self.passiveWisdomLabel];
        if (self.challengeRatingLabel.value) [secondRowChildren addObject:self.challengeRatingLabel];
        if (self.alignmentLabel.value) [secondRowChildren addObject:self.alignmentLabel];
        if (self.typeLabel.value) [secondRowChildren addObject:self.typeLabel];
        if (self.speedLabel.value) [secondRowChildren addObject:self.speedLabel];
        if (self.languagesLabel.value) [secondRowChildren addObject:self.languagesLabel];
        if (self.resistLabel.value) [secondRowChildren addObject:self.resistLabel];
        if (self.immuneLabel.value) [secondRowChildren addObject:self.immuneLabel];
        if (self.conditionImmuneLabel.value) [secondRowChildren addObject:self.conditionImmuneLabel];
        if (self.sensesLabel.value) [secondRowChildren addObject:self.sensesLabel];
        if (self.spellsLabel.value) [secondRowChildren addObject:self.spellsLabel];
        
        ASStackLayoutSpec *secondRow = [ASStackLayoutSpec gridSpecWithChildren:secondRowChildren width:constrainedSize.min.width - 40.0f];
        
        NSMutableArray  *verticalChildren = [@[nameInsetSpec, firstRow, secondRow] mutableCopy];
        [verticalChildren addObjectsFromArray:self.traitNodes];
        [verticalChildren addObjectsFromArray:self.actionNodes];
        
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
