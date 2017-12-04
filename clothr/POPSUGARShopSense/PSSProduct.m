//
//  PSSProduct.m
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

#import "PSSProduct.h"
#import "POPSUGARShopSense.h"
#import "PSSBrand.h"
#import "PSSProductCategory.h"
#import "PSSProductImage.h"
#import "PSSRetailer.h"

@interface PSSProduct ()

@property (nonatomic, copy, readwrite) NSNumber *productID;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *descriptionHTML;
@property (nonatomic, copy, readwrite) NSURL *buyURL;
@property (nonatomic, copy, readwrite) NSURL *productPageURL;
@property (nonatomic, copy, readwrite) NSString *regularPriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *regularPrice;
@property (nonatomic, copy, readwrite) NSString *maxRegularPriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *maxRegularPrice;
@property (nonatomic, copy, readwrite) NSString *salePriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *salePrice;
@property (nonatomic, copy, readwrite) NSString *maxSalePriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *maxSalePrice;
@property (nonatomic, copy, readwrite) NSString *currency;
@property (nonatomic, strong, readwrite) PSSBrand *brand;
@property (nonatomic, strong, readwrite) PSSRetailer *retailer;
@property (nonatomic, copy, readwrite) NSString *seeMoreLabel;
@property (nonatomic, copy, readwrite) NSURL *seeMoreURL;
@property (nonatomic, copy, readwrite) NSArray *categories;
@property (nonatomic, copy, readwrite) NSString *localeIdentifier;
@property (nonatomic, copy, readwrite) NSArray *colors;
@property (nonatomic, copy, readwrite) NSArray *sizes;
@property (nonatomic, assign, readwrite) BOOL inStock;
@property (nonatomic, copy, readwrite) NSString *extractDate;
@property (nonatomic, strong, readwrite) PSSProductImage *image;
@property (nonatomic, copy, readwrite) NSArray *alternateImages;
@property (nonatomic, copy, readwrite) NSString *nativeCurrency;
@property (nonatomic, copy, readwrite) NSString *nativePriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *nativePrice;
@property (nonatomic, copy, readwrite) NSString *nativeMaxPriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *nativeMaxPrice;
@property (nonatomic, copy, readwrite) NSString *nativeSalePriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *nativeSalePrice;
@property (nonatomic, copy, readwrite) NSString *nativeMaxSalePriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *nativeMaxSalePrice;

@end

@implementation PSSProduct

#pragma mark - Pricing Helpers

- (BOOL)isOnSale
{
	return (self.salePrice != nil && self.salePrice.integerValue > 0);
}

- (BOOL)hasPriceRange
{
	return ([self currentMaxPrice] != nil);
}

- (BOOL)hasNativePrice
{
	return (self.nativeCurrency != nil);
}

- (NSString *)currentPriceLabel
{
	if (self.salePriceLabel != nil) {
		return self.salePriceLabel;
	}
	return self.regularPriceLabel;
}

- (NSNumber *)currentPrice
{
	if (self.salePrice != nil) {
		return self.salePrice;
	}
	return self.regularPrice;
}

- (NSString *)currentMaxPriceLabel
{
	if (self.maxSalePriceLabel != nil) {
		return self.maxSalePriceLabel;
	}
	return self.maxRegularPriceLabel;
}

- (NSNumber *)currentMaxPrice
{
	if (self.maxSalePrice != nil) {
		return self.maxSalePrice;
	}
	return self.maxRegularPrice;
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.productID];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSSDLog(@"Warning: Undefined Key Named '%@' with value: %@", key, [value description]);
}

- (NSUInteger)hash
{
	return self.productID.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.productID isEqualToNumber:[(PSSProduct *)object productID]]);
}

#pragma mark - PSSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSProduct *instance = [[[self class] alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	if (![aDictionary isKindOfClass:[NSDictionary class]]) {
		return;
	}
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"clickUrl"]) {
			if ([value isKindOfClass:[NSString class]]) {
				self.buyURL = [NSURL URLWithString:value];
			}
		} else if ([key isEqualToString:@"pageUrl"]) {
			if ([value isKindOfClass:[NSString class]]) {
				self.productPageURL = [NSURL URLWithString:value];
			}
		} else if ([key isEqualToString:@"seeMoreUrl"]) {
			if ([value isKindOfClass:[NSString class]]) {
				self.seeMoreURL = [NSURL URLWithString:value];
			}
		} else if ([key isEqualToString:@"description"]) {
			self.descriptionHTML = [value description];
		} else if ([key isEqualToString:@"locale"]) {
			self.localeIdentifier = [value description];
		} else if ([key isEqualToString:@"id"]) {
			if ([value isKindOfClass:[NSNumber class]]) {
				self.productID = value;
			} else if ([value isKindOfClass:[NSString class]]) {
				self.productID = @([value integerValue]);
			}
		} else if ([key isEqualToString:@"brand"]) {
			if ([value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
				self.brand = (PSSBrand *)[self remoteObjectForRelationshipNamed:@"brand" fromRepresentation:value];
			}
		} else if ([key isEqualToString:@"categories"]) {
			if ([value isKindOfClass:[NSArray class]]) {
				self.categories = [self remoteObjectsForToManyRelationshipNamed:@"categories" fromRepresentations:value];
			}
		} else if ([key isEqualToString:@"colors"]) {
			if ([value isKindOfClass:[NSArray class]]) {
				self.colors = [self remoteObjectsForToManyRelationshipNamed:@"colors" fromRepresentations:value];
			}
		} else if ([key isEqualToString:@"image"]) {
			if ([value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
				self.image = (PSSProductImage *)[self remoteObjectForRelationshipNamed:@"image" fromRepresentation:value];
			}
		} else if ([key isEqualToString:@"alternateImages"]) {
			if ([value isKindOfClass:[NSArray class]]) {
				self.alternateImages = [self remoteObjectsForToManyRelationshipNamed:@"image" fromRepresentations:value];
			}
		} else if ([key isEqualToString:@"retailer"]) {
			if ([value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
				self.retailer = (PSSRetailer *)[self remoteObjectForRelationshipNamed:@"retailer" fromRepresentation:value];
			}
		} else if ([key isEqualToString:@"sizes"]) {
			if ([value isKindOfClass:[NSArray class]]) {
				self.sizes = [self remoteObjectsForToManyRelationshipNamed:@"sizes" fromRepresentations:value];
			}
		} else if ([key isEqualToString:@"price"]) {
			if ([value isKindOfClass:[NSNumber class]]) {
				self.regularPrice = value;
			} else if ([value isKindOfClass:[NSString class]]) {
				self.regularPrice = @([value integerValue]);
			}
		} else if ([key isEqualToString:@"priceLabel"]) {
			self.regularPriceLabel = [value description];
		} else if ([key isEqualToString:@"maxPrice"]) {
			if ([value isKindOfClass:[NSNumber class]]) {
				self.maxRegularPrice = value;
			} else if ([value isKindOfClass:[NSString class]]) {
				self.maxRegularPrice = @([value integerValue]);
			}
		} else if ([key isEqualToString:@"maxPriceLabel"]) {
			self.maxRegularPriceLabel = [value description];
		} else if ([key isEqualToString:@"type"] || [key isEqualToString:@"images"]) {
			// not needed, type is always product and "images" will be removed from the API, see image, alternateImages and colors for images
		} else if ([key isEqualToString:@"priceRangeLabel"] || [key isEqualToString:@"salePriceRangeLabel"]) {
			// not needed, use other price labels to create ranges for your UI
		} else if ([key isEqualToString:@"brandedName"] || [key isEqualToString:@"unbrandedName"] || [key isEqualToString:@"badges"]) {
			// not complete on all data so leaving out for now
		} else {
			[self setValue:value forKey:key];
		}
	}
}

- (NSArray *)remoteObjectsForToManyRelationshipNamed:(NSString *)relationshipName fromRepresentations:(NSArray *)representations
{
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[representations count]];
	for (id valueMember in representations) {
		if ([valueMember isKindOfClass:[NSDictionary class]] && [(NSDictionary *)valueMember count] > 0) {
			id remoteObject = [self remoteObjectForRelationshipNamed:relationshipName fromRepresentation:valueMember];
			if (remoteObject != nil) {
				[objects addObject:remoteObject];
			}
		}
	}
	if (objects.count > 0) {
		return objects;
	}
	return nil;
}

- (id<PSSRemoteObject>)remoteObjectForRelationshipNamed:(NSString *)relationshipName fromRepresentation:(NSDictionary *)representation
{
	if ([relationshipName isEqualToString:@"brand"]) {
		return [PSSBrand instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"categories"]) {
		return [PSSProductCategory instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"colors"]) {
		return [PSSProductColor instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"image"]) {
		return [PSSProductImage instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"retailer"]) {
		return [PSSRetailer instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"sizes"]) {
		return [PSSProductSize instanceFromRemoteRepresentation:representation];
	}
	return nil;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.brand forKey:@"brand"];
	[encoder encodeObject:self.categories forKey:@"categories"];
	[encoder encodeObject:self.buyURL forKey:@"buyURL"];
	[encoder encodeObject:self.productPageURL forKey:@"productPageURL"];
	[encoder encodeObject:self.colors forKey:@"colors"];
	[encoder encodeObject:self.currency forKey:@"currency"];
	[encoder encodeObject:self.descriptionHTML forKey:@"descriptionHTML"];
	[encoder encodeObject:self.extractDate forKey:@"extractDate"];
	[encoder encodeObject:self.image forKey:@"image"];
	[encoder encodeObject:self.alternateImages forKey:@"alternateImages"];
	[encoder encodeBool:self.inStock forKey:@"inStock"];
	[encoder encodeObject:self.localeIdentifier forKey:@"localeIdentifier"];
	[encoder encodeObject:self.maxRegularPrice forKey:@"maxRegularPrice"];
	[encoder encodeObject:self.maxRegularPriceLabel forKey:@"maxRegularPriceLabel"];
	[encoder encodeObject:self.maxSalePrice forKey:@"maxSalePrice"];
	[encoder encodeObject:self.maxSalePriceLabel forKey:@"maxSalePriceLabel"];
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.regularPrice forKey:@"price"];
	[encoder encodeObject:self.regularPriceLabel forKey:@"regularPriceLabel"];
	[encoder encodeObject:self.productID forKey:@"productID"];
	[encoder encodeObject:self.retailer forKey:@"retailer"];
	[encoder encodeObject:self.salePrice forKey:@"salePrice"];
	[encoder encodeObject:self.salePriceLabel forKey:@"salePriceLabel"];
	[encoder encodeObject:self.seeMoreLabel forKey:@"seeMoreLabel"];
	[encoder encodeObject:self.seeMoreURL forKey:@"seeMoreURL"];
	[encoder encodeObject:self.sizes forKey:@"sizes"];
	[encoder encodeObject:self.nativeCurrency forKey:@"nativeCurrency"];
	[encoder encodeObject:self.nativePriceLabel forKey:@"nativePriceLabel"];
	[encoder encodeObject:self.nativePrice forKey:@"nativePrice"];
	[encoder encodeObject:self.nativeMaxPriceLabel forKey:@"nativeMaxPriceLabel"];
	[encoder encodeObject:self.nativeMaxPrice forKey:@"nativeMaxPrice"];
	[encoder encodeObject:self.nativeSalePriceLabel forKey:@"nativeSalePriceLabel"];
	[encoder encodeObject:self.nativeSalePrice forKey:@"nativeSalePrice"];
	[encoder encodeObject:self.nativeMaxSalePriceLabel forKey:@"nativeMaxSalePriceLabel"];
	[encoder encodeObject:self.nativeMaxSalePrice forKey:@"nativeMaxSalePrice"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [self init])) {
		self.brand = [decoder decodeObjectForKey:@"brand"];
		self.categories = [decoder decodeObjectForKey:@"categories"];
		self.buyURL = [decoder decodeObjectForKey:@"buyURL"];
		self.productPageURL = [decoder decodeObjectForKey:@"productPageURL"];
		self.colors = [decoder decodeObjectForKey:@"colors"];
		self.currency = [decoder decodeObjectForKey:@"currency"];
		self.descriptionHTML = [decoder decodeObjectForKey:@"descriptionHTML"];
		self.extractDate = [decoder decodeObjectForKey:@"extractDate"];
		self.image = [decoder decodeObjectForKey:@"image"];
		self.alternateImages = [decoder decodeObjectForKey:@"alternateImages"];
		self.inStock = [decoder decodeBoolForKey:@"inStock"];
		self.localeIdentifier = [decoder decodeObjectForKey:@"localeIdentifier"];
		self.maxRegularPrice = [decoder decodeObjectForKey:@"maxRegularPrice"];
		self.maxRegularPriceLabel = [decoder decodeObjectForKey:@"maxRegularPriceLabel"];
		self.maxSalePrice = [decoder decodeObjectForKey:@"maxSalePrice"];
		self.maxSalePriceLabel = [decoder decodeObjectForKey:@"maxSalePriceLabel"];
		self.name = [decoder decodeObjectForKey:@"name"];
		self.regularPrice = [decoder decodeObjectForKey:@"regularPrice"];
		self.regularPriceLabel = [decoder decodeObjectForKey:@"regularPriceLabel"];
		self.productID = [decoder decodeObjectForKey:@"productID"];
		self.retailer = [decoder decodeObjectForKey:@"retailer"];
		self.salePrice = [decoder decodeObjectForKey:@"salePrice"];
		self.salePriceLabel = [decoder decodeObjectForKey:@"salePriceLabel"];
		self.seeMoreLabel = [decoder decodeObjectForKey:@"seeMoreLabel"];
		self.seeMoreURL = [decoder decodeObjectForKey:@"seeMoreURL"];
		self.sizes = [decoder decodeObjectForKey:@"sizes"];
		self.nativeCurrency = [decoder decodeObjectForKey:@"nativeCurrency"];
		self.nativePriceLabel = [decoder decodeObjectForKey:@"nativePriceLabel"];
		self.nativePrice = [decoder decodeObjectForKey:@"nativePrice"];
		self.nativeMaxPriceLabel = [decoder decodeObjectForKey:@"nativeMaxPriceLabel"];
		self.nativeMaxPrice = [decoder decodeObjectForKey:@"nativeMaxPrice"];
		self.nativeSalePriceLabel = [decoder decodeObjectForKey:@"nativeSalePriceLabel"];
		self.nativeSalePrice = [decoder decodeObjectForKey:@"nativeSalePrice"];
		self.nativeMaxSalePriceLabel = [decoder decodeObjectForKey:@"nativeMaxSalePriceLabel"];
		self.nativeMaxSalePrice = [decoder decodeObjectForKey:@"nativeMaxSalePrice"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.productID = self.productID;
	copy.name = self.name;
	copy.descriptionHTML = self.descriptionHTML;
	copy.buyURL = self.buyURL;
	copy.productPageURL = self.productPageURL;
	copy.regularPriceLabel = self.regularPriceLabel;
	copy.regularPrice = self.regularPrice;
	copy.maxRegularPriceLabel = self.maxRegularPriceLabel;
	copy.maxRegularPrice = self.maxRegularPrice;
	copy.salePriceLabel = self.salePriceLabel;
	copy.salePrice = self.salePrice;
	copy.maxSalePriceLabel = self.maxSalePriceLabel;
	copy.maxSalePrice = self.maxSalePrice;
	copy.currency = self.currency;
	copy.brand = [self.brand copyWithZone:zone];
	copy.retailer = [self.retailer copyWithZone:zone];
	copy.seeMoreLabel = self.seeMoreLabel;
	copy.seeMoreURL = self.seeMoreURL;
	copy.categories = self.categories;
	copy.localeIdentifier = self.localeIdentifier;
	copy.colors = self.colors;
	copy.sizes = self.sizes;
	copy.inStock = self.inStock;
	copy.extractDate = self.extractDate;
	copy.image = [self.image copyWithZone:zone];
	copy.alternateImages = self.alternateImages;
	copy.nativeCurrency = self.nativeCurrency;
	copy.nativePriceLabel = self.nativePriceLabel;
	copy.nativePrice = self.nativePrice;
	copy.nativeMaxPriceLabel = self.nativeMaxPriceLabel;
	copy.nativeMaxPrice = self.nativeMaxPrice;
	copy.nativeSalePriceLabel = self.nativeSalePriceLabel;
	copy.nativeSalePrice = self.nativeSalePrice;
	copy.nativeMaxSalePriceLabel = self.nativeMaxSalePriceLabel;
	copy.nativeMaxSalePrice = self.nativeMaxSalePrice;
	return copy;
}

@end
