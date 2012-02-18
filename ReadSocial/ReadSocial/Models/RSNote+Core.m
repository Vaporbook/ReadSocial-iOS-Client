//
//  RSNote+Core.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNote+Core.h"
#import "RSParagraph+Core.h"
#import "RSUser+Core.h"
#import "DataContext.h"
#import "RSUserHandler.h"

NSString* const kNoteId             = @"_id";
NSString* const kNoteBody           = @"body";
NSString* const kNoteLink           = @"link";
NSString* const kNoteCreated        = @"crstamp";
NSString* const kNoteParagraphHash  = @"par_hash";

@implementation RSNote (Core)

+ (RSNote *) noteFromDictionary: (NSDictionary *)args
{
    // Creates a new managed object
    RSNote *note    = (RSNote *)[NSEntityDescription insertNewObjectForEntityForName:@"RSNote" inManagedObjectContext:[DataContext defaultContext]];
    note.id         = [args valueForKey:kNoteId];
    
    [note updateNoteWithDictionary:args];
    
    return note;
}

- (void) updateNoteWithDictionary: (NSDictionary *)args
{
    // Set note values
    self.body       = [args valueForKey:kNoteBody];
    self.link       = [NSString stringWithFormat:@"%@", [args valueForKey:kNoteLink]];
    self.timestamp  = [NSDate dateWithTimeIntervalSince1970:([[args valueForKey:kNoteCreated] floatValue]/1000)];
    self.paragraph  = [RSParagraph paragraphFromHash:[args valueForKey:kNoteParagraphHash]];
    self.user       = [RSUserHandler userForID:[args valueForKey:kUserId]];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"%@ (submitted on %@)", self.body, self.timestamp];
}

@end
