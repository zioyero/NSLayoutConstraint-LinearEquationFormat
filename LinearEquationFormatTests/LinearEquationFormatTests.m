//
//  LinearEquationFormatTests.m
//  LinearEquationFormatTests
//
//  Created by Adrian Castillejos on 5/24/14.
//  Copyright (c) 2014 Adrian Castillejos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "NSLayoutConstraint+LinearEquationFormat.h"

@interface LinearEquationFormatTests : XCTestCase

@end

@implementation LinearEquationFormatTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSArray *constraints = [NSLayoutConstraint constraintsWithLinearEquationFormat:@[
            @"view1.top = view2.bottom"
    ]                                                                      metrics:nil views:@{
            @"view1" : [[UIView alloc] init], @"view2" : [[UIView alloc] init]
    }];
    XCTAssert(constraints.count > 0);
}


@end
