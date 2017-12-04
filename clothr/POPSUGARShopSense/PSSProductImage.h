//
//  PSSProductImage.h
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
#import <UIKit/UIKit.h>
#import "PSSClient.h"

extern NSString * const PSSProductImageSizeSmall;
extern NSString * const PSSProductImageSizeIPhoneSmall;
extern NSString * const PSSProductImageSizeMedium;
extern NSString * const PSSProductImageSizeLarge;
extern NSString * const PSSProductImageSizeIPhone;

extern CGSize CGSizeFromPSSProductImageSize(NSString *size);

/** An image of a `PSSProduct` */

@interface PSSProductImage : NSObject <NSCoding, NSCopying, PSSRemoteObject>

/** The unique identifier of the receiver. */
@property (nonatomic, copy, readonly) NSString *imageID;

/** The absolute URL to fetch the original image data. */
@property (nonatomic, copy, readonly) NSURL *URL;

/** The absolute URL to fetch the resized image data.
 
 Images are cut into different sizes. Possible sizes are:
 
 PSSProductImageSizeNamedSmall: "Small" image with a maximum size (32,40)
 
 PSSProductImageSizeNamedIPhoneSmall = "IPhoneSmall" image with a maximum size (100,125)
 
 PSSProductImageSizeNamedMedium = "Medium" image with a maximum size (112,140)
 
 PSSProductImageSizeNamedLarge = "Large" image with a maximum size (164,205)
 
 PSSProductImageSizeNamedIPhone = "IPhone" image with a maximum size (288,360)
 
 You can get the bounding CGSize of a size with:
 
 `CGSize CGSizeFromPSSProductImageSize(NSString *size);`
 
 The original image is resized to fit within this size
 without changing the aspect ratio. Therefor the actual width may be less than this number.
 */
- (NSURL *)imageURLWithSize:(NSString *)size;

@end
