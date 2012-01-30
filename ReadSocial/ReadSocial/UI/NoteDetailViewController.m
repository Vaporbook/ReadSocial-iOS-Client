//
//  NoteDetailViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/28/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "RSNote+Core.h"
#import "RSResponse+Core.h"
#import "RSParagraph+Core.h"
#import "RSResponseHandler.h"
#import "DataContext.h"

@implementation NoteDetailViewController
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
    responseComposer = [RSComposeResponseViewController new];
    
    UINavigationController *composer = [[UINavigationController alloc] initWithRootViewController:responseComposer];
    
    composer.modalInPopover = YES;
    composer.modalPresentationStyle = UIModalPresentationCurrentContext;
    responseComposer.delegate = self;
    [self.navigationController presentModalViewController:composer animated:YES];
}

- (void) requestDidSucceed:(id)response
{
    [DataContext save];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

# pragma mark - Note Composer Delegate methods
- (void) didCancelResponseComposition
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void) didSubmitResponseWithString:(NSString *)content
{
    [responseComposer disableSubmitButton];
    [RSCreateNoteResponseRequest createResponse:content forNote:self.note withDelegate:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Note";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(presentResponseComposer)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 140)];
    UILabel *paragraphLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    paragraphLabel.numberOfLines = 0;
    paragraphLabel.text = _note.paragraph.normalized;
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 60)];
    noteLabel.numberOfLines = 0;
    noteLabel.text = _note.body;
    
    [containerView addSubview:paragraphLabel];
    [containerView addSubview:noteLabel];
    
    self.tableView.tableHeaderView = containerView;
    
    // Listen for the data context to change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadResponses) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Get the responses for the note sorted by timestamp descending
    // This is what the data for the table is based on
    responses = [RSResponseHandler responsesForNote:_note];
    
    // Request an update from the API
    [RSResponseHandler updateResponsesForNote:_note];
    
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
    return [responses count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row >= [responses count])
    {
        cell.textLabel.text = @"Load more responses...";
    }
    else
    {
        RSResponse *response = [responses objectAtIndex:indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.textLabel.text = response.body;
        
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
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

@end
