//
//  RaceCellNode.m
//  dnd
//
//  Created by Katie Porter on 2/5/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import "RaceCellNode.h"
#import "DetailLabelNode.h"
#import "Race.h"
#import "NSString+Extra.h"
#import "ASStackLayoutSpec+Tokyo.h"
#import "ASTextNode+Extra.h"
#import "TraitNode.h"

@interface RaceCellNode ()

@property (nonatomic, strong) ASTextNode *nameLabel;
@property (nonatomic, strong) ASTextNode *detailLabel;
@property (nonatomic, strong) DetailLabelNode *sizeLabel;
@property (nonatomic, strong) DetailLabelNode *speedLabel;
@property (nonatomic, strong) DetailLabelNode *abilityLabel;
@property (nonatomic, strong) DetailLabelNode *proficiencyLabel;
@property (nonatomic, strong) ASImageNode *imageNode;
@property (nonatomic, assign) BOOL detailed;
@property (nonatomic, strong) NSArray *traitNodes;

@end

@implementation RaceCellNode

- (instancetype)initWithRace:(Race *)race detailed:(BOOL)detailed
{
    if (!(self = [super init])) return nil;
    
    self.detailed = detailed;
    
    self.automaticallyManagesSubnodes = YES;
    
    self.nameLabel = [[ASTextNode alloc] init];
    
    self.imageNode = [[ASImageNode alloc] init];
    self.imageNode.image = [UIImage imageNamed:@"race-icon"];
    
    if (self.detailed) {
        self.nameLabel.attributedText = [race.name stringWithPrimaryTitleTextStyle];
        
        self.sizeLabel = [[DetailLabelNode alloc] init];
        self.sizeLabel.title = @"Size";
        self.sizeLabel.value = race.size;
        
        self.speedLabel = [[DetailLabelNode alloc] init];
        self.speedLabel.title = @"Speed";
        self.speedLabel.value = [race.speed stringValue];
        
        self.abilityLabel = [[DetailLabelNode alloc] init];
        self.abilityLabel.title = @"Ability";
        self.abilityLabel.value = race.ability;
        
        self.proficiencyLabel = [[DetailLabelNode alloc] init];
        self.proficiencyLabel.title = @"Proficiency";
        self.proficiencyLabel.value = race.proficiency;
        
        NSMutableArray *traitNodes = [[NSMutableArray alloc] init];
        for (Trait *trait in race.traits) {
            [traitNodes addObject:[[TraitNode alloc] initWithTrait:trait]];
        }
        self.traitNodes = traitNodes;
    } else {
        self.nameLabel.attributedText = [race.name stringWithSecondaryTitleTextStyle];
        self.detailLabel = [[ASTextNode alloc] init];
        self.detailLabel.attributedText = [race.ability stringWithTextStyle:UIFontTextStyleCaption1];
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
        
        NSMutableArray *secondRowChildren = [@[
                                               self.sizeLabel,
                                               self.speedLabel
                                               ] mutableCopy];
        if (self.abilityLabel.value) [secondRowChildren addObject:self.abilityLabel];
        if (self.proficiencyLabel.value) [secondRowChildren addObject:self.proficiencyLabel];
        
        ASStackLayoutSpec *secondRow = [ASStackLayoutSpec gridSpecWithChildren:secondRowChildren
                                                                         width:constrainedSize.min.width - 40.0f];
        
        NSMutableArray  *verticalChildren = [@[nameInsetSpec, secondRow] mutableCopy];
        [verticalChildren addObjectsFromArray:self.traitNodes];
        
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
