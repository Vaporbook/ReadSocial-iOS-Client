//
//  RSDateFormat.h
//  ReadSocial
//
//  Formats a date correctly.
//
//  Created by Daniel Pfeiffer on 2/19/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSDateFormat : NSObject

+ (NSString *) stringFromDate: (NSDate *)timestamp;

@end
