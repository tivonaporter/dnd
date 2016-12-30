//
//  NSString+Extra.h
//  dnd
//
//  Created by Devon Tivona on 11/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extra)

- (NSAttributedString *)stringWithTextStyle:(UIFontTextStyle)textStyle;
- (NSAttributedString *)stringWithBodyTextStyle;

@end
