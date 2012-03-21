//
//  RSNoteImageRequest.h
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSAPIRequest.h"

@interface RSNoteImageRequest : RSAPIRequest

+ (NSURL *) URLForImageName: (NSString *) imageName;

@end
