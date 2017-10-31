//
//  helperfunctions.h
//  clothr
//
//  Created by Andrew Guterres on 10/29/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

#ifndef helperfunctions_h
#define helperfunctions_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PSSProductQuery.h"
#import "PSSProduct.h"
#import "PSSClient.h"

@interface helperfunctions : NSObject <NSCoding, NSCopying>

- (NSArray*)fillProductBuffer;

@end
#endif /* helperfunctions_h */
