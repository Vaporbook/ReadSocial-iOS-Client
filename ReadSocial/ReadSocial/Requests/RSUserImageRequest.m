//
//  RSUserImageRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 3/9/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSUserImageRequest.h"
#import "RSUser+Core.h"

@implementation RSUserImageRequest
@synthesize user=_user;

+ (RSUserImageRequest *) downloadImageForUser:(RSUser *)user
{
    return [RSUserImageRequest downloadImageForUser:user withDelegate:nil];
}
+ (RSUserImageRequest *) downloadImageForUser:(RSUser *)user withDelegate:(id<RSAPIRequestDelegate>)delegate
{
    RSUserImageRequest *request = [[RSUserImageRequest alloc] initWithUser:user];
    request.delegate = delegate;
    [request start];
    return request;
}

- (RSUserImageRequest *) initWithUser:(RSUser *)user
{
    self = [super init];
    
    if (self) 
    {
        self.user = user;
    }
    
    return self;
}

# pragma mark - RSAPIRequest Overriden Methods
- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    assumeJSONResponse = NO;
    
    // Determine the URL
    NSString *url = self.user.imageURL;
    
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (BOOL) handleResponse:(id)data error:(NSError *__autoreleasing *)error
{
    [super handleResponse:data error:error];
    
    if (!data)
    {
        *error = [NSError errorWithDomain:@"User image did not download." code:0 userInfo:nil];
        return NO;
    }
    
    NSLog(@"Image downloaded for %@", self.user.name);
    
    self.user.imageData =   data;
    self.user.updated   =   [NSDate date];
    
    return YES;
}

@end
