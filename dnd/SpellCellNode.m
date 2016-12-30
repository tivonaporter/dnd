//
//  SpellCellNode.m
//  dnd
//
//  Created by Devon Tivona on 11/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "SpellCellNode.h"
#import "DetailLabelNode.h"
#import "Spell.h"
#import "NSString+Extra.h"
#import "ASStackLayoutSpec+Tokyo.h"
#import "ASTextNode+Extra.h"

@interface SpellCellNode ()

@property (nonatomic, strong) ASTextNode *nameLabel;
@property (nonatomic, strong) DetailLabelNode *levelLabel;
@property (nonatomic, strong) DetailLabelNode *schoolLabel;
@property (nonatomic, strong) DetailLabelNode *timeLabel;
@property (nonatomic, strong) DetailLabelNode *rangeLabel;
@property (nonatomic, strong) DetailLabelNode *componentsLabel;
@property (nonatomic, strong) DetailLabelNode *durationLabel;
@property (nonatomic, strong) DetailLabelNode *classesLabel;
@property (nonatomic, strong) ASTextNode *textLabel;
@property (nonatomic, strong) ASImageNode *imageNode;
@property (nonatomic, assign) BOOL detailed;

@end

@implementation SpellCellNode

- (instancetype)initWithSpell:(Spell *)spell detailed:(BOOL)detailed
{
    if (!(self = [super init])) return nil;
    
    self.detailed = detailed;
    
    self.automaticallyManagesSubnodes = YES;
    
    self.nameLabel = [[ASTextNode alloc] init];
    self.nameLabel.attributedText = [spell.name stringWithTextStyle:UIFontTextStyleTitle2];
    
    self.imageNode = [[ASImageNode alloc] init];
    self.imageNode.image = [UIImage imageNamed:@"spell-icon"];
    
    if (self.detailed) {
    
        self.levelLabel = [[DetailLabelNode alloc] init];
        self.levelLabel.title = @"Level";
        self.levelLabel.value = spell.level;
        
        self.schoolLabel = [[DetailLabelNode alloc] init];
        self.schoolLabel.title = @"School";
        self.schoolLabel.value = spell.school;
        
        self.timeLabel = [[DetailLabelNode alloc] init];
        self.timeLabel.title = @"Time";
        self.timeLabel.value = spell.time;
        
        self.rangeLabel = [[DetailLabelNode alloc] init];
        self.rangeLabel.title = @"Range";
        self.rangeLabel.value = spell.range;
        
        self.componentsLabel = [[DetailLabelNode alloc] init];
        self.componentsLabel.title = @"Components";
        self.componentsLabel.value = spell.components;
        
        self.durationLabel = [[DetailLabelNode alloc] init];
        self.durationLabel.title = @"Duration";
        self.durationLabel.value = spell.duration;
        
        self.classesLabel = [[DetailLabelNode alloc] init];
        self.classesLabel.title = @"Classes";
        self.classesLabel.value = spell.classes;
        
        self.textLabel = [ASTextNode linkedTextNodeWithAttributedString:[spell.text stringWithBodyTextStyle]];
        
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    
    self.imageNode.style.preferredSize = CGSizeMake(30.0f, 30.0f);
    self.nameLabel.style.flexShrink = 1.0f;
    
    id<ASLayoutElement> child;
    
    ASStackLayoutSpec *nameSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                          spacing:10.0f
                                                                   justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                       alignItems:ASStackLayoutAlignItemsStretch
                                                                         children:@[
                                                                                    self.nameLabel,
                                                                                    self.imageNode]];
    
    if (self.detailed) {
    
        ASInsetLayoutSpec *nameInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f) child:nameSpec];
        
        ASStackLayoutSpec *secondRow = [ASStackLayoutSpec gridSpecWithChildren:@[
                                                                                 self.levelLabel,
                                                                                 self.schoolLabel,
                                                                                 self.timeLabel,
                                                                                 self.rangeLabel,
                                                                                 self.durationLabel,
                                                                                 self.componentsLabel,
                                                                                 self.classesLabel,
                                                                                 self.textLabel
                                                                                 ]
                                                                         width:constrainedSize.min.width - 40.0f];
        
        child = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                        spacing:10.0f
                                                 justifyContent:ASStackLayoutJustifyContentStart
                                                     alignItems:ASStackLayoutAlignItemsStretch
                                                       children:@[
                                                                  nameInsetSpec,
                                                                  secondRow
                                                                  ]];
    } else {
        child = nameSpec;
    }
    
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f)
                                                                          child:child];
    
    return insetSpec;
}
@end
