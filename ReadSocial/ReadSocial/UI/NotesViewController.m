//
//  NotesViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/28/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "NotesViewController.h"
#import "RSParagraph+Core.h"
#import "RSNote+Core.h"
#import "RSNoteHandler.h"
#import "ParagraphNotesRequest.h"
#import "NoteDetailViewController.h"
#import "RSUser+Core.h"
#import "DataContext.h"

@implementation NotesViewController
@synthesize paragraph=_paragraph;

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
}
- (void) presentNoteComposer
{
    // Create the composer
    noteComposer = [RSComposeNoteViewController new];
    
    UINavigationController *composer = [[UINavigationController alloc] initWithRootViewController:noteComposer];
    
    composer.modalInPopover = YES;
    composer.modalPresentationStyle = UIModalPresentationCurrentContext;
    noteComposer.delegate = self;
    [self.navigationController presentModalViewController:composer animated:YES];
}

- (void) requestDidSucceed:(id)note
{
    [DataContext save];
    NoteDetailViewController *detail = [[NoteDetailViewController alloc] initWithNote:(RSNote *)note];
    [self.navigationController pushViewController:detail animated:NO];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

# pragma mark - Note Composer Delegate methods
- (void) didCancelNoteComposition
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void) didSubmitNoteWithString:(NSString *)content
{
    [noteComposer disableSubmitButton];
    [RSCreateNoteRequest createNoteWithString:content forParagraph:self.paragraph withDelegate:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the title and the back button for the notes listing
    self.title = @"ReadSocial";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(presentNoteComposer)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Notes" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.contentSizeForViewInPopover = CGSizeMake(300.0, 300.0);
    
    // Listen for the data context to change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNotes) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    notes = [RSNoteHandler notesForParagraph:_paragraph];
    [RSNoteHandler updateNotesForParagraph:_paragraph];
    
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
    return [notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    RSNote *note = [notes objectAtIndex:indexPath.row];
    
    cell.imageView.image = note.user.image;
    
    [cell.imageView sizeThatFits:CGSizeMake(50, 50)];
    
    // Configure the cell...
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    cell.textLabel.text = note.body;
    
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
    // Navigation logic may go here. Create and push another view controller.
    RSNote *note = [notes objectAtIndex:indexPath.row];
    NoteDetailViewController *detailViewController = [[NoteDetailViewController alloc] initWithNote:note];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
