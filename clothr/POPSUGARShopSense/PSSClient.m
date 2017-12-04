//
//  PSSClient.m
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

#import "PSSClient.h"
#import "AFJSONRequestOperation.h"
#import "POPSUGARShopSense.h"
#import <time.h>
#import <xlocale.h>

// Exceptions and Error Domains
NSString * const PSSInvalidPartnerException = @"com.shopstyle.shopsense:InvalidPartnerException";
NSString * const PSSInvalidLocaleException = @"com.shopstyle.shopsense:InvalidLocaleException";
NSString * const PSSMalformedResponseErrorDomain = @"com.shopstyle.shopsense:MalformedResponseError";
NSString * const PSSInvalidRepresentationErrorDomain = @"com.shopstyle.shopsense:InvalidRepresentationError";
NSString * const PSSServerResponseErrorDomain = @"com.shopstyle.shopsense:ServerResponseError";

// Histogram Types
NSString * const PSSProductHistogramTypeBrand = @"Brand";
NSString * const PSSProductHistogramTypeRetailer = @"Retailer";
NSString * const PSSProductHistogramTypePrice = @"Price";
NSString * const PSSProductHistogramTypeDiscount = @"Discount";
NSString * const PSSProductHistogramTypeSize = @"Size";
NSString * const PSSProductHistogramTypeHeelHeight = @"HeelHeight";
NSString * const PSSProductHistogramTypeColor = @"Color";

static NSString * const kShopSenseBaseURLString = @"http://api.shopstyle.com/api/v2/";
static NSString * const kPListPartnerIDKey = @"ShopSensePartnerID";
static NSString * const kDefaultLocaleIdentifier = @"en_US";
static NSString * const kUSLocaleIdentifier = @"en_US";
static NSString * const kUSSiteIdentifier = @"www.shopstyle.com";
static NSString * const kUKLocaleIdentifier = @"en_GB";
static NSString * const kUKSiteIdentifier = @"www.shopstyle.co.uk";
static NSString * const kFRLocaleIdentifier = @"fr_FR";
static NSString * const kFRSiteIdentifier = @"www.shopstyle.fr";
static NSString * const kDELocaleIdentifier = @"de_DE";
static NSString * const kDESiteIdentifier = @"www.shopstyle.de";
static NSString * const kJPLocaleIdentifier = @"ja_JP";
static NSString * const kJPSiteIdentifier = @"www.shopstyle.co.jp";
static NSString * const kAULocaleIdentifier = @"en_AU";
static NSString * const kAUSiteIdentifier = @"www.shopstyle.com.au";
static NSString * const kCALocaleIdentifier = @"en_CA";
static NSString * const kCASiteIdentifier = @"www.shopstyle.ca";

@interface PSSClient ()

@property (nonatomic, copy, readwrite) NSLocale *currentLocale;

@end

@implementation PSSClient

#pragma mark - Default Base URL

+ (NSURL *)defaultBaseURL
{
	return [NSURL URLWithString:kShopSenseBaseURLString];
}

#pragma mark - Shared Client

static id _sharedClient = nil;
static dispatch_once_t once_token = 0;

+ (instancetype)sharedClient
{
	dispatch_once(&once_token, ^{
		if (_sharedClient == nil) {
			NSURL *baseURL = [self defaultBaseURL];
#ifdef _POPSUGARShopSense_BASE_URL_
			NSURL *definedBaseURL = [NSURL URLWithString:_POPSUGARShopSense_BASE_URL_];
			if (definedBaseURL != nil) {
				baseURL = definedBaseURL;
			}
#endif
			_sharedClient = [[[self class] alloc] initWithBaseURL:baseURL];
		}
	});
	return _sharedClient;
}

+ (void)setSharedClient:(PSSClient *)client
{
	once_token = 0; // resets the once_token so dispatch_once will run again
	_sharedClient = client;
}

#pragma mark - AFHTTPClient Setup Overrides

- (id)initWithBaseURL:(NSURL *)url
{
	self = [super initWithBaseURL:url];
	if (!self) {
		return nil;
	}
	[self sharedInit];
	return self;
}

- (void)sharedInit
{
	[self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
	self.parameterEncoding = AFJSONParameterEncoding;
	[self setDefaultHeader:@"Accept-Encoding" value:@"gzip, deflate"];
	[self setDefaultHeader:@"ShopSense-Client" value:NSStringFromClass([self class])];
	_currentLocale = [[self class] defaultLocale];
}

- (NSString *)description
{
	NSString *superString = [super description];
	return [superString stringByReplacingCharactersInRange:NSMakeRange(superString.length - 1, 1) withString:[NSString stringWithFormat:@", partnerID: %@, currentLocal: %@>", self.partnerID, self.currentLocale.localeIdentifier]];
}

#pragma mark - Locales

+ (NSLocale *)defaultLocale
{
	return [[NSLocale alloc] initWithLocaleIdentifier:kDefaultLocaleIdentifier];
}

+ (NSArray *)supportedLocales
{
	return @[ [[NSLocale alloc] initWithLocaleIdentifier:kUSLocaleIdentifier],
			  [[NSLocale alloc] initWithLocaleIdentifier:kUKLocaleIdentifier],
			  [[NSLocale alloc] initWithLocaleIdentifier:kFRLocaleIdentifier],
			  [[NSLocale alloc] initWithLocaleIdentifier:kDELocaleIdentifier],
			  [[NSLocale alloc] initWithLocaleIdentifier:kJPLocaleIdentifier],
			  [[NSLocale alloc] initWithLocaleIdentifier:kAULocaleIdentifier],
			  [[NSLocale alloc] initWithLocaleIdentifier:kCALocaleIdentifier] ];
}

+ (BOOL)isSupportedLocale:(NSLocale *)locale
{
	if (locale == nil) {
		return NO;
	}
	// we needed to test localeIdentifier because the incoming locale could be a different class such as NSCFLocale
	if ([[[self supportedLocales] valueForKey:@"localeIdentifier" ] indexOfObject:locale.localeIdentifier] != NSNotFound) {
		return YES;
	}
	return NO;
}

+ (NSLocale *)supportedLocaleForLocale:(NSLocale *)locale
{
	if (locale == nil) {
		return [self defaultLocale];
	}
	
	// It's best to loop over our supported locales and return one of those here because the incoming locale could actually be a different class such as NSCFLocale
	for (NSLocale *supportedLocale in [self supportedLocales]) {
		if ([supportedLocale.localeIdentifier isEqualToString:locale.localeIdentifier]) {
			return supportedLocale;
		}
	}
	
	// we prefer the default locale if the language matches
	NSString *language = [locale objectForKey:NSLocaleLanguageCode];
	if ([[[self defaultLocale] objectForKey:NSLocaleLanguageCode] isEqualToString:language]) {
		return [self defaultLocale];
	}
	for (NSLocale *supportedLocale in [self supportedLocales]) {
		if ([[supportedLocale objectForKey:NSLocaleLanguageCode] isEqualToString:language]) {
			return supportedLocale;
		}
	}
	return [self defaultLocale];
}

+ (NSString *)siteIdentifierForLocale:(NSLocale *)locale
{
	if (locale == nil) {
		return nil;
	}
	if ([locale.localeIdentifier isEqualToString:kUSLocaleIdentifier]) {
		return kUSSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kUKLocaleIdentifier]) {
		return kUKSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kFRLocaleIdentifier]) {
		return kFRSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kDELocaleIdentifier]) {
		return kDESiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kJPLocaleIdentifier]) {
		return kJPSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kAULocaleIdentifier]) {
		return kAUSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kCALocaleIdentifier]) {
		return kCASiteIdentifier;
	}
	return nil;
}

- (void)setLocale:(NSLocale *)newLocale cancelAllOperations:(BOOL)cancelAllOperations
{
	NSParameterAssert(newLocale != nil);
	if ([[self class] isSupportedLocale:newLocale] == NO) {
		[[NSException exceptionWithName:PSSInvalidLocaleException
								 reason:@"Locale must be one of supportedLocales."
							   userInfo:@{ @"invalidLocale": [newLocale description] }] raise];
	}
	self.currentLocale = newLocale;
	if (cancelAllOperations) {
		[self.operationQueue cancelAllOperations];
	}
}

#pragma mark - BrowseURLs

+ (NSURL *)siteURLForLocale:(NSLocale *)locale
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", ([self siteIdentifierForLocale:locale] ?: kUSLocaleIdentifier)]];
}

- (NSURL *)browseURLForCategoryID:(NSString *)categoryIDOrNil productFilter:(PSSProductFilter *)productFilterOrNil
{
	NSMutableDictionary *params = [NSMutableDictionary new];
	if (categoryIDOrNil.length > 0) {
		params[@"cat"] = categoryIDOrNil;
	}
	if (productFilterOrNil != nil) {
		params[@"fl"] = productFilterOrNil.queryParameterRepresentation;
	}
	return [self browseURLWithParams:params];
}

- (NSURL *)browseURLForProductQuery:(PSSProductQuery *)productQuery
{
	NSParameterAssert(productQuery);
	return [self browseURLWithParams:productQuery.queryParameterRepresentation];
}

- (NSURL *)browseURLWithParams:(NSDictionary *)params
{
	NSString *siteURLString = [[[self class] siteURLForLocale:self.currentLocale] absoluteString];
	NSString *pidParam = [NSString stringWithFormat:@"pid=%@", [self.partnerID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableString *browseURLString = [NSMutableString stringWithFormat:@"%@/browse?%@", siteURLString, pidParam];
	if (params.count > 0) {
		NSString *paramString = AFQueryStringFromParametersWithEncoding(params, self.stringEncoding);
		for (NSString *key in params.allKeys) {
			if ([params[key] isKindOfClass:[NSArray class]]) {
				paramString = [paramString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@[]=", key] withString:[key stringByAppendingString:@"="]];
				paramString = [paramString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%%5B%%5D=", key] withString:[key stringByAppendingString:@"="]];
			}
		}
		[browseURLString appendFormat:@"&%@", paramString];
	}
	return [NSURL URLWithString:browseURLString];
}

#pragma mark - partnerID

- (NSString *)partnerID
{
	if (_partnerID == nil) {
		NSBundle *bundle = [NSBundle mainBundle];
		_partnerID = [bundle objectForInfoDictionaryKey:kPListPartnerIDKey];
	}
	return _partnerID;
}

#pragma mark - AFHTTPClient Request/Operation Overrides

- (NSMutableDictionary *)dictionaryWithStandardRequestURLParameters
{
	NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
	mutableParameters[@"pid"] = self.partnerID;
	if ([self.currentLocale isEqual:[[self class] defaultLocale]] == NO && [[self class] siteIdentifierForLocale:self.currentLocale] != nil) {
		mutableParameters[@"site"] = [[self class] siteIdentifierForLocale:self.currentLocale];
	}
	return mutableParameters;
}

- (NSString *)RFC1123StringFromDate:(NSDate *)date
{
	time_t timeInterval = (time_t)[date timeIntervalSince1970];
	struct tm timeinfo;
	gmtime_r(&timeInterval, &timeinfo);
	char buffer[32];
	size_t ret = strftime_l(buffer, sizeof(buffer), "%a, %d %b %Y %H:%M:%S GMT", &timeinfo, NULL);
	if (ret) {
		return @(buffer);
	} else {
		return nil;
	}
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
	if (self.partnerID == nil) {
		[[NSException exceptionWithName:PSSInvalidPartnerException
								 reason:[NSString stringWithFormat:@"%@: No Partner ID provided; either set partnerID or add a string valued key with the appropriate id named %@ to the bundle *.plist", NSStringFromClass([self class]), kPListPartnerIDKey]
							   userInfo:nil] raise];
	}
	
	NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
	
	// Add our URL standard URL params regardless of method
	NSString *urlString = request.URL.absoluteString;
	urlString = [urlString stringByAppendingFormat:[urlString rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", AFQueryStringFromParametersWithEncoding([self dictionaryWithStandardRequestURLParameters], self.stringEncoding)];
	
	// ShopSense does not support the `[]` notation when using multiple same-named URL parameters. This only applies to GET, HEAD and DELETE
	// e.g. AFNetworking will convert multiple `fl=` parameters to `fl[]=` which will be rejected by the server.
	if (([method isEqualToString:@"GET"] || [method isEqualToString:@"HEAD"] || [method isEqualToString:@"DELETE"]) && parameters.count > 0) {
		for (NSString *key in parameters.allKeys) {
			if ([parameters[key] isKindOfClass:[NSArray class]]) {
				urlString = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@[]=", key] withString:[key stringByAppendingString:@"="]];
				urlString = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%%5B%%5D=", key] withString:[key stringByAppendingString:@"="]];
			}
		}
	}
	
	NSURL *newURL = [NSURL URLWithString:urlString];
	if (newURL != nil) {
		request.URL = newURL;
	}
	
	[request setValue:[self RFC1123StringFromDate:[NSDate date]] forHTTPHeaderField:@"Date"];
	
	return request;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	return [super HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			NSError *apiError = [self errorFromResponseErrorRepresentation:(NSDictionary *)responseObject];
			if (apiError != nil) {
				if (failure) {
					failure(operation, apiError);
				}
			} else if (success) {
				success(operation, responseObject);
			}
		} else {
			if (failure) {
				failure(operation, [self errorWithBadResponseString:operation.responseString]);
			}
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (failure) {
			NSError *ssError = nil;
			if (operation.responseString != nil && operation.responseString.length > 0 && operation.responseData != nil) {
				NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
				if (responseDictionary != nil && [responseDictionary isKindOfClass:[NSDictionary class]]) {
					ssError = [self errorFromResponseErrorRepresentation:(NSDictionary *)responseDictionary];
				}
			}
			if (ssError == nil) {
				ssError = error;
			}
			failure(operation, ssError);
		}
	}];
}

#pragma mark - Getting Products

- (void)getProductByID:(NSNumber *)productID success:(void (^)(PSSProduct *product))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSParameterAssert(productID != nil);
	NSString *path = [NSString stringWithFormat:@"products/%@", productID];
	[self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (success) {
			PSSProduct *product = (PSSProduct *)[self remoteObjectForEntityNamed:@"product" fromRepresentation:responseObject];
			success(product);
		}
	} failure:failure];
}

+ (NSMutableArray *)standardFilterTypes
{
	return [@[ PSSProductHistogramTypeBrand, PSSProductFilterTypeRetailer, PSSProductFilterTypeDiscount, PSSProductFilterTypePrice ] mutableCopy];
}

- (void)searchProductsWithQuery:(PSSProductQuery *)queryOrNil offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, NSArray *availableHistogramTypes, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //printf("here");
	NSDictionary *params = nil;
	if (queryOrNil != nil) {
		params = [queryOrNil queryParameterRepresentation];
	}
	[self getProductsWithQueryParams:params offset:offset limit:limit success:success failure:failure];
}

- (void)getProductsWithQueryParams:(NSDictionary *)queryParams offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, NSArray *availableHistogramTypes, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	if (offset != nil) {
		[params setValue:offset forKey:@"offset"];
	}
	if (limit != nil) {
		[params setValue:limit forKey:@"limit"];
	}
	if (queryParams != nil) {
		[params addEntriesFromDictionary:queryParams];
		if ([self.currentLocale.localeIdentifier isEqualToString:kUSLocaleIdentifier]) {
			[params removeObjectForKey:@"locales"];
		}
	}
	if (params.count == 0) {
		params = nil;
	}
	[self getPath:@"products" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		if ([responseObject[@"metadata"] isKindOfClass:[NSDictionary class]] && [responseObject[@"products"] isKindOfClass:[NSArray class]]) {
			
			if (success) {
				NSArray *productsRepresentation = responseObject[@"products"];
				NSArray *products = [self remoteObjectsForEntityNamed:@"product" fromRepresentations:productsRepresentation];
				NSUInteger totalCount = products.count;
				NSDictionary *metadata = responseObject[@"metadata"];
				if ([metadata[@"total"] isKindOfClass:[NSNumber class]]) {
					totalCount = [metadata[@"total"] unsignedIntegerValue];
				}
				NSMutableArray *availableHistogramTypes = [[self class] standardFilterTypes];
				if ([metadata[@"showColorFilter"] isKindOfClass:[NSNumber class]] && [metadata[@"showColorFilter"] boolValue]) {
					[availableHistogramTypes addObject:PSSProductHistogramTypeColor];
				}
				if ([metadata[@"showSizeFilter"] isKindOfClass:[NSNumber class]] && [metadata[@"showSizeFilter"] boolValue]) {
					[availableHistogramTypes addObject:PSSProductHistogramTypeSize];
				}
				if ([metadata[@"showHeelHeightFilter"] isKindOfClass:[NSNumber class]] && [metadata[@"showHeelHeightFilter"] boolValue]) {
					[availableHistogramTypes addObject:PSSProductHistogramTypeHeelHeight];
				}
				success(totalCount, availableHistogramTypes, products);
			}
			
		} else {
			if (failure) {
				failure(operation, [self errorWithInvalidRepresentation:responseObject]);
			}
		}
	} failure:failure];
}

- (NSDictionary *)histogramResponseKeyToFilterTypeMap
{
	return @{ @"brandHistogram": PSSProductFilterTypeBrand, @"retailerHistogram": PSSProductFilterTypeRetailer, @"priceHistogram": PSSProductFilterTypePrice, @"discountHistogram": PSSProductFilterTypeDiscount, @"sizeHistogram": PSSProductFilterTypeSize, @"heelHeightHistogram": PSSProductFilterTypeHeelHeight, @"colorHistogram": PSSProductFilterTypeColor };
}

- (NSDictionary *)histogramResponseKeyToHistogramTypeMap
{
	return @{ @"brandHistogram": PSSProductHistogramTypeBrand, @"retailerHistogram": PSSProductHistogramTypeRetailer, @"priceHistogram": PSSProductHistogramTypePrice, @"discountHistogram": PSSProductHistogramTypeDiscount, @"sizeHistogram": PSSProductHistogramTypeSize, @"heelHeightHistogram": PSSProductHistogramTypeHeelHeight, @"colorHistogram":PSSProductHistogramTypeColor };
}

- (void)productHistogramWithQuery:(PSSProductQuery *)queryOrNil histogramTypes:(NSArray *)histogramTypes floor:(NSNumber *)floorOrNil success:(void (^)(NSUInteger totalCount, NSDictionary *histograms))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	NSMutableArray *histogramResponseKeys = [NSMutableArray array];
	NSMutableArray *histogramTypeParameters = [NSMutableArray array];
	NSDictionary *histogramResponseMap = [self histogramResponseKeyToHistogramTypeMap];
	for (NSString *histogramType in histogramTypes) {
		NSArray *possibleResponseKeys = [histogramResponseMap allKeysForObject:histogramType];
		if (possibleResponseKeys.count > 0) {
			[histogramTypeParameters addObject:histogramType];
			[histogramResponseKeys addObjectsFromArray:possibleResponseKeys];
		}
	}
	NSAssert(histogramTypeParameters.count > 0, @"You must provide at least one histogram type to get a histogram");
	[params setValue:[histogramTypeParameters componentsJoinedByString:@","] forKey:@"filters"];
	
	if (floorOrNil != nil) {
		[params setValue:floorOrNil forKey:@"floor"];
	}
	if (queryOrNil != nil) {
		NSDictionary *queryParams = [queryOrNil queryParameterRepresentation];
		[params addEntriesFromDictionary:queryParams];
	}
	if (params != nil) {
		if ([self.currentLocale.localeIdentifier isEqualToString:kUSLocaleIdentifier]) {
			[params removeObjectForKey:@"locales"];
		}
	}
	[self getPath:@"products/histogram" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSUInteger totalCount = 0;
		if ([responseObject[@"metadata"] isKindOfClass:[NSDictionary class]]) {
			NSDictionary *metadata = responseObject[@"metadata"];
			if ([metadata[@"total"] isKindOfClass:[NSNumber class]]) {
				totalCount = [metadata[@"total"] unsignedIntegerValue];
			}
		}
		NSMutableDictionary *histograms = [NSMutableDictionary dictionary];
		for (NSString *histogramResponseKey in histogramResponseKeys) {
			if ([responseObject[histogramResponseKey] isKindOfClass:[NSArray class]]) {
				NSArray *filtersRepresentations = responseObject[histogramResponseKey];
				NSDictionary *filterTypeMap = [self histogramResponseKeyToFilterTypeMap];
				NSString *filterType = filterTypeMap[histogramResponseKey];
				NSDictionary *histogramTypeMap = [self histogramResponseKeyToHistogramTypeMap];
				NSString *histogramType = histogramTypeMap[histogramResponseKey];
				if (filterType == nil || histogramType == nil) {
					PSSDLog(@"Unknown Histogram Response Key: %@", histogramResponseKey);
				} else {
					NSMutableArray *filters = [NSMutableArray arrayWithCapacity:[filtersRepresentations count]];
					for (id possibleFilterRep in filtersRepresentations) {
						if ([possibleFilterRep isKindOfClass:[NSDictionary class]]) {
							NSMutableDictionary *filterRep = [possibleFilterRep mutableCopy];
							filterRep[@"type"] = filterType;
							id remoteObject = [self remoteObjectForEntityNamed:@"productFilter" fromRepresentation:filterRep];
							if (remoteObject != nil) {
								[filters addObject:remoteObject];
							}
						}
					}
					histograms[histogramType] = filters;
				}
			}
		}
		if (histograms.count > 0) {
			if (success) {
				success(totalCount, histograms);
			}
		} else {
			if (failure) {
				failure(operation, [self errorWithInvalidRepresentation:responseObject]);
			}
		}
	} failure:failure];
}

- (void)productCategoryHistogramWithQuery:(PSSProductQuery *)queryOrNil success:(void (^)(NSUInteger totalCount, NSDictionary *categoryIDCounts))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	params[@"filters"] = @"Category";
	if (queryOrNil != nil) {
		NSDictionary *queryParams = [queryOrNil queryParameterRepresentation];
		[params addEntriesFromDictionary:queryParams];
	}
	if (params != nil) {
		if ([self.currentLocale.localeIdentifier isEqualToString:kUSLocaleIdentifier]) {
			[params removeObjectForKey:@"locales"];
		}
	}
	[self getPath:@"products/histogram" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSUInteger totalCount = 0;
		if ([responseObject[@"metadata"] isKindOfClass:[NSDictionary class]]) {
			NSDictionary *metadata = responseObject[@"metadata"];
			if ([metadata[@"total"] isKindOfClass:[NSNumber class]]) {
				totalCount = [metadata[@"total"] unsignedIntegerValue];
			}
		}
		if ([responseObject[@"categoryHistogram"] isKindOfClass:[NSArray class]]) {
			NSMutableDictionary *catCounts = [NSMutableDictionary dictionary];
			for (NSDictionary *catCount in (NSArray *)responseObject[@"categoryHistogram"]) {
				NSString *catID = [catCount[@"id"] description];
				id count = catCount[@"count"];
				if (catID.length > 0 && count != nil) {
					if ([count isKindOfClass:[NSNumber class]]) {
						catCounts[catID] = count;
					} else if ([count isKindOfClass:[NSString class]]) {
						catCounts[catID] = @([count integerValue]);
					}
				}
			}
			if (success) {
				success(totalCount, catCounts);
			}
		} else {
			if (failure) {
				failure(operation, [self errorWithInvalidRepresentation:responseObject]);
			}
		}
	} failure:failure];
}

#pragma mark - Sizes

- (void)getSizesSuccess:(void (^)(NSArray *brands))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:@"sizes" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"sizes"] isKindOfClass:[NSArray class]]) {
            if (success) {
                NSArray *sizesRepresentation = responseObject[@"sizes"];
                NSArray *sizes = [self remoteObjectsForEntityNamed:@"size" fromRepresentations:sizesRepresentation];
                success(sizes);
            }
        } else {
            if (failure) {
                failure(operation, [self errorWithInvalidRepresentation:responseObject]);
            }
        }
    } failure:failure];
}

#pragma mark - Brands

- (void)getBrandsSuccess:(void (^)(NSArray *brands))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[self getPath:@"brands" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if ([responseObject[@"brands"] isKindOfClass:[NSArray class]]) {
			if (success) {
				NSArray *brandsRepresentation = responseObject[@"brands"];
				NSArray *brands = [self remoteObjectsForEntityNamed:@"brand" fromRepresentations:brandsRepresentation];
				success(brands);
			}
		} else {
			if (failure) {
				failure(operation, [self errorWithInvalidRepresentation:responseObject]);
			}
		}
	} failure:failure];
}

#pragma mark - Retailers

- (void)getRetailersSuccess:(void (^)(NSArray *retailers))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[self getPath:@"retailers" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if ([responseObject[@"retailers"] isKindOfClass:[NSArray class]]) {
			if (success) {
				NSArray *retailersRepresentation = responseObject[@"retailers"];
				NSArray *retailers = [self remoteObjectsForEntityNamed:@"retailer" fromRepresentations:retailersRepresentation];
				success(retailers);
			}
		} else {
			if (failure) {
				failure(operation, [self errorWithInvalidRepresentation:responseObject]);
			}
		}
	} failure:failure];
}

#pragma mark - Colors

- (void)getColorsSuccess:(void (^)(NSArray *colors))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[self getPath:@"colors" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if ([responseObject[@"colors"] isKindOfClass:[NSArray class]]) {
			if (success) {
				NSArray *colorsRepresentation = responseObject[@"colors"];
				NSArray *colors = [self remoteObjectsForEntityNamed:@"color" fromRepresentations:colorsRepresentation];
				success(colors);
			}
		} else {
			if (failure) {
				failure(operation, [self errorWithInvalidRepresentation:responseObject]);
			}
		}
	} failure:failure];
}

#pragma mark - Categories

- (PSSCategoryTree *)categoryTreeFromJSON:(NSDictionary *)JSON
{
	NSArray *categoriesRepresentation = JSON[@"categories"];
	NSMutableArray *categories = [self remoteObjectsForEntityNamed:@"category" fromRepresentations:categoriesRepresentation];
	PSSCategory *rootCat = nil;
	NSDictionary *metadata = JSON[@"metadata"];
	if ([metadata[@"root"] isKindOfClass:[NSDictionary class]]) {
		rootCat = (PSSCategory *)[self remoteObjectForEntityNamed:@"category" fromRepresentation:metadata[@"root"]];
	}
	if (categories.count > 0 && rootCat != nil) {
		[categories insertObject:rootCat atIndex:0];
		PSSCategoryTree *categoryTree = [self categoryTreeFromCategories:categories rootCategoryID:rootCat.categoryID];
		return categoryTree;
	}
	
	return nil;
}

- (void)categoryTreeFromCategoryID:(NSString *)categoryIDOrNil depth:(NSNumber *)depthOrNil success:(void (^)(PSSCategoryTree *categoryTree))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	if (depthOrNil != nil && depthOrNil.integerValue <= 0) {
		if (success) {
			success(nil);
		}
		return;
	}
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	if (categoryIDOrNil != nil && categoryIDOrNil.length > 0) {
		[params setValue:categoryIDOrNil forKey:@"cat"];
	}
	if (depthOrNil != nil) {
		[params setValue:depthOrNil forKey:@"depth"];
	}
	if (params.count == 0) {
		params = nil;
	}
	[self getPath:@"categories" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if ([responseObject[@"categories"] isKindOfClass:[NSArray class]] && [responseObject[@"metadata"] isKindOfClass:[NSDictionary class]]) {
			PSSCategoryTree *categoryTree = [self categoryTreeFromJSON:responseObject];
			if (categoryTree) {
				if (success) {
					success(categoryTree);
				}
			} else {
				if (failure) {
					failure(operation, [self errorWithInvalidRepresentation:responseObject]);
				}
			}
		} else {
			if (failure) {
				failure(operation, [self errorWithInvalidRepresentation:responseObject]);
			}
		}
	} failure:failure];
}

- (PSSCategoryTree *)categoryTreeFromCategories:(NSArray *)categories rootCategoryID:(NSString *)rootID
{
	if (categories.count > 0 && rootID.length > 0) {
		PSSCategoryTree *categoryTree = [[PSSCategoryTree alloc] initWithRootID:rootID categories:categories];
		return categoryTree;
	}
	return nil;
}

#pragma mark - Errors

- (NSError *)errorWithBadResponseString:(NSString *)responseString
{
	NSDictionary *userDict = @{ NSLocalizedDescriptionKey: @"Malformed Response From Server",
								NSLocalizedFailureReasonErrorKey: @"Malformed Response From Server",
								@"responseString": (responseString ?: @"")};
	return [NSError errorWithDomain:PSSMalformedResponseErrorDomain code:500 userInfo:userDict];
}

- (NSError *)errorNamed:(NSString *)errorName
{
	// Placeholder to map server errors to something local.
	return nil;
}

- (NSError *)errorFromResponseErrorRepresentation:(NSDictionary *)representation
{
	if (representation.count >= 3 && representation[@"errorCode"] != nil && representation[@"errorMessage"] != nil && representation[@"errorName"] != nil) {
		NSString *errorName = representation[@"errorName"];
		NSError *namedError = [self errorNamed:errorName];
		if (namedError != nil) {
			return namedError;
		}
		NSString *errorMessage = representation[@"errorMessage"];
		if (errorMessage == nil || errorMessage.length < errorName.length) {
			errorMessage = errorName;
		}
		NSInteger errorCode = [[representation[@"errorCode"] description] integerValue];
		if (errorCode == 0) {
			errorCode = 500;
		}
		if ([representation[@"detailedErrors"] isKindOfClass:[NSArray class]]) {
			// Currently there is only one
			NSDictionary *detailedError = [(NSArray *)representation[@"detailedErrors"] lastObject];
			if (detailedError[@"errorName"] != nil) {
				errorName = detailedError[@"errorName"];
			}
			if (detailedError[@"errorMessage"] != nil) {
				errorMessage = detailedError[@"errorMessage"];
			}
		}
		NSDictionary *userDict = @{ NSLocalizedDescriptionKey: errorMessage,
									NSLocalizedFailureReasonErrorKey: errorName,
									@"responseObject": [representation description] };
		return [NSError errorWithDomain:PSSServerResponseErrorDomain code:errorCode userInfo:userDict];
	}
	return nil;
}

- (NSError *)errorWithInvalidRepresentation:(NSDictionary *)representation
{
	// make sure the representation isn't an error object, if it is return that.
	NSError *error = [self errorFromResponseErrorRepresentation:representation];
	if (error != nil) {
		return error;
	}
	NSDictionary *userDict = @{ NSLocalizedDescriptionKey: @"Invalid Representation",
								NSLocalizedFailureReasonErrorKey: @"Invalid Representation",
								@"responseObject": [representation description] };
	return [NSError errorWithDomain:PSSInvalidRepresentationErrorDomain code:500 userInfo:userDict];
}

#pragma mark - PSSRemoteObject Conversion

- (NSMutableArray *)remoteObjectsForEntityNamed:(NSString *)entityName fromRepresentations:(NSArray *)representations
{
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[representations count]];
	for (id valueMember in representations) {
		if ([valueMember isKindOfClass:[NSDictionary class]] && [(NSDictionary *)valueMember count] > 0) {
			id remoteObject = [self remoteObjectForEntityNamed:entityName fromRepresentation:valueMember];
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

- (id<PSSRemoteObject>)remoteObjectForEntityNamed:(NSString *)entityName fromRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	if ([entityName isEqualToString:@"brand"]) {
		return [PSSBrand instanceFromRemoteRepresentation:representation];
	} else if ([entityName isEqualToString:@"category"]) {
		return [PSSCategory instanceFromRemoteRepresentation:representation];
	} else if ([entityName isEqualToString:@"color"]) {
		return [PSSColor instanceFromRemoteRepresentation:representation];
	} else if ([entityName isEqualToString:@"product"]) {
		return [PSSProduct instanceFromRemoteRepresentation:representation];
	} else if ([entityName isEqualToString:@"retailer"]) {
		return [PSSRetailer instanceFromRemoteRepresentation:representation];
	} else if ([entityName isEqualToString:@"productFilter"]) {
		return [PSSProductFilter instanceFromRemoteRepresentation:representation];
	}
	return nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (!self) {
		return nil;
	}
	
	[self sharedInit];
	
	self.partnerID = [aDecoder decodeObjectForKey:@"partnerID"];
	self.currentLocale = [aDecoder decodeObjectForKey:@"currentLocale"];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[super encodeWithCoder:aCoder];
	[aCoder encodeObject:self.partnerID forKey:@"partnerID"];
	[aCoder encodeObject:self.currentLocale forKey:@"currentLocale"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [super copyWithZone:zone];
	copy.currentLocale = self.currentLocale;
	copy.partnerID = self.partnerID;
	return copy;
}

@end
