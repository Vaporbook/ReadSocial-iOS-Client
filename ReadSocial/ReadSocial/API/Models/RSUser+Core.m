//
//  RSUser+Core.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/29/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSUser+Core.h"
#import "RSUserImageRequest.h"
#import "DataContext.h"

NSString* const kUserId     =   @"uid";
NSString* const kUserName   =   @"uname";
NSString* const kUserImage  =   @"uimg";
NSString* const kUserDomain =   @"udom";

@implementation RSUser (Core)

- (UIImage *) getImage
{
    // If the image is already downloaded, then just use that
    if (self.imageIsDownloaded)
    {
        imageIsDownloading = NO;
        return [UIImage imageWithData: self.imageData];
    }
    
    // If the image is not downloaded, return a placeholder image
    // and start downloading the image.
    else
    {
        if (!imageIsDownloading)
        {
            [RSUserImageRequest downloadImageForUser:self];
            imageIsDownloading = YES;
        }
        
        return [UIImage imageNamed:@"default_user"];
    }
}

- (BOOL) getImageIsDownloaded
{
    // Checks for the existence of image data and how old it is
    // If the data doesn't exist or the existing data is more than a week old
    // the image is not considered "downloaded"--it should be re-retrieved.
    if (!self.imageData || 
        !self.updated || 
        [[NSDate date] timeIntervalSinceDate:self.updated] > 604800)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (RSUser *) userWithDictionary: (NSDictionary *)args
{
    // Creates a new managed object
    RSUser *user    = (RSUser *)[NSEntityDescription insertNewObjectForEntityForName:@"RSUser" inManagedObjectContext:[DataContext defaultContext]];
    
    user.uid        = [NSString stringWithFormat:@"%@", [args valueForKey:kUserId]];
    user.udom       = [args valueForKey:kUserDomain];
    
    [user updateUserWithDictionary:args];
    NSLog(@"Created user: %@", user.name);
    return user;
}

+ (RSUser *) userWithID:(NSString *)uid andName:(NSString *)name andImageURL:(NSURL *)imageURL forDomain:(NSString *)domain
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    [args setValue:uid forKey:kUserId];
    [args setValue:name forKey:kUserName];
    [args setValue:[imageURL absoluteString] forKey:kUserImage];
    [args setValue:domain forKey:kUserDomain];
    
    return [RSUser userWithDictionary:args];
}

- (BOOL) updateUserWithDictionary: (NSDictionary *)args
{
    self.name       =   [args valueForKey:kUserName];
    
    // Check if the image URL has changed; if it has, then the image needs to be re-downloaded
    if (![[args valueForKey:kUserImage] isEqualToString:self.imageURL])
    {
        NSLog(@"New image!");
        imageIsDownloading = NO;
        self.imageURL   =   [args valueForKey:kUserImage];
        self.imageData  =   nil;
    }
    
    return YES;
}

- (NSDictionary *) dictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setValue:self.uid         forKey:kUserId];
    [data setValue:self.name        forKey:kUserName];
    [data setValue:self.imageURL    forKey:kUserImage];
    [data setValue:self.udom        forKey:kUserDomain];
    
    return [NSDictionary dictionaryWithDictionary:data];
}

@end
