//
//  PSSProductCategory.h
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

/** A product's category.  */

@interface PSSProductCategory : NSObject <NSCoding, NSCopying, PSSRemoteObject>

/** The unique identifier of the receiver. See `PSSCategoryTree` to understand it's position in the hierarchy. */
@property (nonatomic, copy, readonly) NSString *categoryID;

/** A name to display for the receiver. */
@property (nonatomic, copy, readonly) NSString *name;

/** A short version of the receiver's name. If none exists name will be returned. */
@property (nonatomic, copy, readonly) NSString *shortName;

/** The unique identifier of the receiver localized in the currentLocale of the client. */
@property (nonatomic, copy, readonly) NSString *localizedCategoryID;

@end
