//
// Created by Adrian Castillejos on 5/24/14.
// Copyright (c) 2014 Adrian Castillejos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (LinearEquationFormat)

+ (NSArray *)constraintsWithLinearEquationFormat:(NSArray *)linearEquations metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict;

+ (NSLayoutConstraint *)constraintWithLinearEquationFormat:(NSString *)linearEquation metrics:(NSDictionary *)metricDict views:(NSDictionary *)viewDict;

@end