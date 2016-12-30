//
//  ASStackLayoutSpec+Tokyo.m
//  Tokyo
//
//  Created by Devon Tivona on 12/8/16.
//  Copyright © 2016 Tivona & Haug. All rights reserved.
//

#import "ASStackLayoutSpec+Tokyo.h"
#import "DetailLabelNode.h"

@implementation ASStackLayoutSpec (Tokyo)

+ (ASStackLayoutSpec *)horizontalSpecWithChildren:(NSArray *)children
{
    ASStackLayoutSpec *spec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                      spacing:10.0f
                                                               justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                   alignItems:ASStackLayoutAlignItemsCenter
                                                                     children:[children copy]];
    id lastObject = [children lastObject];
    if (lastObject && [lastObject isKindOfClass:[DetailLabelNode class]]) {
        DetailLabelNode *node = lastObject;
        node.alignment = (children.count == 1) ? NSTextAlignmentLeft : NSTextAlignmentRight;
    }

    spec.style.flexGrow = YES;
    spec.style.flexShrink = YES;
    return spec;
}

+ (instancetype)gridSpecWithChildren:(NSArray *)children width:(CGFloat)width
{
    CGFloat spacing = 10.0f;
    NSMutableArray *specs = [[NSMutableArray alloc] init];
    NSMutableArray *currentChildren = [[NSMutableArray alloc] init];
    CGFloat runningWidth = 0.0f;
    for (ASDisplayNode *child in children) {
        child.style.flexShrink = YES;
        CGSize size = [child layoutThatFits:ASSizeRangeMake(CGSizeZero, CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX))].size;
        CGFloat currentWidth = size.width + spacing;
        runningWidth += currentWidth;
        
        if (runningWidth >= width) {
            if (currentChildren.count) {
                [specs addObject:[self horizontalSpecWithChildren:currentChildren]];
                currentChildren = [[NSMutableArray alloc] init];
                [currentChildren addObject:child];
                runningWidth = size.width + spacing;
            } else {
                [currentChildren addObject:child];
                [specs addObject:[self horizontalSpecWithChildren:currentChildren]];
                currentChildren = [[NSMutableArray alloc] init];
                runningWidth = 0.0f;
            }
        } else {
            [currentChildren addObject:child];
        }
    }
    if (currentChildren.count) [specs addObject:[self horizontalSpecWithChildren:currentChildren]];
    ASStackLayoutSpec *spec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                      spacing:10.0f
                                                               justifyContent:ASStackLayoutJustifyContentStart
                                                                   alignItems:ASStackLayoutAlignItemsStretch
                                                                     children:specs];
    spec.style.flexGrow = YES;
    spec.style.flexShrink = YES;
    return spec;
}

@end
