//
//  PSSCategory.m
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

#import "PSSCategory.h"


@interface PSSProductCategory (PRIVATE_CATEGORY_EXT)

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary;

@end

static NSString * const kParentCategoryIDKey = @"parentId";

@interface PSSCategory ()

@property (nonatomic, strong) NSMutableOrderedSet *mutableChildCategorySet;
@property (nonatomic, copy, readwrite) NSString *parentCategoryID;
@property (nonatomic, assign, readwrite) BOOL hasSizeFilter;
@property (nonatomic, assign, readwrite) BOOL hasColorFilter;
@property (nonatomic, assign, readwrite) BOOL hasHeelHeightFilter;

@end

@implementation PSSCategory

- (NSArray *)childCategories
{
	return [self.mutableChildCategorySet array];
}

- (NSMutableOrderedSet *)mutableChildCategorySet
{
	if (_mutableChildCategorySet != nil) {
		return _mutableChildCategorySet;
	}
	_mutableChildCategorySet = [[NSMutableOrderedSet alloc] init];
	return _mutableChildCategorySet;
}

#pragma mark - PSSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSCategory *instance = [[[self class] alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	NSMutableDictionary *copyDictionary = [aDictionary mutableCopy];
	if (copyDictionary[kParentCategoryIDKey] != nil) {
		self.parentCategoryID = copyDictionary[kParentCategoryIDKey];
		[copyDictionary removeObjectForKey:kParentCategoryIDKey];
	}
	[super setPropertiesWithDictionary:copyDictionary];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[super encodeWithCoder:encoder];
	[encoder encodeObject:self.parentCategoryID forKey:@"parentCategoryID"];
	[encoder encodeObject:self.mutableChildCategorySet forKey:@"mutableChildCategorySet"];
	[encoder encodeBool:self.hasColorFilter forKey:@"hasColorFilter"];
	[encoder encodeBool:self.hasSizeFilter forKey:@"hasSizeFilter"];
	[encoder encodeBool:self.hasHeelHeightFilter forKey:@"hasHeelHeightFilter"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder])) {
		self.parentCategoryID = [decoder decodeObjectForKey:@"parentCategoryID"];
		self.mutableChildCategorySet = [decoder decodeObjectForKey:@"mutableChildCategorySet"];
		self.hasColorFilter = [decoder decodeBoolForKey:@"hasColorFilter"];
		self.hasSizeFilter = [decoder decodeBoolForKey:@"hasSizeFilter"];
		self.hasHeelHeightFilter = [decoder decodeBoolForKey:@"hasHeelHeightFilter"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [super copyWithZone:zone];
	copy.parentCategoryID = self.parentCategoryID;
	copy.mutableChildCategorySet = [self.mutableChildCategorySet mutableCopyWithZone:zone];
	copy.hasColorFilter = self.hasColorFilter;
	copy.hasSizeFilter = self.hasSizeFilter;
	copy.hasHeelHeightFilter = self.hasHeelHeightFilter;
	return copy;
}

@end
