//
//  PSSCategory.h
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
#import "PSSProductCategory.h"

/** A category found on shopstyle.com  */

@interface PSSCategory : PSSProductCategory <NSCoding, NSCopying, PSSRemoteObject>

/** The child categories of the receiver if any exists. */
@property (nonatomic, strong, readonly) NSArray *childCategories;

/** Returns YES if the receiver will have the size histogram available */
@property (nonatomic, assign, readonly) BOOL hasSizeFilter;

/** Returns YES if the receiver will have the color histogram available */
@property (nonatomic, assign, readonly) BOOL hasColorFilter;

/** Returns YES if the receiver will have the heel height histogram available */
@property (nonatomic, assign, readonly) BOOL hasHeelHeightFilter;

@end
