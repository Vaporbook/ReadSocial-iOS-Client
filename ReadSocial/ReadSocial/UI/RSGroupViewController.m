//
//  RSGroupViewController.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSGroupViewController.h"

@implementation RSGroupViewController
@synthesize groups, delegate, paragraph;

- (id) init
{
    self = [super init];
    if (self)
    {
        oldGroup = [ReadSocial currentGroup];
        selectedGroup = oldGroup;
        
        customGroup = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 25)];
        customGroup.borderStyle = UITextBorderStyleRoundedRect;
        customGroup.autocorrectionType = UITextAutocorrectionTypeNo;
        customGroup.delegate = self;
        customGroup.placeholder = @"Create a new group";
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
    }
    return self;
}

- (void) selectedGroup
{
    // Close the keyboard (if it's open)
    [customGroup resignFirstResponder];
    
    // Check if the name of the group changed
    if (![oldGroup isEqualToString:selectedGroup] && [delegate respondsToSelector:@selector(didChangeToGroup:)])
    {
        [[ReadSocial sharedInstance] changeToGroupWithString:selectedGroup];
        [delegate didChangeToGroup:selectedGroup];
    }
    
    // Close the modal view
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *) groupNameAtIndexPath: (NSIndexPath *)indexPath
{
    switch (indexPath.row) 
    {
        case 0:
            return customGroup.text;
            break;
        default:
        {
            NSInteger index = indexPath.row - 1;
            if (index>=0 && index<[groups count])
            {
                return [groups objectAtIndex:index];
            }
            break;
        }
    }
    
    return nil;
}

#pragma mark - UITextView Delegate Methods

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Users are NOT allowed to put a space in a group name
    if ([string isEqualToString:@" "]) 
    {
        return NO;
    }
    
    // Determine what the new value of the text field is going to be
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // If the field is about to be empty (user clearing out the last text)
    // set the selected group to the old group
    if (newValue.length==0)
    {
        selectedGroup = oldGroup;
    }
    
    // Otherwise update the selected group to this group
    else
    {
        // As the user edits the text field, select the first row
        selectedGroup = newValue;
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.tableView reloadData];
}

#pragma mark - RSAPIRequest Delegate Methods
- (void) didStartRequest:(RSAPIRequest *)request
{
    [activityIndicator startAnimating];
}
- (void) requestDidSucceed:(RSActiveGroupsRequest *)request
{
    groups = request.groups;
    [self.tableView reloadData];
    [activityIndicator stopAnimating];
}
- (void) requestDidFail:(RSAPIRequest *)request withError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:[error localizedDescription] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    [activityIndicator stopAnimating];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Request active groups
    [RSActiveGroupsRequest requestActiveGroupsForParagraph:self.paragraph withDelegate:self];
    
    self.title = @"Change Group";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectedGroup)];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 300.0);
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
    return [groups count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Reset cell properties
    cell.textLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Create the cell based on the index path
    switch (indexPath.row) 
    {
        case 0:
            [cell.contentView addSubview:customGroup];
            break;
            
        default:
            cell.textLabel.text = [self groupNameAtIndexPath:indexPath];
            break;
    }
    
    // Configure the cell...
    
    
    // If the group name is the same as the current group, place a check mark in the cell
    if ([[self groupNameAtIndexPath:indexPath]  isEqualToString:selectedGroup]) 
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedGroup = [self groupNameAtIndexPath:indexPath];
    
    [self.tableView reloadData]; // Moves the checkmark to the proper place
    
    // Animate selecting the row
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
