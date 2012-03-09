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
#import "RSNoteImageRequest.h"

NSString* const kNoteId             = @"_id";
NSString* const kNoteBody           = @"body";
NSString* const kNoteType           = @"mtype";
NSString* const kNoteLink           = @"link";
NSString* const kNoteThumbnail      = @"img_small";
NSString* const kNoteImage          = @"img";
NSString* const kNoteCreated        = @"crstamp";
NSString* const kNoteParagraphHash  = @"par_hash";
NSString* const kHighlightedText    = @"hi_nrml";

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
    self.type           = [args valueForKey:kNoteType];
    self.body           = [args valueForKey:kNoteBody];
    self.link           = [[args valueForKey:kNoteLink] isKindOfClass:[NSString class]] ? [args valueForKey:kNoteLink] : nil;
    self.timestamp      = [NSDate dateWithTimeIntervalSince1970:([[args valueForKey:kNoteCreated] floatValue]/1000.0)];
    self.paragraph      = [RSParagraph paragraphFromHash:[args valueForKey:kNoteParagraphHash]];
    self.highlightedText= [args valueForKey:kHighlightedText];
    self.user           = [RSUserHandler userForID:[args valueForKey:kUserId]];
    self.imageURL       = [[RSNoteImageRequest URLForImageName:[args valueForKey:kNoteImage]] absoluteString];
    self.thumbnailURL   = [[RSNoteImageRequest URLForImageName:[args valueForKey:kNoteThumbnail]] absoluteString];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"%@ (submitted on %@)", self.body, self.timestamp];
}

@end
