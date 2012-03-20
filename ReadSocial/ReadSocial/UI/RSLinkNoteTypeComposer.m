//
//  RSLinkNoteTypeComposer.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/20/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSLinkNoteTypeComposer.h"
#import "UIPlaceholderTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface RSLinkNoteTypeComposer ()
- (NSURL *) getNormalizedURL:(NSString *)urlString;
- (BOOL) isValidLink:(NSString *)urlString;
@end

@implementation RSLinkNoteTypeComposer
@synthesize link, linkDescription, rootComposerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSURL *) getNormalizedURL:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (![url scheme])
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlString]];
    }
    
    return url;
}

- (BOOL) isValidLink:(NSString *)urlString
{
    NSURL *url = [self getNormalizedURL:urlString];
    
    if (!url.host)
    {
        return NO;
    }
    
    // Verify that this is a valid host
    NSArray *hostComps = [url.host componentsSeparatedByString:@"."];
    
    // Verify that there are atleast two components
    if ([hostComps count]<2)
    {
        return NO;
    }
    
    // Each component must be atleast one character long
    for (NSString *hostComponent in hostComps) 
    {
        if (hostComponent.length<1)
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - RSNoteTypeComposer Methods
- (id) initWithRootComposerController: (RSComposeNoteViewController *) composerController
{
    self = [super init];
    if (self)
    {
        rootComposerController = composerController;
    }
    
    return self;
}
+ (id) composerWithRootComposerController: (RSComposeNoteViewController *)rootComposerController
{
    RSLinkNoteTypeComposer *composer = [[RSLinkNoteTypeComposer alloc] initWithRootComposerController:rootComposerController];
    return composer;
}
- (NSDictionary *) prepareRequestArguments
{
    // Normalize link
    NSURL *url = [self getNormalizedURL:link.text];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [url absoluteString],   @"note_link",
            linkDescription.text,   @"note_body", 
            @"link",                @"mtype",
            nil];
}

- (BOOL) shouldEnableSubmitButton
{
    return [self isValidLink:link.text];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    link.delegate = self;
    
    // Add a border to the link description
    linkDescription.layer.cornerRadius = 5.0f;
    linkDescription.delegate = self;
    linkDescription.placeholder = @"Tell us about the link...";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - UITextField delegate methods
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Determine what the new value of the text field is going to be
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"Link: %@", newValue);
    
    if ([self isValidLink:newValue])
    {
        [rootComposerController enableSubmitButton];
    }
    else
    {
        [rootComposerController disableSubmitButton];
    }
    
    return YES;
}

@end
