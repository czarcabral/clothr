//
//  PSSProductColor.m
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

#import "PSSProductColor.h"
#import "POPSUGARShopSense.h"
#import "PSSProductImage.h"

@interface PSSProductColor ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) PSSProductImage *image;
@property (nonatomic, copy, readwrite) NSArray *canonicalColors;
@property (nonatomic, copy, readwrite) NSURL *swatchURL;

@end

@implementation PSSProductColor

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@", self.name];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSSDLog(@"Warning: Undefined Key Named '%@' with value: %@", key, [value description]);
}

- (NSUInteger)hash
{
	return self.name.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.name isEqualToString:[(PSSProductColor *)object name]]);
}

#pragma mark - PSSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSProductColor *instance = [[[self class] alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"image"]) {
			if ([value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
				self.image = (PSSProductImage *)[self remoteObjectForRelationshipNamed:@"image" fromRepresentation:value];
			}
		} else if ([key isEqualToString:@"swatchUrl"]) {
			self.swatchURL = [NSURL URLWithString:[value description]];
		} else if ([key isEqualToString:@"canonicalColors"]) {
			if ([value isKindOfClass:[NSArray class]]) {
				NSArray *canonicalColors = value;
				if (canonicalColors.count > 0) {
					NSMutableArray *colors = [NSMutableArray new];
					for (id canonicalColor in canonicalColors) {
						id color = [self remoteObjectForRelationshipNamed:@"color" fromRepresentation:canonicalColor];
						if (color != nil) {
							[colors addObject:color];
						}
					}
					if (colors.count > 0) {
						self.canonicalColors = [colors copy];
					}
				}
			}
		} else {
			[self setValue:value forKey:key];
		}
	}
}

- (id<PSSRemoteObject>)remoteObjectForRelationshipNamed:(NSString *)relationshipName fromRepresentation:(NSDictionary *)representation
{
	if ([relationshipName isEqualToString:@"image"]) {
		return [PSSProductImage instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"color"]) {
		return [PSSColor instanceFromRemoteRepresentation:representation];
	}
	return nil;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.image forKey:@"image"];
	[encoder encodeObject:self.canonicalColors forKey:@"canonicalColors"];
	[encoder encodeObject:self.swatchURL forKey:@"swatchURL"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [self init])) {
		self.name = [decoder decodeObjectForKey:@"name"];
		self.image = [decoder decodeObjectForKey:@"image"];
		self.canonicalColors = [decoder decodeObjectForKey:@"canonicalColors"];
		self.swatchURL = [decoder decodeObjectForKey:@"swatchURL"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.name = self.name;
	copy.image = [self.image copyWithZone:zone];
	copy.canonicalColors = self.canonicalColors;
	copy.swatchURL = self.swatchURL;
	return copy;
}

@end
