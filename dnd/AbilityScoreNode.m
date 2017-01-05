//
//  AbilityScoreNode.m
//  dnd
//
//  Created by Katie Porter on 1/3/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import "AbilityScoreNode.h"
#import "NSString+Extra.h"
#import "RollManager.h"

@interface AbilityScoreNode () <ASTextNodeDelegate>

@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *scoreNode;
@property (nonatomic, strong) ASTextNode *modifierNode;

@end

@implementation AbilityScoreNode

+ (instancetype)abilityScoreNodeWithTitle:(NSString *)title score:(NSNumber *)score
{
    AbilityScoreNode *node = [[AbilityScoreNode alloc] init];
 
    node.automaticallyManagesSubnodes = YES;
    
    node.titleNode = [[ASTextNode alloc] init];
    node.scoreNode = [[ASTextNode alloc] init];
    node.modifierNode = [[ASTextNode alloc] init];
    
    node.titleNode.attributedText = [title stringWithTextStyle:UIFontTextStyleCaption2];
    node.scoreNode.attributedText = [[score stringValue] stringWithTextStyle:UIFontTextStyleCaption2];
    
    NSMutableAttributedString *modiferString = [[[NSString modifierStringForAbilityScore:score] stringWithTextStyle:UIFontTextStyleHeadline] mutableCopy];
    NSRange range = NSMakeRange(0, modiferString.length);
    [modiferString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    [modiferString addAttribute:NSForegroundColorAttributeName value:node.modifierNode.tintColor range:range];
    
    node.modifierNode.linkAttributeNames = @[NSUnderlineStyleAttributeName];
    node.modifierNode.delegate = node;
    node.modifierNode.userInteractionEnabled = YES;
    node.modifierNode.attributedText = modiferString;
    
    return node;
}

- (void)textNode:(ASTextNode *)textNode tappedLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point textRange:(NSRange)textRange
{
    RollResult roll = [RollManager resultOfRollString:[NSString stringWithFormat:@"1d20%@", textNode.attributedText.string]];
    [RollManager showAlertForRollResult:roll];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *horizontalSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                spacing:5.0f
                                                                         justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                             alignItems:ASStackLayoutAlignItemsCenter
                                                                               children:@[
                                                                                          self.titleNode,
                                                                                          self.scoreNode
                                                                                          ]];
    
    ASStackLayoutSpec *verticalSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                spacing:0.0f
                                                                         justifyContent:ASStackLayoutJustifyContentStart
                                                                             alignItems:ASStackLayoutAlignItemsStart
                                                                               children:@[
                                                                                          horizontalSpec,
                                                                                          self.modifierNode
                                                                                          ]];
    
    return verticalSpec;

}

@end
