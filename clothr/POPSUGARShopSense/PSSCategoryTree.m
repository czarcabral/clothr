//
//  PSSCategoryTree.m
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

#import "PSSCategoryTree.h"
#import "PSSCategory.h"

@interface PSSCategory (PRIVATE_CATEGORY_EXT)

- (NSMutableOrderedSet *)mutableChildCategorySet;
- (NSString *)parentCategoryID;

@end

@interface PSSCategoryTree ()

@property (nonatomic, strong) NSMutableDictionary *categoryIDMap;
@property (nonatomic, strong, readwrite) PSSCategory *rootCategory;

@end

@implementation PSSCategoryTree

- (id)initWithRootID:(NSString *)rootCategoryID categories:(NSArray *)categories
{
	self = [self init];
	if (self) {
		NSMutableDictionary *mutableCategoryIDMap = [[NSMutableDictionary alloc] initWithCapacity:categories.count];
		for (PSSCategory *category in categories) {
			mutableCategoryIDMap[category.categoryID] = category;
			if ([category.categoryID isEqualToString:rootCategoryID]) {
				_rootCategory = category;
			}
		}
		for (PSSCategory *category in categories) {
			if (category.parentCategoryID != nil) {
				PSSCategory *parent = mutableCategoryIDMap[category.parentCategoryID];
				if (parent != nil) {
					[parent.mutableChildCategorySet addObject:category];
				}
			}
		}
		_categoryIDMap = mutableCategoryIDMap;
	}
	return self;
}

- (NSArray *)allCategories
{
	return self.categoryIDMap.allValues;
}

- (PSSCategory *)categoryWithID:(NSString *)categoryID
{
	return self.categoryIDMap[categoryID];
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" Root:%@", self.rootCategory.categoryID];
}

- (NSUInteger)hash
{
	return self.categoryIDMap.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.categoryIDMap isEqualToDictionary:[(PSSCategoryTree *)object categoryIDMap]]);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.categoryIDMap forKey:@"categoryIDMap"];
	[encoder encodeObject:self.rootCategory forKey:@"rootCategory"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [self init])) {
		self.categoryIDMap = [decoder decodeObjectForKey:@"categoryIDMap"];
		self.rootCategory = [decoder decodeObjectForKey:@"rootCategory"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.categoryIDMap = [self.categoryIDMap mutableCopyWithZone:zone];
	copy.rootCategory = [self.rootCategory copyWithZone:zone];
	return copy;
}

@end
