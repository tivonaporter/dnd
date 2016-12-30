//
//  ASTextNode+Extra.m
//  dnd
//
//  Created by Devon Tivona on 12/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "ASTextNode+Extra.h"
#import "AppDelegate.h"

@implementation ASTextNode (Extra)

+ (instancetype)linkedTextNodeWithAttributedString:(NSAttributedString *)attributedString
{
    ASTextNode *textNode = [[ASTextNode alloc] init];
    
    if (attributedString) {
        NSString *string = attributedString.string;
        NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((\\d+d{1}\\d+)(( *\\++ *)|))+(((\\d+d{1}\\d+)|\\d)(( *\\++ *)|))*" options:0 error:nil];
        NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        
        NSString *DiceNodeLink = @"DiceNodeLink";
        for (NSTextCheckingResult *result in matches) {
            [mutableAttributedString addAttribute:DiceNodeLink value:[string substringWithRange:result.range] range:result.range];
            [mutableAttributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:result.range];
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:textNode.tintColor range:result.range];
        }
        textNode.linkAttributeNames = @[DiceNodeLink];
        textNode.attributedText = mutableAttributedString;
    }
    
    textNode.delegate = [AppDelegate sharedAppDelegate];
    textNode.userInteractionEnabled = YES;
    return textNode;
}

@end
