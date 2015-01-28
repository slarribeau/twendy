//
//  RegionModel.h
//  twendy
//
//  Created by Macadamian on 1/22/15.
//  Copyright (c) 2015 Larribeau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"


@interface RegionModel : NSObject
+(NSInteger)count;
+(Region*)get:(NSUInteger)index;
+(void)reset;
+(void)sort;


@end
