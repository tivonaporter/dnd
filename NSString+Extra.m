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

- (NSAttributedString *)stringWithPrimaryTitleTextStyle
{
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:22.0f weight:UIFontWeightHeavy],
                                 NSForegroundColorAttributeName: [UIColor blackColor]
                                 };
    return [[NSAttributedString alloc] initWithString:self attributes:attributes];
}

- (NSAttributedString *)stringWithSecondaryTitleTextStyle
{
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:16.0f weight:UIFontWeightHeavy],
                                 NSForegroundColorAttributeName: [UIColor blackColor]
                                 };
    return [[NSAttributedString alloc] initWithString:self attributes:attributes];
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

+ (NSString *)modifierStringForAbilityScore:(NSNumber *)score
{
    NSInteger modifier = (NSInteger)floorf([score floatValue] / 2 - 5);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"+0"];
    [formatter setNegativeFormat:@"-0"];
    return [formatter stringFromNumber:@(modifier)];
}

@end
