//
// Created by Adrian Castillejos on 5/24/14.
// Copyright (c) 2014 Adrian Castillejos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSLayoutConstraint+LinearEquationFormat.h"


@interface ZIOLayoutConstraintManager : NSObject

@property(nonatomic, strong) NSString            *string;
@property(nonatomic, strong) NSMutableArray      *constraints;
@property(nonatomic, strong) NSMutableDictionary *constraintPriorityDict;
@property(nonatomic, strong) NSDictionary        *metricDict;
@property(nonatomic, strong) NSDictionary        *viewDict;

- (instancetype)initWithString:(NSString *)string metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict;

- (instancetype)initWithString:(NSString *)string metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict priorities:(NSDictionary *)priorityDict;

- (NSLayoutConstraint *)constraintWithString:(NSString *)string metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict;

- (NSArray *)constraintsWithStrings:(NSArray *)strings metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict;

@end

@implementation ZIOLayoutConstraintManager

#pragma mark Initialization

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.constraintPriorityDict = [NSMutableDictionary dictionary];
    self.constraints            = [NSMutableArray array];
}

- (void)setMetrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    self.metricDict = metrics;
    self.viewDict   = views;
}

- (instancetype)initWithString:(NSString *)string metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict
{
    return nil;
}

- (instancetype)initWithString:(NSString *)string metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict priorities:(NSDictionary *)priorityDict
{
    return nil;
}


- (NSLayoutConstraint *)constraintWithString:(NSString *)string metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict
{
    NSParameterAssert(string);
    NSParameterAssert(viewDict);

    // check if we have the metric dict and the viewDict


    UIView   *view1, *view2;
    NSNumber *attribute1, *attribute2, *relation, *multiplier, *constant;
    NSString             *name;

    // First we ensure that the string is vaguely properly formatted

    NSTextCheckingResult *leftSide = [self stringContainsOneViewAttributeToSet:string];
    if (leftSide)
    {
        NSString *withRange = [string substringWithRange:leftSide.range];
        view1      = [self view1FromString:withRange];
        attribute1 = [self attribute1FromString:withRange];
    }

    NSTextCheckingResult *rightSide = [self stringContainsRightSide:string];

    return nil;
}


- (NSArray *)constraintsWithStrings:(NSArray *)strings metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict
{
    [self setMetrics:metricDict views:viewDict];
    NSMutableArray *ret = [NSMutableArray array];
    for (NSString  *string in strings)
    {
        [ret addObject:[self constraintWithString:string metrics:metricDict views:viewDict]];
    }
    return ret;
}

#pragma mark Parsing

- (NSTextCheckingResult *)stringContainsOneViewAttributeToSet:(NSString *)string
{
    NSError             *error;
    NSRegularExpression *regex   = [NSRegularExpression regularExpressionWithPattern:@"[\\w]+.[\\w]+\\s*[=|>=|<=]{1}" options:0 error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (matches.count == 1)
    {
        // We can continue because there is exactly one attribute being set in this string.
        return matches.firstObject;
    }
    else
    {
        return nil;
    }
    return nil;
}

/**
* Input string is of format 'viewName.attribute =' (aka [\w]+.[\w]+\s*[=|>=|<=]{1}). From this, we want to extract the view name
* and match it to a view in our viewDict.
*/
- (UIView *)view1FromString:(NSString *)string
{
    NSError             *error;
    NSRegularExpression *regex   = [NSRegularExpression regularExpressionWithPattern:@"[\\w]+\\." options:0 error:&error];
    NSArray             *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (error)
    {
        NSLog(@"Could not parse view from string %@. Error:%@", string, error.localizedDescription);
        NSAssert(NO, @"View could not be parsed");
    }
    if (matches.count == 1)
    {
        NSTextCheckingResult *result  = matches.firstObject;
        NSString             *viewKey = [string substringWithRange:NSMakeRange(result.range.location, result.range.length - 1)];
        UIView               *ret     = self.viewDict[viewKey];
        if (ret)
        {
            return ret;
        }
    }
    return nil;
}

- (NSNumber *)attribute1FromString:(NSString *)string
{
    NSError             *error;
    NSRegularExpression *regex   = [NSRegularExpression regularExpressionWithPattern:@"\\.[\\w]+" options:0 error:&error];
    NSArray             *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (error)
    {
        NSAssert(NO, @"Attribute could not be parsed");
    }
    if (matches.count == 1)
    {
        NSTextCheckingResult *results      = matches.firstObject;
        NSString             *attributeKey = [string substringWithRange:NSMakeRange(results.range.location + 1, results.range.length - 1)];
        NSNumber             *ret          = [ZIOLayoutConstraintManager attributes][attributeKey];
        if (ret)
        {
            return ret;
        }
    }
    return nil;
}

- (NSTextCheckingResult *)stringContainsRightSide:(NSString *)string
{
    return nil;
}

#pragma mark Store-Bought (Pre-Baked?)

+ (NSDictionary *)attributes
{
    return @{@"left"     : @(NSLayoutAttributeLeft),
             @"right"    : @(NSLayoutAttributeRight),
             @"top"      : @(NSLayoutAttributeTop),
             @"bottom"   : @(NSLayoutAttributeBottom),
             @"leading"  : @(NSLayoutAttributeLeading),
             @"trailing" : @(NSLayoutAttributeTrailing),
             @"width"    : @(NSLayoutAttributeWidth),
             @"height"   : @(NSLayoutAttributeHeight),
             @"centerX"  : @(NSLayoutAttributeCenterX),
             @"centerY"  : @(NSLayoutAttributeCenterY),
             @"baseline" : @(NSLayoutAttributeBaseline)
    };
}

+ (NSDictionary *)relations
{
    return @{@"="  : @(NSLayoutRelationEqual),
             @">=" : @(NSLayoutRelationGreaterThanOrEqual),
             @"<=" : @(NSLayoutRelationLessThanOrEqual)
    };
}

@end


@interface NSLayoutConstraint ()


@end


@implementation NSLayoutConstraint (LinearEquationFormat)


+ (NSArray *)constraintsWithLinearEquationFormat:(NSArray *)linearEquations metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict
{
    ZIOLayoutConstraintManager *manager = [[ZIOLayoutConstraintManager alloc] init];
    return [manager constraintsWithStrings:linearEquations metrics:metricDict views:viewDict];
}

+ (NSLayoutConstraint *)constraintWithLinearEquationFormat:(NSString *)linearEquation metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict
{
    ZIOLayoutConstraintManager *manager = [[ZIOLayoutConstraintManager alloc] init];
    return [manager constraintWithString:linearEquation metrics:metricDict views:viewDict];
}

@end

