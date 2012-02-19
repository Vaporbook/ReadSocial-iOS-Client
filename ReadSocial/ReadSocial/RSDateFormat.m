//
//  RSDateFormat.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/19/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSDateFormat.h"

@implementation RSDateFormat

+ (NSString *) stringFromDate: (NSDate *)timestamp
{
    NSTimeInterval ago = -[timestamp timeIntervalSinceNow];
    
    if (ago <= 60)          // within the last minute
    {
        return @"just now";
    }
    else if (ago <= 180)    // within the last 3 minutes
    {
        return @"a few moments ago";
    }
    else if (ago <= 3600)   // within the last hour
    {
        return [NSString stringWithFormat:@"%.0f minutes ago", (ago/60.0)];
    }
    else if (ago <= 86400)  // within the last day
    {
        return [NSString stringWithFormat:@"%.0f hour%@ ago", (ago/60.0/60.0), ago>5400.0 ? @"s" : @""];
    }
    else if (ago <= 604800) // within the last week
    {
        return [NSString stringWithFormat:@"%.0f day%@ ago", (ago/60.0/60.0/24.0), ago>129600.0 ? @"s" : @""];
    }
    else
    {
        NSDateFormatter *f = [NSDateFormatter new];
        f.dateFormat = @"MMM, d, YYYY";
        return [f stringFromDate:timestamp];
    }
}

@end
