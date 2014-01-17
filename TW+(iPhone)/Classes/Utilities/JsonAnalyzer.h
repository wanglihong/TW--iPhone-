//
//  JsonAnalyzer.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-21.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Brand.h"

#import "Document.h"

@interface JsonAnalyzer : NSObject

+ (void)analyzeAccessInfo:(id)json;
+ (void)analyzeBrand:(id)json;
+ (void)analyzeDocument:(id)json inBrand:(Brand *)brand;

@end
