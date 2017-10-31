//
//  PSSProductColor.h
//
//  Copyright (c) 2013 POPSUGAR Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "PSSClient.h"

@class PSSProductImage;

/** The retailer/brand color description */

@interface PSSProductColor : NSObject <NSCoding, NSCopying, PSSRemoteObject>

/** A name to display for the receiver. */
@property (nonatomic, copy, readonly) NSString *name;

/** Image of the receiver. */
@property (nonatomic, strong, readonly) PSSProductImage *image;

/** An optional list of PSSColor objects that match the receiver */
@property (nonatomic, copy, readonly) NSArray *canonicalColors;

/** An optional URL for a swatch image of the receiver */
@property (nonatomic, copy, readonly) NSURL *swatchURL;

@end
