//
//  RSAuthProviderSelect.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 4/23/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSAuthProviderLoginDelegate;
@interface RSAuthProviderSelect : UITableViewController

@property (nonatomic,strong) id<RSAuthProviderLoginDelegate,UIWebViewDelegate> delegate;

@end

@protocol RSAuthProviderLoginDelegate <NSObject>
@required
- (void) didCancelLogin;
@end
