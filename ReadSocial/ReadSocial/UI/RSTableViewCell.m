//
//  RSTableViewCell.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/19/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSTableViewCell.h"

@implementation RSTableViewCell

- (void) layoutSubviews
{   
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 10, 10, 50, 50 ); // your positioning here
}

@end
