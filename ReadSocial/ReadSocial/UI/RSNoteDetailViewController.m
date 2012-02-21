//
//  RSNoteDetailViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/28/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteDetailViewController.h"
#import "RSNote+Core.h"
#import "RSResponse+Core.h"
#import "RSParagraph+Core.h"
#import "RSResponseHandler.h"
#import "DataContext.h"
#import "RSNavigationController.h"
#import "RSNoteResponsesRequest.h"
#import "RSUser+Core.h"
#import "RSDateFormat.h"
#import "RSTableViewCell.h"

@implementation RSNoteDetailViewController
@synthesize note=_note;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithNote:(RSNote *)note
{
    self = [super init];
    if (self)
    {
        self.note = note;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// This method will be triggered when the data context detects a change
- (void) reloadResponses
{
    // TODO: This method is getting triggered twice upon opening the view--when new users are updated and when the responses are updated.
    NSLog(@"Updating table with new responses.");
    // Reload the references stored in the view and update the table
    responses = [RSResponseHandler responsesForNote:_note];
    [self.tableView reloadData];
}

- (void) presentResponseComposer
{
    // Create the composer
    RSComposeResponseViewController *responseComposer = [[RSComposeResponseViewController alloc] initWithNote:self.note];
    responseComposer.delegate = self;
    
    [self.navigationController presentModalViewController:[RSNavigationController wrapViewController:responseComposer withInputEnabled:YES] animated:YES];
}

# pragma mark - Response Composer Delegate methods
- (void) didFinishComposingResponse:(RSResponse *)response withResult:(NSInteger)result error:(NSError *)error
{
    NSLog(@"Finished compositing response with result: %d", result);
    
    // Only close the modal view if the note was submitted succesfully, or if the user cancelled it
    // Do not cancel the note if an error occurred.
    if (result==RSResponseCompositionSucceeded || result==RSResponseCompositionCancelled)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) onOpenLink
{
    NSLog(@"Open link: %@", self.note.link);
    NSURL *url = [NSURL URLWithString:self.note.link];
    if (![url scheme])
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.note.link]];
    }
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void) resizeLabelToFitContent: (UILabel *)label
{
    CGSize contentSize = [label.text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
    CGRect contentFrame = label.frame;
    contentFrame.size = contentSize;
    label.frame = contentFrame;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Note";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(presentResponseComposer)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    //containerView.backgroundColor = [UIColor blueColor];
    
    NSString *content = [_note.highlightedText length]>0 ? _note.highlightedText : _note.paragraph.normalized;

    UILabel *paragraphLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 100)];
    paragraphLabel.numberOfLines = 0;
    paragraphLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeMiddleTruncation;
    paragraphLabel.font = [UIFont fontWithName:@"Baskerville" size:14];
    paragraphLabel.textColor = [UIColor darkGrayColor];
    paragraphLabel.text = content;
    
    // Resize the label to fit the content
    CGSize contentSize = [content sizeWithFont:paragraphLabel.font constrainedToSize:paragraphLabel.frame.size lineBreakMode:paragraphLabel.lineBreakMode];
    CGRect contentFrame = paragraphLabel.frame;
    contentFrame.size = contentSize;
    paragraphLabel.frame = contentFrame;
    
    // Find the bottom of the content frame
    CGFloat bottom = contentFrame.origin.y + contentFrame.size.height;
    
    // Add a separator line
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
    separator.center = CGPointMake(150, bottom + 10);
    
    // Create a note view
    UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(10, bottom+20, contentFrame.size.width, 400)];
    
    UIImageView *uImg = [[UIImageView alloc] initWithImage:self.note.user.image];
    [uImg sizeThatFits:CGSizeMake(50, 50)];
    [noteView addSubview:uImg];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 220, 100)];
    noteLabel.numberOfLines = 0;
    noteLabel.font = [UIFont fontWithName:@"Baskerville" size:16];
    noteLabel.text = self.note.body;
    
    // Resize the label to fit the content
    [self resizeLabelToFitContent:noteLabel];
    
    UILazyImageView *imageView;
    if (self.note.imageURL)
    {
        imageView = [[UILazyImageView alloc] initWithFrame:CGRectMake(60, 0, 220, 220)];
        [imageView loadWithURL:[NSURL URLWithString:self.note.imageURL]];
        [noteView addSubview:imageView];
        
        noteLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        noteLabel.textColor = [UIColor whiteColor];
        noteLabel.frame = CGRectMake(60, 0, 220, noteLabel.frame.size.height);
        noteLabel.textAlignment = UITextAlignmentCenter;
    }
    
    [noteView addSubview:noteLabel];
    
    UIButton *link;
    if (self.note.link)
    {
        link = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [link setTitle:self.note.link forState:UIControlStateNormal];
        [link addTarget:self action:@selector(onOpenLink) forControlEvents:UIControlEventTouchUpInside];
        [noteView addSubview:link];
        link.frame = CGRectMake(60, noteLabel.frame.size.height+5, 220, 35);
    }
    
    // Resize the note view
    bottom = MAX(uImg.frame.size.height, noteLabel.frame.size.height);
    if (imageView)
    {
        bottom = MAX(bottom, imageView.frame.size.height);
    }
    if (link)
    {
        bottom = MAX(bottom, link.frame.origin.y + link.frame.size.height);
    }
    contentFrame = noteView.frame;
    contentFrame.size.height = bottom;
    noteView.frame = contentFrame;
    
    [containerView addSubview:paragraphLabel];
    [containerView addSubview:separator];
    [containerView addSubview:noteView];
    
    // Resize the container view
    bottom = noteView.frame.origin.y + noteView.frame.size.height + 10;
    contentFrame = containerView.frame;
    contentFrame.size.height = bottom;
    containerView.frame = contentFrame;
    
    self.tableView.tableHeaderView = containerView;
    
    // Listen for the data context to change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadResponses) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    self.contentSizeForViewInPopover = CGSizeMake(300.0, 300.0);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Get the responses for the note sorted by timestamp descending
    // This is what the data for the table is based on
    responses = [RSResponseHandler responsesForNote:self.note];
    
    // Request an update from the API
    [RSNoteResponsesRequest responsesForNote:self.note withDelegate:self];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Stop listening for the data context to chnage
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [responses count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSResponse *response = [responses objectAtIndex:indexPath.row];
    CGSize textsize = [response.body sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(225, 500) lineBreakMode:UILineBreakModeWordWrap];
    return textsize.height + 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    RSResponse *response = [responses objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Set the user image
    cell.imageView.image = response.user.image;
    [cell.imageView sizeThatFits:CGSizeMake(50, 50)];
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = response.body;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", response.user.name, [RSDateFormat stringFromDate:response.timestamp]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

}*/

#pragma mark - RSAPIRequest Delegate Methods
- (void) didStartRequest:(RSAPIRequest *)request
{
    
}
- (void) requestDidSucceed:(RSAPIRequest *)request
{
    NSLog(@"Responses updated.");
    
}

- (void) requestDidFail:(RSAPIRequest *)request withError:(NSError *)error
{
    NSLog(@"Responses could not be updated: %@", error);
}

@end
