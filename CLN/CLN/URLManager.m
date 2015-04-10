//
//  URLManager.m
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "URLManager.h"

@implementation URLManager

+ (NSString *)apiURL {
    return @"http://23.23.128.233:8080/api/geo/%@/%@/%@";
}

+ (NSString *)baseImagesURL {
    return @"http://club.lanacion.com.ar/imagenes/";
}

@end
