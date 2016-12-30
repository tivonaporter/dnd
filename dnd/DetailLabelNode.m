//
//  DetailLabelNode.m
//  dnd
//
//  Created by Devon Tivona on 11/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "DetailLabelNode.h"
#import "NSString+Extra.h"
#import "ASTextNode+Extra.h"

@interface DetailLabelNode ()

@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *valueNode;

@end

@implementation DetailLabelNode

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    
    self.automaticallyManagesSubnodes = YES;
    self.titleNode = [[ASTextNode alloc] init];
    self.valueNode = [[ASTextNode alloc] init];
    self.alignment = NSTextAlignmentLeft;
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleNode.attributedText = [title stringWithTextStyle:UIFontTextStyleCaption2];
}

- (void)setValue:(NSString *)value
{
    _value = value;
    self.valueNode = [ASTextNode linkedTextNodeWithAttributedString:[value stringWithTextStyle:UIFontTextStyleHeadline]];
    [self setNeedsLayout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutAlignItems alignItems;
    switch (self.alignment) {
        case NSTextAlignmentRight:
            alignItems = ASStackLayoutAlignItemsEnd;
            break;
        case NSTextAlignmentLeft:
        default:
            alignItems = ASStackLayoutAlignItemsStart;
            break;
    }
    
    NSMutableArray *children = [[NSMutableArray alloc] init];
    if (self.titleNode) [children addObject:self.titleNode];
    if (self.valueNode) [children addObject:self.valueNode];
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:0.0f
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:alignItems
                                                                          children:children];
    return stackSpec;
}

@end
