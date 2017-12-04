//
//  PSSProductQuery.m
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

#import "PSSProductQuery.h"

NSString * const PSSProductQuerySortPriceLoHi = @"PriceLoHi";
NSString * const PSSProductQuerySortPriceHiLo = @"PriceHiLo";
NSString * const PSSProductQuerySortRecency = @"Recency";
NSString * const PSSProductQuerySortPopular = @"Popular";
NSString * const PSSProductQuerySortDefault = @"Relevance";

@interface PSSProductQuery ()

@property (nonatomic, strong) NSMutableOrderedSet *productFilterSet;

@end

@implementation PSSProductQuery

#pragma mark - init

+ (instancetype)productQueryWithSearchTerm:(NSString *)searchTearm
{
	PSSProductQuery *instance = [[[self class] alloc] init];
	instance.searchTerm = searchTearm;
	return instance;
}

+ (instancetype)productQueryWithCategoryID:(NSString *)productCategoryID
{
	PSSProductQuery *instance = [[[self class] alloc] init];
	instance.productCategoryID = productCategoryID;
	return instance;
}

- (id)init
{
	self = [super init];
	if (self) {
		_productFilterSet = [[NSMutableOrderedSet alloc] init];
		_showInternationalProducts = NO;
	}
	return self;
}

#pragma mark - Sort

+ (BOOL)isValidSortType:(NSString *)sort
{
	return ([sort isEqualToString:PSSProductQuerySortDefault] || [sort isEqualToString:PSSProductQuerySortPopular] || [sort isEqualToString:PSSProductQuerySortRecency] || [sort isEqualToString:PSSProductQuerySortPriceHiLo] || [sort isEqualToString:PSSProductQuerySortPriceLoHi]);
}

- (void)setSort:(NSString *)sort
{
	if (sort == nil) {
		_sort = nil;
		return;
	}
	NSAssert([[self class] isValidSortType:sort], @"You must choose a sort from the supplied constants.");
	if (![sort isEqualToString:self.sort]) {
		_sort = [sort copy];
	}
}

#pragma mark - Product Filters

- (void)addProductFilter:(PSSProductFilter *)newFilter
{
	[self.productFilterSet addObject:newFilter];
}

- (void)addProductFilters:(NSArray *)newFilters
{
	[self.productFilterSet addObjectsFromArray:newFilters];
}

- (void)removeProductFilter:(PSSProductFilter *)filter
{
	[self.productFilterSet removeObject:filter];
}

- (NSArray *)productFilters
{
	return [self.productFilterSet array];
}

- (NSSet *)productFilterSetOfType:(NSString *)filterType
{
	NSSet *filteredSet = [[self.productFilterSet set] objectsPassingTest:^BOOL(id obj, BOOL *stop) {
		if ([[(PSSProductFilter *)obj type] isEqualToString:filterType]) {
			return YES;
		}
		return NO;
	}];
	return filteredSet;
}

- (NSArray *)productFiltersOfType:(NSString *)filterType
{
	return [[self productFilterSetOfType:filterType] allObjects];
}

- (void)clearProductFilters
{
	[self.productFilterSet removeAllObjects];
}

- (void)clearProductFiltersOfType:(NSString *)filterType
{
	[self.productFilterSet minusSet:[self productFilterSetOfType:filterType]];
}

#pragma mark - Conversion to URL Query Parameters

- (NSDictionary *)queryParameterRepresentation
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	
	if (self.searchTerm != nil && self.searchTerm.length > 0) {
		dictionary[@"fts"] = self.searchTerm;
	}
	if (self.productCategoryID != nil && self.productCategoryID.length > 0) {
		dictionary[@"cat"] = self.productCategoryID;
	}
	
	if (self.productFilterSet.count > 0) {
		dictionary[@"fl"] = [[self productFilters] valueForKey:@"queryParameterRepresentation"];
	}
	
	if (self.priceDropDate != nil) {
		NSNumber *numberRep = @([self.priceDropDate timeIntervalSince1970] * 1000);
		dictionary[@"pdd"] = numberRep;
	}
	
	if (self.sort != nil && ![self.sort isEqualToString:PSSProductQuerySortDefault]) {
		dictionary[@"sort"] = self.sort;
	}
	
	if (self.showInternationalProducts) {
		dictionary[@"locales"] = @"all";
	}
	
	return dictionary;
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@", [self queryParameterRepresentation]];
}

- (NSUInteger)hash
{
	// a very simple hash
	NSUInteger hash = 0;
	hash ^= self.productFilterSet.hash;
	hash ^= self.searchTerm.hash;
	hash ^= self.productCategoryID.hash;
	hash ^= self.priceDropDate.hash;
	hash ^= self.sort.hash;
	hash ^= self.showInternationalProducts ? 1 : 0;
	return hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return [self isEqualToProductQuery:object];
}

- (BOOL)isEqualToProductQuery:(PSSProductQuery *)productQuery
{
	NSParameterAssert(productQuery != nil);
	if (productQuery == self) {
		return YES;
	}
	
	if (![productQuery.productFilterSet isEqualToOrderedSet:self.productFilterSet]) {
		return NO;
	}
	if ((productQuery.searchTerm != nil || self.searchTerm != nil) && ![productQuery.searchTerm isEqualToString:self.searchTerm]) {
		return NO;
	}
	if ((productQuery.productCategoryID != nil || self.productCategoryID != nil) && ![productQuery.productCategoryID isEqualToString:self.productCategoryID]) {
		return NO;
	}
	if ((productQuery.priceDropDate != nil || self.priceDropDate != nil) && ![productQuery.priceDropDate isEqualToDate:self.priceDropDate]) {
		return NO;
	}
	if ((productQuery.sort != nil || self.sort != nil) && ![productQuery.sort isEqualToString:self.sort]) {
		return NO;
	}
	if (productQuery.showInternationalProducts != self.showInternationalProducts) {
		return NO;
	}
	
	return YES;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.searchTerm forKey:@"searchTerm"];
	[encoder encodeObject:self.productCategoryID forKey:@"productCategoryID"];
	[encoder encodeObject:self.priceDropDate forKey:@"priceDropDate"];
	[encoder encodeObject:self.sort forKey:@"sort"];
	[encoder encodeObject:self.productFilterSet forKey:@"productFilterSet"];
	[encoder encodeBool:self.showInternationalProducts forKey:@"showInternationalProducts"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [self init])) {
		self.searchTerm = [decoder decodeObjectForKey:@"searchTerm"];
		self.productCategoryID = [decoder decodeObjectForKey:@"productCategoryID"];
		self.priceDropDate = [decoder decodeObjectForKey:@"priceDropDate"];
		self.sort = [decoder decodeObjectForKey:@"sort"];
		self.productFilterSet = [decoder decodeObjectForKey:@"productFilterSet"];
		self.showInternationalProducts = [decoder decodeBoolForKey:@"showInternationalProducts"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.searchTerm = self.searchTerm;
	copy.productCategoryID = self.productCategoryID;
	copy.priceDropDate = self.priceDropDate;
	copy.sort = self.sort;
	copy.productFilterSet = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.productFilterSet copyItems:YES];
	copy.showInternationalProducts = self.showInternationalProducts;
	return copy;
}

@end
