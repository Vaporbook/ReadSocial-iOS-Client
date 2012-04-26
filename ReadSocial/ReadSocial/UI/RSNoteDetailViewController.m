//
//  RSNoteDetailViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/28/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteDetailViewController.h"
#import "RSNavigationController.h"
#import "RSTableViewCell.h"

@interface RSNoteDetailViewController()

- (BOOL) shouldShowLoadMoreRow;
- (void) loadMoreResponses;

@end

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
        loadingNewData = loadMoreRowVisible = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL) shouldShowLoadMoreRow
{
    // The "Load More" row should appear if the response count is higher than the number of responses
    // that are currently loaded on the table
    return [self.note.responseCount integerValue] > [responses count];
}

- (void) loadMoreResponses
{
    NSLog(@"Loading more responses.");
    // Determine the timestamp of the last displayed response
    // and load all responses prior to that date
    RSResponse *lastResponse = [responses lastObject];
    [RSNoteResponsesRequest responsesForNote:self.note before:lastResponse.timestamp withDelegate:self];
}

// This method will be triggered when the data context detects a change
- (void) reloadResponses
{
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
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    //containerView.backgroundColor = [UIColor blueColor];
    
    NSString *content = [_note.highlightedText length]>0 ? _note.highlightedText : _note.paragraph.normalized;

    UILabel *paragraphLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
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
    separator.center = CGPointMake(160, bottom + 10);
    
    // Create a note view
    UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(10, bottom+20, contentFrame.size.width, 400)];
    
    UIImageView *uImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    uImg.image = self.note.user.image;
    uImg.contentMode = UIViewContentModeScaleAspectFit;
    [noteView addSubview:uImg];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 240, 100)];
    noteLabel.numberOfLines = 0;
    noteLabel.font = [UIFont fontWithName:@"Baskerville" size:16];
    noteLabel.text = self.note.body;
    
    // Resize the label to fit the content
    [self resizeLabelToFitContent:noteLabel];
    
    UILazyImageView *imageView;
    if (self.note.imageURL)
    {
        imageView = [[UILazyImageView alloc] initWithFrame:CGRectMake(60, 0, 240, 220)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView loadWithURL:[NSURL URLWithString:self.note.imageURL]];
        [noteView addSubview:imageView];
        
        noteLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        noteLabel.textColor = [UIColor whiteColor];
        noteLabel.frame = CGRectMake(60, 0, 240, noteLabel.frame.size.height);
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
        link.frame = CGRectMake(60, noteLabel.frame.size.height+5, 240, 35);
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
    
    // Get the responses for the note sorted by timestamp descending
    // This is what the data for the table is based on
    responses = [RSResponseHandler responsesForNote:self.note];
    
    // Request an update from the API
    [RSNoteResponsesRequest responsesForNote:self.note withDelegate:self];
    
    // Listen for the data context to change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadResponses) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 300.0);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
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
    if ([self shouldShowLoadMoreRow])
    {
        loadMoreRowVisible = YES;
        loadMoreRowIndex = [responses count]; // The "Load More" row index will be equal to the number of responses
        return [responses count] + 1;
    }
    
    else
    {
        loadMoreRowIndex = -1; // Clear out the reference to an row
        loadMoreRowVisible = NO;
        return [responses count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == loadMoreRowIndex)
    {
        return 60;
    }
    
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
    
    // Check if this is the Load More row
    if (indexPath.row == loadMoreRowIndex)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.imageView.image = nil;
        cell.textLabel.text = @"Load More";
        cell.detailTextLabel.text = @"";
        return cell;
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the user selects the "Load More" row, load more responses
    // But only load more responses if data is not already being loaded
    if (indexPath.row == loadMoreRowIndex && !loadingNewData)
    {
        [self loadMoreResponses];
        
        // Deselect the table row
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

}

#pragma mark - RSAPIRequest Delegate Methods
- (void) didStartRequest:(RSAPIRequest *)request
{
    loadingNewData = YES;
}
- (void) requestDidSucceed:(RSAPIRequest *)request
{
    NSLog(@"Responses updated.");
    loadingNewData = NO;
}

- (void) requestDidFail:(RSAPIRequest *)request withError:(NSError *)error
{
    NSLog(@"Responses could not be updated: %@", error);
    loadingNewData = NO;
}

@end
