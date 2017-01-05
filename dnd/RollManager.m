//
//  RollManager.m
//  dnd
//
//  Created by Devon Tivona on 12/27/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MMPopupView/MMAlertView.h>

#import "RollManager.h"

@implementation RollManager

+ (RollResult)resultOfRollString:(NSString *)string
{
    RollResult r = {.result = 0, .bestResult = 0, .worstResult = 0, .averageResult = 0, .quality = RollQualityAverage};
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
    NSArray *rolls = [string componentsSeparatedByCharactersInSet:set];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.length > 0"];
    NSArray *operators = [[string componentsSeparatedByCharactersInSet:[set invertedSet]] filteredArrayUsingPredicate:predicate];
    NSUInteger index = 0;
    
    for (NSString *roll in rolls) {
        NSInteger multiplier = (index == 0 || [operators[index - 1] isEqualToString:@"+"]) ? 1 : -1;
        NSString *trimmedRoll = [roll stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *components = [trimmedRoll componentsSeparatedByString:@"d"];
        if (components.count == 1) {
            // This is a modifier
            NSInteger modifier = [components[0] integerValue];
            r.result += modifier * multiplier;
            r.bestResult += modifier * multiplier;
            r.worstResult += modifier * multiplier;
            r.averageResult += modifier * multiplier;
        } else if (components.count == 2) {
            // This is a roll
            for (NSUInteger index = 0; index < [components[0] integerValue]; index++) {
                NSUInteger dieSize = [components[1] integerValue];
                r.result += (arc4random_uniform((uint32_t)dieSize) + 1) * multiplier;
                r.bestResult += dieSize * multiplier;
                r.worstResult += 1 * multiplier;
                r.averageResult += ((dieSize + 1) / 2) * multiplier;
            }
        }
        index++;
    }
    
    CGFloat percentile = ((CGFloat)(r.result - r.worstResult)) / ((CGFloat)(r.bestResult - r.worstResult));
    if (percentile <= 0.20f) r.quality = RollQualityTerrible;
    else if (percentile <= 0.40f) r.quality = RollQualityBad;
    else if (percentile <= 0.60f) r.quality = RollQualityAverage;
    else if (percentile <= 0.80f) r.quality = RollQualityGood;
    else if (percentile <= 1.00f) r.quality = RollQualityGreat;
    
    return r;
}

+ (void)showAlertForRollResult:(RollResult)roll
{
    NSString *reaction = @"";
    NSString *prefix = @"";
    
    switch (roll.quality) {
        case RollQualityTerrible:
            reaction = @"🖕";
            prefix = @"Bugbears!";
            break;
        case RollQualityBad:
            reaction = @"👎";
            prefix = @"Darn.";
            break;
        case RollQualityAverage:
            reaction = @"👍";
            break;
        case RollQualityGood:
            reaction = @"🙌";
            prefix = @"Yay!";
            break;
        case RollQualityGreat:
            reaction = @"🎉";
            prefix = @"Praise Tymora!";
            break;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ You got %ld.", prefix, (long)roll.result];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideAnimated:YES];
        NSArray *items = @[MMItemMake(reaction, MMItemTypeNormal, nil)];
        MMAlertView *alert = [[MMAlertView alloc] initWithTitle:title detail:nil items:items];
        [alert showWithBlock:nil];
    });
}

@end
