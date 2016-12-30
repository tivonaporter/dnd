//
//  NSString+Extra.m
//  dnd
//
//  Created by Devon Tivona on 11/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "NSString+Extra.h"

@implementation NSString (Extra)

- (NSAttributedString *)stringWithBodyTextStyle
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = 8.0f;
    return [self stringWithTextStyle:UIFontTextStyleBody paragraphStyle:style];
}

- (NSAttributedString *)stringWithTextStyle:(UIFontTextStyle)textStyle
{
    return [self stringWithTextStyle:textStyle paragraphStyle:nil];
}

- (NSAttributedString *)stringWithTextStyle:(UIFontTextStyle)textStyle paragraphStyle:(NSParagraphStyle *)paragraphStyle
{
    NSMutableDictionary *attributes = [@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:textStyle] } mutableCopy];
    if (paragraphStyle) attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    return [[NSAttributedString alloc] initWithString:self attributes:attributes];
}

@end
