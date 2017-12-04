//
//  PSSProduct.h
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

@class PSSBrand;
@class PSSRetailer;
@class PSSProductImage;

/** A product on shopstyle.com. */

@interface PSSProduct : NSObject <NSCoding, NSCopying, PSSRemoteObject>

/**---------------------------------------------------------------------------------------
 * @name Product Properties
 *  ---------------------------------------------------------------------------------------
 */

/** The unique identifier of the receiver. */
@property (nonatomic, copy, readonly) NSNumber *productID;

/** A name to display for the receiver. This often includes the brand's name as well. */
@property (nonatomic, copy, readonly) NSString *name;

/** The retailer's description of the receiver. This string may or may not contain HTML tags. */
@property (nonatomic, copy, readonly) NSString *descriptionHTML;

/** The click-through URL to purchase the receiver, which will take a user to the retailer's web page where the product 
 may be purchased. */
@property (nonatomic, copy, readonly) NSURL *buyURL;

/** The click-through URL to view the receiver, which will take a user to the ShopStyle product detail page */
@property (nonatomic, copy, readonly) NSURL *productPageURL;

/** A string representation of the `regularPrice`. */
@property (nonatomic, copy, readonly) NSString *regularPriceLabel;

/** The regular price in the currency of the receiver.
 
 The price of the product when not on sale. If the product isOnSale use salePrice for the price. */
@property (nonatomic, copy, readonly) NSNumber *regularPrice;

/** A string representation of the `maxRegularPrice`. */
@property (nonatomic, copy, readonly) NSString *maxRegularPriceLabel;

/** The maximum price in the currency of the receiver when priced in a range.  
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the regularPrice contains the lower end of the range.  If the product is not priced as
 a range this property is nil.
 */
@property (nonatomic, copy, readonly) NSNumber *maxRegularPrice;

/** A string representation of the `salePrice`. */
@property (nonatomic, copy, readonly) NSString *salePriceLabel;

/** The sale price in the currency of the receiver.  
 
 If the product is not priced on sale this property is nil.
 */
@property (nonatomic, copy, readonly) NSNumber *salePrice;

/** A string representation of the `maxSalePrice`. */
@property (nonatomic, copy, readonly) NSString *maxSalePriceLabel;

/** The maximum sale price in the currency of the receiver when on sale and priced in a range.  
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the salePrice contains the lower end of the range.  If the product is not priced 
 as a range or is not on sale this property is nil.
 */
@property (nonatomic, copy, readonly) NSNumber *maxSalePrice;

/** The currency of the price. Examples are USD, GBP, and EUR. */
@property (nonatomic, copy, readonly) NSString *currency;

/** The brand of the receiver. */
@property (nonatomic, strong, readonly) PSSBrand *brand;

/** The retailer of the receiver. */
@property (nonatomic, strong, readonly) PSSRetailer *retailer;

/** A label that can be used for a control that takes the user to more products like the receiver.  
 
 Example:  "See more Dresses by Bebe" */
@property (nonatomic, copy, readonly) NSString *seeMoreLabel;

/** A shopstyle.com URL that shows more products like the receiver. */
@property (nonatomic, copy, readonly) NSURL *seeMoreURL;

/** All categories on shopstyle.com that contain the receiver.
 
 @return An array of `PSSProductCategory` objects representing all categories on shopstyle.com that contain this product. */
@property (nonatomic, copy, readonly) NSArray *categories;

/** The locale of the retailer. */
@property (nonatomic, copy, readonly) NSString *localeIdentifier;

/** The colors available at the retailer.
 
 @return An array of `PSSProductColor` objects representing the available colors at the retailer. */
@property (nonatomic, copy, readonly) NSArray *colors;

/** The sizes available at the retailer.
 
 @return An array of `PSSProductSize` objects representing the available sizes at the retailer. */
@property (nonatomic, copy, readonly) NSArray *sizes;

/** The receiver was in stock the last poll of the retailer's website.
 
 Out of stock products should not be returned by product searches but my be returned by other methods such as getting a product by it's identifier.
 
 @returns YES if the product is currently in stock. */
@property (nonatomic, assign, readonly) BOOL inStock;

/** The date this product was first extracted from the retailer's website and added to shopstyle.com. */
@property (nonatomic, copy, readonly) NSString *extractDate;

/** Default image of the receiver. */
@property (nonatomic, strong, readonly) PSSProductImage *image;

/** Alternate images of the receiver. */
@property (nonatomic, copy, readonly) NSArray *alternateImages;

/** The currency of the pricing information of the product from the locale it was extracted. Examples are USD, GBP, and EUR. 
 
 For example, if a product from a Japanese retailer is displayed in a US local it's currency will 
 be USD and it's nativeCurrency will be YEN.
 
 @warning When a product originates in a locale other than the one used to fetch the receiver the price properties contain 
 converted values. Native price properties contain the pricing information in it's original currancy.
 
 @see hasNativePrice
 */
@property (nonatomic, copy, readonly) NSString *nativeCurrency;

/** A string representation of the `nativePrice`. */
@property (nonatomic, copy, readonly) NSString *nativePriceLabel;

/** The regular price in the nativeCurrency of the receiver.
 
 The price of the product when not on sale. If the product isOnSale use nativeSalePrice for the price.
 
 @see nativeCurrency
 
 @return A price in nativeCurrency or nil if regularPrice was not converted for the receiver's locale.
 */
@property (nonatomic, copy, readonly) NSNumber *nativePrice;

/** A string representation of the `nativeMaxPrice`. */
@property (nonatomic, copy, readonly) NSString *nativeMaxPriceLabel;

/** The maximum price in the nativeCurrency of the receiver when priced in a range.
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the nativePrice contains the lower end of the range.  If the product is not priced as
 a range this property is nil.
 
 @see nativeCurrency
 
 @return A max price in nativeCurrency or nil if regularMaxPrice was not converted for the receiver's locale.
 */
@property (nonatomic, copy, readonly) NSNumber *nativeMaxPrice;

/** A string representation of the `nativeSalePrice`. */
@property (nonatomic, copy, readonly) NSString *nativeSalePriceLabel;

/** The sale price in the nativeCurrency of the receiver.
 
 If the product is not priced on sale this property is nil.
 
 @see nativeCurrency
 
 @return A sale price in nativeCurrency or nil if salePrice was not converted for the receiver's locale.
 */
@property (nonatomic, copy, readonly) NSNumber *nativeSalePrice;

/** A string representation of the `nativeMaxSalePrice`. */
@property (nonatomic, copy, readonly) NSString *nativeMaxSalePriceLabel;

/** The maximum sale price in the nativeCurrency of the receiver when on sale and priced in a range.
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the nativeSalePrice contains the lower end of the range.  If the product is not priced
 as a range or is not on sale this property is nil.
 
 @see nativeCurrency
 
 @return A max sale price in nativeCurrency or nil if maxSalePrice was not converted for the receiver's locale.
 */
@property (nonatomic, copy, readonly) NSNumber *nativeMaxSalePrice;

/**---------------------------------------------------------------------------------------
 * @name Pricing Helpers
 *  ---------------------------------------------------------------------------------------
 */

/** The receiver was on sale the last poll of the retailer's website.
 
 @return YES if the product is on sale. */
- (BOOL)isOnSale;

/** The product's price should be displayed as a price range.
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the `currentPrice` contains the lower end of the range and the `currentMaxPrice` contains the upper end of the range.
 
 @return YES if the product price should be displayed as a price range.
 */
- (BOOL)hasPriceRange;

/** A string representation of the `currentPrice`. */
- (NSString *)currentPriceLabel;

/** The current price in the currency of the receiver. The current low price when priced in a range.
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the `currentMaxPrice` contains the higher end of the range.
 
 @return The salePrice if there is one, otherwise returns the regularPrice. */
- (NSNumber *)currentPrice;

/** A string representation of the `currentMaxPrice`. */
- (NSString *)currentMaxPriceLabel;

/** The current max price in the currency of the receiver when priced in a range.
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the `currentPrice` contains the lower end of the range.  If the product is not priced as
 a range this property is nil.
 
 @return The maxSalePrice if there is one, otherwise returns the maxRegularPrice. If the receiver does not have a price range returns nil.
 */
- (NSNumber *)currentMaxPrice;

/** The currentPrice of the reciever has been converted and a price is available for the native local of the receiver.
 
 @return YES if the price fields contain a translated value and native price information is available.
 */
- (BOOL)hasNativePrice;

@end
