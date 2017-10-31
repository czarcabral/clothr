//
//  PSSBrand.m
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

#import "PSSBrand.h"
#import "POPSUGARShopSense.h"

@interface PSSBrand ()

@property (nonatomic, copy, readwrite) NSNumber *brandID;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSArray *nameSynonyms;

@end

@implementation PSSBrand

- (id)init
{
	self = [super init];
	if (self) {
		_nameSynonyms = [NSArray new];
	}
	return self;
}

#pragma mark - Product Filter

- (PSSProductFilter *)productFilter
{
	PSSProductFilter *filter = [PSSProductFilter filterWithType:PSSProductFilterTypeBrand filterID:self.brandID];
	filter.name = self.name;
	return filter;
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.brandID];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSSDLog(@"Warning: Undefined Key Named '%@' with value: %@", key, [value description]);
}

- (NSUInteger)hash
{
	return self.brandID.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.brandID isEqualToNumber:[(PSSBrand *)object brandID]]);
}

#pragma mark - PSSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSBrand *instance = [[[self class] alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"id"]) {
			if ([value isKindOfClass:[NSNumber class]]) {
				self.brandID = value;
			} else if ([value isKindOfClass:[NSString class]]) {
				self.brandID = @([value integerValue]);
			}
		} else if ([key isEqualToString:@"url"]) {
			// ignore browse URLs
		} else if ([key isEqualToString:@"synonyms"]) {
			if ([value isKindOfClass:[NSArray class]]) {
				self.nameSynonyms = value;
			} else if ([value isKindOfClass:[NSString class]]) {
				self.nameSynonyms = @[ value ];
			}
		} else {
			[self setValue:value forKey:key];
		}
	}
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.brandID forKey:@"brandID"];
	[encoder encodeObject:self.nameSynonyms forKey:@"nameSynonyms"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [self init])) {
		self.name = [decoder decodeObjectForKey:@"name"];
		self.brandID = [decoder decodeObjectForKey:@"brandID"];
		self.nameSynonyms = [decoder decodeObjectForKey:@"nameSynonyms"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.brandID = self.brandID;
	copy.name = self.name;
	copy.nameSynonyms = self.nameSynonyms;
	return copy;
}

@end
