//
//  PSSProductQuery.h
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
#import "PSSProductFilter.h"

extern NSString * const PSSProductQuerySortPriceLoHi;
extern NSString * const PSSProductQuerySortPriceHiLo;
extern NSString * const PSSProductQuerySortRecency;
extern NSString * const PSSProductQuerySortPopular;
extern NSString * const PSSProductQuerySortDefault;

/**
 The ShopSense API is made up of several methods to return product data, including an array of products
 and a product histogram. A `PSSProductFilter` can be used to further refine the results from these requests.
 */

@interface PSSProductQuery : NSObject <NSCoding, NSCopying>

/**---------------------------------------------------------------------------------------
 * @name Creating Product Queries
 *  ---------------------------------------------------------------------------------------
 */

/** A convenience method to great a PSSProductFilter initialized with a search term. */
+ (instancetype)productQueryWithSearchTerm:(NSString *)searchTearm;

/** A convenience method to great a PSSProductFilter initialized with a product category identifier. */
+ (instancetype)productQueryWithCategoryID:(NSString *)productCategoryID;

/**---------------------------------------------------------------------------------------
 * @name Query Parameters
 *  ---------------------------------------------------------------------------------------
 */

/** Text search term, as a user would enter in a "Search:" field.
 
 This is also known as `fts` on the ShopSense API documentation. */
@property (nonatomic, copy) NSString *searchTerm;

/** A product category identifier. Only products within the category will be returned. This should be a `PSSProductCategory categoryID`.
 
 This is also known as `cat` on the ShopSense API documentation. */
@property (nonatomic, copy) NSString *productCategoryID;

/** A price drop date, if present, limits the results to products whose price has dropped since the given date.
 
 This is also known as `pdd` on the ShopSense API documentation.  */
@property (nonatomic, copy) NSDate *priceDropDate;

/** The sort algorithm to use.
 
 Possible values are:
 
 `PSSProductQuerySortDefault`
 The most relevant products to the product query are listed first.
 
 `PSSProductQuerySortPriceLoHi`
 Sort by price in ascending order.
 
 `PSSProductQuerySortPriceHiLo`
 Sort by price in descending order.
 
 `PSSProductQuerySortRecency`
 Sort by the recency of the products.
 
 `PSSProductQuerySortPopular`
 Sort by the popularity of the products.
 
 This is also known as `sort` on the ShopSense API documentation.
 */
@property (nonatomic, copy) NSString *sort;

/** YES to include products from outside the -[PSSClient currentLocale] in the response to requests using the receiver. Default is NO.
 
 This has no effect in the en_US locale. */
@property (nonatomic, assign) BOOL showInternationalProducts;

/**---------------------------------------------------------------------------------------
 * @name Managing Product Filters
 *  ---------------------------------------------------------------------------------------
 */

/** All filters that are part of the receiver.
 
 These are also known as `fl` parameters on the ShopSense API documentation.
 
 @return An array of all `PSSProductFilter` objects.
 */
- (NSArray *)productFilters;

/** All filters that are part of the receiver matching filterType.
 
 @param filterType The type of filters to return.
 @return An array of all `PSSProductFilter` objects of a specific filter type that are part of the receiver. See `PSSProductFilter` for a list of the avaiable filter types. */
- (NSArray *)productFiltersOfType:(NSString *)filterType;

/** Add a `PSSProductFilter` object to the receiver.
 
 If the filter exists it will not be added again.
 
 @param newFilter The `PSSProductFilter` to add.
 */
- (void)addProductFilter:(PSSProductFilter *)newFilter;

/** Add an array of `PSSProductFilter` objects to the receiver.
 
 If an individual filter exists it will not be added again.
 
 @param newFilters An array of `PSSProductFilter` objects to add.
 */
- (void)addProductFilters:(NSArray *)newFilters;

/** Remove a `PSSProductFilter` objects from the receiver that matches the filter parameter.
 
 @param filter A `PSSProductFilter` to remove if found.
 */
- (void)removeProductFilter:(PSSProductFilter *)filter;

/** Clears all `PSSProductFilter` objects that are part of the receiver. */
- (void)clearProductFilters;

/** Clears all `PSSProductFilter` objects of a specific filter type that are part of the receiver. See `PSSProductFilter` for a list of the avaiable filter types.
 
 @param filterType The type of filters to remove.
 */
- (void)clearProductFiltersOfType:(NSString *)filterType;

/**---------------------------------------------------------------------------------------
 * @name Converting to URL Parameters
 *  ---------------------------------------------------------------------------------------
 */

/** A representation of the receiver used to create URL query parameters when making a product request on the ShopSense API */
- (NSDictionary *)queryParameterRepresentation;


/**---------------------------------------------------------------------------------------
 * @name Comparing Product Queries
 *  ---------------------------------------------------------------------------------------
 */

/** Returns a Boolean value that indicates whether a given `PSSProductQuery` is equal to the receiver using an isEqual: test on all properties. */
- (BOOL)isEqualToProductQuery:(PSSProductQuery *)productQuery;

@end
