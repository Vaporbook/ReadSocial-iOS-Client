//
//  RSTableViewCell.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/19/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILazyImageView.h"

@interface RSTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILazyImageView *thumbnail;
@property (nonatomic, readwrite) BOOL isLink;

@end
