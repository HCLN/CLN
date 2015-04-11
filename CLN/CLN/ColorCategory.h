//
//  ColorCategory.h
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorCategory : NSObject

+ (UIColor *)colorForCategory:(NSString *)categoryName;
+ (UIImage *)pinForCategory:(NSString *)categoryName;

@end
