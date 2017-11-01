//
//  PSSColor.m
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

#import "PSSColor.h"
#import "POPSUGARShopSense.h"

@interface PSSColor ()

@property (nonatomic, copy, readwrite) NSNumber *colorID;
@property (nonatomic, copy, readwrite) NSString *name;

@end

@implementation PSSColor

#pragma mark - Product Filter

- (PSSProductFilter *)productFilter
{
	PSSProductFilter *filter = [PSSProductFilter filterWithType:PSSProductFilterTypeColor filterID:self.colorID];
	filter.name = self.name;
	return filter;
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.colorID];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSSDLog(@"Warning: Undefined Key Named '%@' with value: %@", key, [value description]);
}

- (NSUInteger)hash
{
	return self.colorID.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.colorID isEqualToNumber:[(PSSColor *)object colorID]]);
}

#pragma mark - PSSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSColor *instance = [[[self class] alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"id"]) {
			if ([value isKindOfClass:[NSNumber class]]) {
				self.colorID = value;
			} else if ([value isKindOfClass:[NSString class]]) {
				self.colorID = @([value integerValue]);
			}
		} else if ([key isEqualToString:@"url"]) {
			// ignore browse URLs
		} else {
			[self setValue:value forKey:key];
		}
	}
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.colorID forKey:@"colorID"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [self init])) {
		self.name = [decoder decodeObjectForKey:@"name"];
		self.colorID = [decoder decodeObjectForKey:@"colorID"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.colorID = self.colorID;
	copy.name = self.name;
	return copy;
}

@end
