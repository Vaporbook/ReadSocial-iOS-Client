//
//  RSResponse+Core.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSResponse+Core.h"
#import "DataContext.h"
#import "RSNoteHandler.h"
#import "RSUser+Core.h"
#import "RSUserHandler.h"

NSString* const kResponseId         = @"_id";
NSString* const kResponseBody       = @"body";
NSString* const kResponseLink       = @"";
NSString* const kResponseCreated    = @"crstamp";
NSString* const kResponseNoteId     = @"note_id";

@implementation RSResponse (Core)

+ (RSResponse *) responseFromDictionary: (NSDictionary *)args
{
    // Creates a new managed object
    RSResponse *response    = (RSResponse *)[NSEntityDescription insertNewObjectForEntityForName:@"RSResponse" inManagedObjectContext:[DataContext defaultContext]];
    response.id             = [args valueForKey:kResponseId];
    
    [response updateResponseWithDictionary:args];
    
    return response;
}

- (void) updateResponseWithDictionary: (NSDictionary *)args
{
    self.body       = [args valueForKey:kResponseBody];
    self.note       = [RSNoteHandler noteForId:[args valueForKey:kResponseNoteId]];
    self.timestamp  = [NSDate dateWithTimeIntervalSince1970:[[args valueForKey:kResponseCreated] floatValue]/1000.0];
    self.user       = [RSUserHandler userForID:[args valueForKey:kUserId]];
}

@end
