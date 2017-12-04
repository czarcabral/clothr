//
//  PSSProductCategory.m
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

#import "PSSProductCategory.h"
#import "POPSUGARShopSense.h"

@interface PSSProductCategory ()

@property (nonatomic, copy, readwrite) NSString *categoryID;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *shortName;
@property (nonatomic, copy, readwrite) NSString *localizedCategoryID;

@end

@implementation PSSProductCategory

#pragma mark - Short Name

- (NSString *)shortName
{
	if (_shortName) {
		return _shortName;
	}
	return self.name;
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.categoryID];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSSDLog(@"Warning: Undefined Key Named '%@' with value: %@", key, [value description]);
}

- (NSUInteger)hash
{
	return self.categoryID.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.categoryID isEqualToString:[(PSSProductCategory *)object categoryID]]);
}

#pragma mark - PSSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSProductCategory *instance = [[[self class] alloc] init];
	[instance setPropertiesWithDictionary:representation];
	if (instance.categoryID == nil) {
		return nil;
	}
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"id"]) {
			self.categoryID = [value description];
		} else if ([key isEqualToString:@"localizedId"]) {
			self.localizedCategoryID = [value description];
		} else {
			[self setValue:value forKey:key];
		}
	}
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.categoryID forKey:@"categoryID"];
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.shortName forKey:@"shortName"];
	[encoder encodeObject:self.localizedCategoryID forKey:@"localizedCategoryID"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [self init])) {
		self.categoryID = [decoder decodeObjectForKey:@"categoryID"];
		self.name = [decoder decodeObjectForKey:@"name"];
		self.shortName = [decoder decodeObjectForKey:@"shortName"];
		self.localizedCategoryID = [decoder decodeObjectForKey:@"localizedCategoryID"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.categoryID = self.categoryID;
	copy.name = self.name;
	copy.shortName = self.shortName;
	copy.localizedCategoryID = self.localizedCategoryID;
	return copy;
}

@end
