//
//  ColorCategory.m
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "ColorCategory.h"
#import "HexColor.h"

@implementation ColorCategory

+ (UIColor *)colorForCategory:(NSString *)categoryName {
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CategoryColor" ofType:@"plist"]];
    return [UIColor colorWithHexString:[d objectForKey:categoryName] alpha:1];
}

+ (UIImage *)pinForCategory:(NSString *)categoryName {
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CategoryPin" ofType:@"plist"]];
    NSString *imgName = [NSString stringWithFormat:@"%@.png", [d objectForKey:categoryName]];
    if (imgName)
        return [UIImage imageNamed:imgName];
    return [UIImage imageNamed:@"placeimage.jpg"];
}

@end
