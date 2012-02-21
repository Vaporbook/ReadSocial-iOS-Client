//
//  RSTableViewCell.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/19/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSTableViewCell.h"

@implementation RSTableViewCell
@synthesize thumbnail, isLink=_isLink;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        thumbnail = [[UILazyImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.contentView addSubview:thumbnail];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setIsLink:(BOOL)isLink
{
    _isLink = isLink;
    
    if (isLink)
    {
        self.textLabel.textColor = [UIColor colorWithRed:0.45 green:0 blue:0 alpha:1];
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    else
    {
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:14];
    }
}

- (void)prepareForReuse
{
    thumbnail.image = nil;
    self.isLink = NO;
}

- (void) layoutSubviews
{   
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 5, 5, 50, 50 );
    self.thumbnail.center = CGPointMake(260, 30);
    
    if (thumbnail.url)
    {
        NSLog(@"Determine if text label needs to move.");
        
        CGSize textSize = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(175, 40) lineBreakMode:UILineBreakModeWordWrap];
        CGRect labelFrame = self.textLabel.frame;
        labelFrame.size = textSize;
        self.textLabel.frame = labelFrame;
        
        if (self.textLabel.frame.size.height > 20)
        {
            self.textLabel.center = CGPointMake(self.textLabel.center.x, 25);
            self.detailTextLabel.center = CGPointMake(self.detailTextLabel.center.x, 50);
        }
    }
}

@end
