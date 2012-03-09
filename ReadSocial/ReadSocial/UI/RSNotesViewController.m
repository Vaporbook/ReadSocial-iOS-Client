//
//  RSNotesViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/28/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNotesViewController.h"
#import "RSNoteDetailViewController.h"
#import "RSGroupViewController.h"
#import "RSNavigationController.h"
#import "ReadSocialAPI.h"
#import "RSDateFormat.h"
#import "RSTableViewCell.h"

@interface RSNotesViewController()
/**
 Determines if there are more notes that are not currently loaded in the view.
 Compares the number of notes on the paragraph with the number of notes loaded in the view.
 
 @return YES if there are more notes; NO if there are no more notes.
 */
- (BOOL) areMoreNotes;

- (void) loadMoreNotes;

- (void) checkForNoComments;
@end

@implementation RSNotesViewController
@synthesize paragraph=_paragraph;

- (void) setParagraph:(RSParagraph *)paragraph
{
    _paragraph = paragraph;
    raw = paragraph.raw;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithParagraph: (RSParagraph*)paragraph
{
    self = [super init];
    if (self)
    {
        self.paragraph = paragraph;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) reloadNotes
{
    // TODO: This method is getting triggered twice upon opening the view--when new users are updated and when the responses are updated.
    notes = [RSNoteHandler notesForParagraph:_paragraph];
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
    [self checkForNoComments];
}

- (void) loadMoreNotes
{
    NSLog(@"Loading more notes");
    // Find the last loaded note
    RSNote *lastNote = [notes lastObject];
    
    // Load notes before the last loaded note
    [RSParagraphNotesRequest notesForParagraph:self.paragraph beforeDate:lastNote.timestamp withDelegate:self];
}

- (void) presentNoteComposer
{
    RSComposeNoteViewController *noteComposer = [[RSComposeNoteViewController alloc] initWithParagraph:self.paragraph];
    noteComposer.delegate = self;
    
    [self.navigationController presentModalViewController:[RSNavigationController wrapViewController:noteComposer withInputEnabled:YES] animated:YES];
}

- (void) changeGroup
{
    RSGroupViewController *groupViewController = [RSGroupViewController new];
    groupViewController.delegate = self;
    
    [self.navigationController presentModalViewController:[RSNavigationController wrapViewController:groupViewController withInputEnabled:NO] animated:YES];
}

- (BOOL) areMoreNotes
{
    return [self.paragraph.noteCount integerValue] > [notes count] && [notes count]>0;
}

- (void) checkForNoComments
{
    if ([notes count]<=0 && [self.paragraph.noteCount intValue]<=0)
    {
        NSLog(@"No comments!");
        if (!noComments)
        {
            noComments = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-comments.png"]];
        }
        [self.view addSubview:noComments];
        self.tableView.scrollEnabled = NO;
    }
    else
    {
        if (noComments)
        {
            [noComments removeFromSuperview];
        }
        self.tableView.scrollEnabled = YES;
    }
}

# pragma mark - Note Composer Delegate methods
- (void) didFinishComposingNote:(RSNote *)note withResult:(NSInteger)result error:(NSError *)error
{
    NSLog(@"Finished compositing note with result: %d", result);
    
    // Only close the modal view if the note was submitted succesfully, or if the user cancelled it
    // Do not cancel the note if an error occurred.
    if (result==RSNoteCompositionSucceeded || result==RSNoteCompositionCancelled)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    // If the note was created successfully, open the note detail view with the new note
    if (result==RSNoteCompositionSucceeded)
    {
        RSNoteDetailViewController *noteDetailViewController = [[RSNoteDetailViewController alloc] initWithNote:note];
        [self.navigationController pushViewController:noteDetailViewController animated:NO];
    }
}

#pragma mark - Group Selection delegate
- (void) didChangeToGroup:(NSString *)group
{
    NSLog(@"Did change group.");
    self.navigationItem.leftBarButtonItem.title = group;
    
    // Pull data from the persistent store so that the interface can immediately open
    [self reloadNotes];
    
    // Recreate the current paragraph
    self.paragraph = [RSParagraph createParagraphInDefaultContextForString:raw];
    
    // Request updated notes
    [RSParagraphNotesRequest notesForParagraph:self.paragraph withDelegate:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    status = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    status.enabled = NO;
    status.tintColor = [UIColor whiteColor];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.hidesWhenStopped = YES;
    
    // Add a toolbar to the bottom
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithCustomView: activityIndicator],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         status,
                         nil];
    
    // Set the title and the back button for the notes listing
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.titleView = logo;
    
    //Removed to add image title; will be added later as a custom view
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[ReadSocial sharedInstance].currentGroup style:UIBarButtonItemStyleBordered target:self action:@selector(changeGroup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(presentNoteComposer)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Notes" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.contentSizeForViewInPopover = CGSizeMake(300.0, 300.0);
    
    // Pull data from the persistent store so that the interface can immediately open
    notes = [RSNoteHandler notesForParagraph:_paragraph];
    
    // Request updated notes
    [RSParagraphNotesRequest notesForParagraph:self.paragraph withDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self checkForNoComments];
    
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(305.0, 300.0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(300.0, 300.0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    // If there are more notes to be loaded, then load the number of notes plus one (for the "Load More" row)
    if ([self areMoreNotes])
    {
        return [notes count] + 1;
    }
    
    // If all the notes for the paragraph are loaded in the view, then do not add a row for the "Load More" row
    else
    {
        return [notes count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row >= [notes count])
    {
        cell.textLabel.text = @"Load More";
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.isLink = NO;
        cell.thumbnail.image = nil;
        return cell;
    }
    
    RSNote *note = [notes objectAtIndex:indexPath.row];
    
    cell.imageView.image = note.user.image;
    
    [cell.imageView sizeThatFits:CGSizeMake(50, 50)];
    
    // Configure the cell...
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = note.body;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", note.user.name, [RSDateFormat stringFromDate:note.timestamp]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (note.thumbnailURL)
    {
        [cell.thumbnail loadWithURL:[NSURL URLWithString:note.thumbnailURL]];
    }
    else
    {
        cell.thumbnail.image = nil;
    }
    
    if (note.link)
    {
        cell.isLink = YES;
    }
    else
    {
        cell.isLink = NO;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [notes count])
    {
        NSLog(@"Load more!");
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (!loadingNewItems)
        {
            [self loadMoreNotes];
        }
    }
    
    else
    {
        RSNote *note = [notes objectAtIndex:indexPath.row];
        RSNoteDetailViewController *detailViewController = [[RSNoteDetailViewController alloc] initWithNote:note];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - RSAPIRequest Delegate Methods
- (void) didStartRequest:(RSAPIRequest *)request
{
    NSLog(@"Updating notes...");
    [activityIndicator startAnimating];
    // Listen for the data context to change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNotes) name:NSManagedObjectContextObjectsDidChangeNotification object:[DataContext defaultContext]];
    loadingNewItems = YES;
}
- (void) requestDidSucceed:(RSAPIRequest *)request
{
    NSLog(@"Notes updated.");
    [activityIndicator stopAnimating];
    loadingNewItems = NO;
}

- (void) requestDidFail:(RSAPIRequest *)request withError:(NSError *)error
{
    NSLog(@"Notes could not be updated.");
    [activityIndicator stopAnimating];
    loadingNewItems = NO;
}

@end
