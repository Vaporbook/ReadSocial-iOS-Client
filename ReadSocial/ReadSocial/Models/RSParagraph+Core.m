//
//  RSParagraph+Core.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/24/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSParagraph+Core.h"
#import "NSString+RSParagraph.h"
#import "DataContext.h"

@implementation RSParagraph (Core)

// Caller is responsbile for saving context
+ (RSParagraph *) createParagraphInDefaultContextForString: (NSString *)raw
{
    NSString *par_hash = [raw normalizeAndHash];
    RSParagraph *paragraph = [RSParagraph paragraphFromHash:par_hash];
    
    // Create the paragraph if it doesn't exist
    if (!paragraph)
    {
        paragraph = (RSParagraph *)[NSEntityDescription insertNewObjectForEntityForName:@"RSParagraph" inManagedObjectContext:[DataContext defaultContext]];
        paragraph.raw = raw;
        paragraph.par_hash = par_hash;
    }
    
    return paragraph;
}

// Gets the paragraph from the store
+ (RSParagraph *) paragraphFromHash: (NSString *) hash
{
    // Retrieves the managed object context from the app delegate
    NSManagedObjectContext *defaultContext = [DataContext defaultContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RSParagraph" inManagedObjectContext:defaultContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"par_hash==%@",hash]];
    
    NSArray *result = [defaultContext executeFetchRequest:fetchRequest error:nil];
    
    // Check to see if any were found
    if ([result count]==0)
    {
        return nil;
    }
    
    // There should only be one result
    return (RSParagraph *)[result objectAtIndex:0];
}

@end
