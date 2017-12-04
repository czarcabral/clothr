//
//  PSSCategoryTree.h
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

@class PSSCategory;

/** A collection categories found on shopstyle.com  */

@interface PSSCategoryTree : NSObject <NSCoding, NSCopying>

/** The top-level category for the receiver. */
@property (nonatomic, strong, readonly) PSSCategory *rootCategory;

/** Initializes a category tree.
 
 @param rootCategoryID The category identifier to consider the parent of the receiver.
 @param categories An array of `PSSCategory` objects to build into the receiver. This must be in top down order.
 */
- (id)initWithRootID:(NSString *)rootCategoryID categories:(NSArray *)categories;

/** All categories that are part of the receiver in a flat array. */
- (NSArray *)allCategories;

/** Find a specific category in the receiver by it's identifier.
 
 @param categoryID A category identifier.
 */
- (PSSCategory *)categoryWithID:(NSString *)categoryID;

@end
