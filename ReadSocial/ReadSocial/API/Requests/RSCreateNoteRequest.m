//
//  RSCreateNoteRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSCreateNoteRequest.h"
#import "RSParagraph+Core.h"
#import "JSONKit.h"
#import "RSNote+Core.h"
#import "ReadSocial.h"
#import "RSPage.h"
#import "NSString+RSParagraph.h"
#import "NSData+RSBase64.h"

@implementation RSCreateNoteRequest
@synthesize paragraph=_paragraph, note;

+ (id) createNoteWithArguments: (NSDictionary *)args forParagarph: (RSParagraph *)paragraph
{
    return [RSCreateNoteRequest createNoteWithArguments:args forParagraph:paragraph withDelegate:nil];
}

+ (id) createNoteWithArguments: (NSDictionary *)args forParagraph: (RSParagraph *)paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSCreateNoteRequest *request = [[RSCreateNoteRequest alloc] initWithArguments:args andParagraph:paragraph];
    request.delegate = delegate;
    [request start];
    return request;
}

- (id) initWithArguments: (NSDictionary *)args andParagraph: (RSParagraph *)paragraph
{
    self = [super init];
    if (self)
    {
        arguments = args;
        _paragraph = paragraph;
    }
    return self;
}

# pragma mark - Utility methods
+ (NSString *) imageURIDataWithImage:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 80);
    return [NSString stringWithFormat:@"data:image/jpeg;base64,%@", [data base64EncodedString]];
}

# pragma mark - RSAPIRequest Overriden Methods
- (RSMutableURLRequest *) createRequest
{
    RSMutableURLRequest *request = [super createRequest];
    
    // Set the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/%@/notes/create", RSAPIURL, networkID, group];
    [request setURL:[NSURL URLWithString:url]];
    
    // Try to get more information from the data source
    NSString *selection = [ReadSocial sharedInstance].currentSelection;
    
    // Set the headers
    NSMutableDictionary *payload = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             networkID,                     @"net_id",
                             group,                         @"group_name",
                             self.paragraph.par_hash,       @"par_hash",
                             selection,                     @"hi_raw",
                             [selection normalize],         @"hi_nrml",
                             [selection normalizeAndHash],  @"hi_hash",
                             nil];
    
    // Append to the payload the arguments received from the constructor
    [payload addEntriesFromDictionary:arguments];
    
    [request setHTTPBody:[payload JSONData]];
    
    // This is a POST request
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (BOOL) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    // Create a new note
    note = [RSNote noteFromDictionary:json];
    
    // Update the note count for the paragraph
    _paragraph.noteCount = [NSNumber numberWithInt:[_paragraph.noteCount intValue]+1];
    
    // Trigger delegate/notification
    [[ReadSocial sharedInstance] userDidComposeNote:note];
    
    return YES;
}

@end
