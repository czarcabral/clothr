//
//  PSSProductImage.m
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

#import "PSSProductImage.h"
#import "POPSUGARShopSense.h"

static NSString * const kOriginalImageURLKey = @"Original";

NSString * const PSSProductImageSizeSmall = @"Small";
NSString * const PSSProductImageSizeIPhoneSmall = @"IPhoneSmall";
NSString * const PSSProductImageSizeMedium = @"Medium";
NSString * const PSSProductImageSizeLarge = @"Large";
NSString * const PSSProductImageSizeIPhone = @"IPhone";

@interface PSSProductImage ()

@property (nonatomic, copy, readwrite) NSString *imageID;
@property (nonatomic, copy, readwrite) NSURL *URL;
@property (nonatomic, strong) NSMutableDictionary *imageURLsBySizeName;

@end

CGSize CGSizeFromPSSProductImageSize(NSString *size)
{
	if ([size isEqualToString:PSSProductImageSizeSmall]) {
		return CGSizeMake(32, 40);
	} else if ([size isEqualToString:PSSProductImageSizeIPhoneSmall]) {
		return CGSizeMake(100, 125);
	} else if ([size isEqualToString:PSSProductImageSizeMedium]) {
		return CGSizeMake(112, 140);
	} else if ([size isEqualToString:PSSProductImageSizeLarge]) {
		return CGSizeMake(164, 205);
	} else if ([size isEqualToString:PSSProductImageSizeIPhone]) {
		return CGSizeMake(288, 360);
	}
	return CGSizeZero;
}

@implementation PSSProductImage

#pragma mark - Resized Images

- (NSMutableDictionary *)imageURLsBySizeName
{
	if (_imageURLsBySizeName == nil) {
		_imageURLsBySizeName = [[NSMutableDictionary alloc] init];
	}
	return _imageURLsBySizeName;
}

- (NSURL *)imageURLWithSize:(NSString *)size
{
	return self.imageURLsBySizeName[size];
}

#pragma mark - Product Image Helpers

- (NSArray *)orderedImageSizeNames
{
	return @[ PSSProductImageSizeSmall,
		   PSSProductImageSizeIPhoneSmall,
		   PSSProductImageSizeMedium,
		   PSSProductImageSizeLarge,
		   PSSProductImageSizeIPhone ];
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.imageID, self.URL.absoluteString];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSSDLog(@"Warning: Undefined Key Named '%@' with value: %@", key, [value description]);
}

- (NSUInteger)hash
{
	return self.imageID.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.imageID isEqualToString:[(PSSProductImage *)object imageID]]);
}

#pragma mark - PSSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSProductImage *instance = [[[self class] alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"id"]) {
			if ([value isKindOfClass:[NSString class]]) {
				self.imageID = [value description];
			}
		} else if ([key isEqualToString:@"sizes"]) {
			if ([value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
				NSDictionary *imageURLData = value;
				id originalData = [imageURLData valueForKey:kOriginalImageURLKey];
				if ([originalData isKindOfClass:[NSDictionary class]] && [(NSDictionary *)originalData count] > 0) {
					self.URL = [self imageURLFromRepresentation:originalData];
				}
				for (NSString *sizeName in [self orderedImageSizeNames]) {
					id sizeData = [imageURLData valueForKey:sizeName];
					if ([sizeData isKindOfClass:[NSDictionary class]] && [(NSDictionary *)sizeData count] > 0) {
						NSURL *sizeURL = [self imageURLFromRepresentation:sizeData];
						if (sizeURL != nil) {
							[self.imageURLsBySizeName setValue:sizeURL forKey:sizeName];
						}
					}
				}
			}
		} else {
			[self setValue:value forKey:key];
		}
	}
}

- (NSURL *)imageURLFromRepresentation:(NSDictionary *)representation
{
	NSURL *imageURL = nil;
	id imageURLString = representation[@"url"];
	if ([imageURLString isKindOfClass:[NSString class]]) {
		imageURL = [NSURL URLWithString:imageURLString];
	}
	return imageURL;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.imageURLsBySizeName forKey:@"imageURLsBySizeName"];
	[encoder encodeObject:self.URL forKey:@"URL"];
	[encoder encodeObject:self.imageID forKey:@"imageID"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [self init])) {
		self.imageURLsBySizeName = [decoder decodeObjectForKey:@"imageURLsBySizeName"];
		self.URL = [decoder decodeObjectForKey:@"URL"];
		self.imageID = [decoder decodeObjectForKey:@"imageID"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.imageID = self.imageID;
	copy.URL = self.URL;
	copy.imageURLsBySizeName = [self.imageURLsBySizeName mutableCopyWithZone:zone];
	return copy;
}

@end
