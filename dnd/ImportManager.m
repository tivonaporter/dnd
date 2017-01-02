//
//  ImportManager.m
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "ImportManager.h"
#import "Spell.h"
#import "Item.h"
#import "Monster.h"
#import "CharacterClass.h"
#import "Trait.h"
#import "Action.h"
#import <Realm/Realm.h>
#import <Ono/Ono.h>

@implementation ImportManager


+ (void)import
{
    NSArray *files = @[
                       @"Classes",
                       @"Curse of Strahd Bestiary 1.1.0",
                       @"Hoard of the Dragon Queen Bestiary 1.2.2",
                       @"Monster Manual Bestiary 2.5.0",
                       @"Out of the Abyss 1.3.0",
                       @"Phandelver Bestiary 1.2.1",
                       @"Player Bestiary 2.4.0",
                       @"Princes of the Apocalypse Bestiary 1.2.1",
                       @"Storm King's Thunder Bestiary 1.0.0",
                       @"The Rise of Tiamat Bestiary 1.2.1",
                       @"PHB Spells 3.8.1",
                       @"EE Spells 2.6",
                       @"Modern Spells 1.1",
                       @"SCAG Spells 1.2",
                       @"Futuristic Items 1.2",
                       @"Magic Items 5.1",
                       @"Modern Items 1.2",
                       @"Mundane Items 2.7.0",
                       @"Renaissance Items 1.3",
                       @"Valuable Items 1.2.0"
                       ];
    for (NSString *file in files) {
        [self importFile:file];
    }
}

+ (void)importFile:(NSString *)file
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:&error];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    // Items
    [document enumerateElementsWithCSS:@"item" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        __block NSString *text;
        [element enumerateElementsWithCSS:@"text" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            NSString *newText = [[element stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (newText && ![newText isEqualToString:@""]) {
                text = (text) ? [text stringByAppendingFormat:@"\n%@", newText] : newText;
            }
        }];
        if (text) [data setObject:text forKey:@"text"];
        
        __block NSString *modifier;
        [element enumerateElementsWithCSS:@"modifier" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            modifier = (modifier) ? [modifier stringByAppendingFormat:@", %@", [element stringValue]] : [element stringValue];
        }];
        if (modifier) [data setObject:modifier forKey:@"modifier"];
        
        NSString *damage = [[element firstChildWithTag:@"dmg1"] stringValue];
        NSString *secondaryDamange = [[element firstChildWithTag:@"dmg2"] stringValue];
        if (secondaryDamange && ![secondaryDamange isEqualToString:@""]) {
            damage = [damage stringByAppendingFormat:@" (%@)", secondaryDamange];
        }
        if (damage) [data setObject:damage forKey:@"damage"];
        
        NSString *name = [[element firstChildWithTag:@"name"] stringValue];
        if (name) [data setObject:name forKey:@"name"];
        
        NSString *type = [[element firstChildWithTag:@"type"] stringValue];
        if (type) [data setObject:type forKey:@"type"];
        
        NSString *weight = [[element firstChildWithTag:@"weight"] stringValue];
        if (weight) [data setObject:weight forKey:@"weight"];
        
        NSString *strength = [[element firstChildWithTag:@"strength"] stringValue];
        if (strength) [data setObject:strength forKey:@"strength"];
        
        NSString *AC = [[element firstChildWithTag:@"ac"] stringValue];
        if (AC) [data setObject:AC forKey:@"AC"];
        
        NSString *damageType = [[element firstChildWithTag:@"dmgType"] stringValue];
        if (damageType) [data setObject:damageType forKey:@"damageType"];
        
        NSString *property = [[element firstChildWithTag:@"property"] stringValue];
        if (property) [data setObject:property forKey:@"property"];
        
        NSString *range = [[element firstChildWithTag:@"range"] stringValue];
        if (range) [data setObject:range forKey:@"range"];
        
        NSString *stealth = [[element firstChildWithTag:@"stealth"] stringValue];
        if (stealth) [data setObject:stealth forKey:@"stealth"];
        
        [Item createOrUpdateInRealm:realm withValue:data];
    }];
    
    // Spells
    [document enumerateElementsWithCSS:@"spell" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        __block NSString *text;
        [element enumerateElementsWithCSS:@"text" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            NSString *newText = [[element stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (newText && ![newText isEqualToString:@""]) {
                text = (text) ? [text stringByAppendingFormat:@"\n%@", newText] : newText;
            }
        }];
        
        NSMutableDictionary *data = [@{
                               @"name" : [[element firstChildWithTag:@"name"] stringValue],
                               @"level" : [[element firstChildWithTag:@"level"] stringValue],
                               @"text" : text
                               } mutableCopy];
        
        NSString *school = [[element firstChildWithTag:@"school"] stringValue];
        if (school) [data setObject:school forKey:@"school"];
        
        NSString *time = [[element firstChildWithTag:@"time"] stringValue];
        if (time) [data setObject:time forKey:@"time"];
        
        NSString *range = [[element firstChildWithTag:@"range"] stringValue];
        if (range) [data setObject:range forKey:@"range"];
        
        NSString *components = [[element firstChildWithTag:@"components"] stringValue];
        if (components) [data setObject:components forKey:@"compenents"];
        
        NSString *duration = [[element firstChildWithTag:@"duration"] stringValue];
        if (duration) [data setObject:duration forKey:@"duration"];
        
        NSString *classes = [[element firstChildWithTag:@"classes"] stringValue];
        if (classes) [data setObject:classes forKey:@"classes"];
        
        [Spell createOrUpdateInRealm:realm withValue:data];
    }];
    
    // Monsters
    [document enumerateElementsWithCSS:@"monster" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSString *monsterName = [[element firstChildWithTag:@"name"] stringValue];
        NSString *cr = [[element firstChildWithTag:@"cr"] stringValue];
        NSArray *components = [cr componentsSeparatedByString:@"/"];
        CGFloat challengeRating;
        if (components.count > 1) challengeRating = [components[0] floatValue] / [components[1] floatValue];
        else challengeRating = [components[0] floatValue];
        
        NSMutableDictionary *data = [@{
                                       @"name" : monsterName,
                                       @"size" : [[element firstChildWithTag:@"size"] stringValue],
                                       @"type" : [[element firstChildWithTag:@"type"] stringValue],
                                       @"alignment" : [[element firstChildWithTag:@"alignment"] stringValue],
                                       @"AC" : [[element firstChildWithTag:@"ac"] stringValue],
                                       @"HP" : [[element firstChildWithTag:@"hp"] stringValue],
                                       @"speed" : [[element firstChildWithTag:@"speed"] stringValue],
                                       @"challengeRating" : @(challengeRating),
                                       @"strength" : [[element firstChildWithTag:@"str"] numberValue],
                                       @"dexterity" : [[element firstChildWithTag:@"dex"] numberValue],
                                       @"constitution" : [[element firstChildWithTag:@"con"] numberValue],
                                       @"intelligence" : [[element firstChildWithTag:@"int"] numberValue],
                                       @"wisdom" : [[element firstChildWithTag:@"wis"] numberValue],
                                       @"charisma" : [[element firstChildWithTag:@"cha"] numberValue],
                                       @"passiveWisdom" : [[element firstChildWithTag:@"passive"] numberValue]
                                       } mutableCopy];
        
        NSString *skill = [[element firstChildWithTag:@"skill"] stringValue];
        if (skill) [data setObject:skill forKey:@"skill"];
        
        NSString *resist = [[element firstChildWithTag:@"resist"] stringValue];
        if (resist) [data setObject:resist forKey:@"resist"];
        
        NSString *vulnerable = [[element firstChildWithTag:@"vulnerable"] stringValue];
        if (vulnerable) [data setObject:vulnerable forKey:@"vulnerable"];
        
        NSString *immune = [[element firstChildWithTag:@"immune"] stringValue];
        if (immune) [data setObject:immune forKey:@"immune"];
        
        NSString *conditionImmune = [[element firstChildWithTag:@"conditionImmune"] stringValue];
        if (conditionImmune) [data setObject:conditionImmune forKey:@"conditionImmune"];
        
        NSString *senses = [[element firstChildWithTag:@"senses"] stringValue];
        if (senses) [data setObject:senses forKey:@"senses"];
        
        NSString *languages = [[element firstChildWithTag:@"languages"] stringValue];
        if (languages) [data setObject:languages forKey:@"languages"];
        
        NSString *spells = [[element firstChildWithTag:@"spells"] stringValue];
        if (spells) [data setObject:spells forKey:@"spells"];
        
        Monster *monster = [Monster createOrUpdateInRealm:realm withValue:data];
        [monster.traits removeAllObjects];
        [monster.actions removeAllObjects];
        
        [element enumerateElementsWithCSS:@"action" usingBlock:^(ONOXMLElement *actionElement, NSUInteger idx, BOOL *stop) {
            __block NSString *text;
            [actionElement enumerateElementsWithCSS:@"text" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                NSString *newText = [[element stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (newText && ![newText isEqualToString:@""]) {
                    text = (text) ? [text stringByAppendingFormat:@"\n%@", newText] : newText;
                }
            }];
            
            NSString *actionName = [[actionElement firstChildWithTag:@"name"] stringValue];
            NSMutableDictionary *actionData = [@{
                                                 @"name" : actionName,
                                                 @"identifier" : [NSString stringWithFormat:@"%@ - %@", monsterName, actionName],
                                                 @"text": text
                                                 } mutableCopy];
            
            NSString *attack = [[actionElement firstChildWithTag:@"attack"] stringValue];
            if (attack) [actionData setObject:attack forKey:@"attack"];
            
            Action *action = [Action createOrUpdateInRealm:realm withValue:actionData];
            [monster.actions addObject:action];
        }];
        
        [element enumerateElementsWithCSS:@"trait" usingBlock:^(ONOXMLElement *actionElement, NSUInteger idx, BOOL *stop) {
            __block NSString *text;
            [actionElement enumerateElementsWithCSS:@"text" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                NSString *newText = [[element stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (newText && ![newText isEqualToString:@""]) {
                    text = (text) ? [text stringByAppendingFormat:@"\n%@", newText] : newText;
                }
            }];
            
            NSString *actionName = [[actionElement firstChildWithTag:@"name"] stringValue];
            NSDictionary *actionData = @{
                                         @"name" : actionName,
                                         @"identifier" : [NSString stringWithFormat:@"%@ - %@", monsterName, actionName],
                                         @"text": text
                                         };
            Trait *trait = [Trait createOrUpdateInRealm:realm withValue:actionData];
            [monster.traits addObject:trait];
        }];
    }];

    // Classes
    [document enumerateElementsWithCSS:@"class" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *data = [@{
                               @"name" : [[element firstChildWithTag:@"name"] stringValue],
                               @"hitDie" : [[element firstChildWithTag:@"hd"] numberValue],
                               @"proficiency" : [[element firstChildWithTag:@"proficiency"] stringValue]
                               } mutableCopy];
        
        NSString *spellAbility = [[element firstChildWithTag:@"spellAbility"] stringValue];
        if (spellAbility) [data setObject:spellAbility forKey:@"spellAbility"];
        
        CharacterClass *characterClass = [CharacterClass createOrUpdateInRealm:realm withValue:data];
        [characterClass.features removeAllObjects];
        
        [element enumerateElementsWithCSS:@"autolevel" usingBlock:^(ONOXMLElement *levelElement, NSUInteger idx, BOOL *stop) {
            [levelElement enumerateElementsWithCSS:@"feature" usingBlock:^(ONOXMLElement *featureElement, NSUInteger idx, BOOL *stop) {
                __block NSString *text;
                [featureElement enumerateElementsWithCSS:@"text" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                    NSString *newText = [[element stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (newText && ![newText isEqualToString:@""]) {
                        text = (text) ? [text stringByAppendingFormat:@"\n%@", newText] : newText;
                    }
                }];
                
                NSString *featureName = [[featureElement firstChildWithTag:@"name"] stringValue];
                Feature *feature = [Feature createOrUpdateInRealm:realm withValue:@{
                                                                                    @"name" : featureName,
                                                                                    @"identifier" : [NSString stringWithFormat:@"%@ - %@", characterClass.name, featureName],
                                                                                    @"text" : text,
                                                                                    @"optional" : @(!![featureElement valueForAttribute:@"optional"]),
                                                                                    @"level" : @([[levelElement valueForAttribute:@"level"] integerValue])
                                                                                    }];
                [characterClass.features addObject:feature];
            }];
        }];
    }];
    
    [realm commitWriteTransaction];
}

@end
