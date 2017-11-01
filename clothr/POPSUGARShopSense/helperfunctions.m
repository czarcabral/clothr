//
//  helperfunctions.m
//  clothr
//
//  Created by Andrew Guterres on 10/29/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

#import "helperfunctions.h"

#pragma mark - Getting products

@interface helperfunctions()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *salePriceLabel;
@property (nonatomic, copy, readwrite) NSURL *URL;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSMutableArray *buffer;
@property (nonatomic, strong) PSSProduct *product;
@end

@implementation helperfunctions

@synthesize products = _products;
//@synthesize buffer = _buffer;
// Given `notes` contains an array of Note objects
//NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notes];
//[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"notes"];
//NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"notes"];
//NSArray *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];



- (NSArray*)fillProductBuffer
{

//    NSMutableArray *prod = [[NSMutableArray alloc] init];
    
    PSSProductQuery *productQuery = [[PSSProductQuery alloc] init];
    productQuery.searchTerm = @"red dress";
    __weak typeof(self) weakSelf = self;
    [[PSSClient sharedClient] searchProductsWithQuery:productQuery offset:[NSNumber numberWithInt:10] limit:[NSNumber numberWithInt:50] success:^(NSUInteger totalCount, NSArray *availableHistogramTypes, NSArray *products) {
        weakSelf.products = products;
                PSSProduct *thisProduct = self.products[(NSUInteger)0];
            printf("name: %s\n", [thisProduct.name UTF8String]);
            printf("salePriceLabel: %s\n", [thisProduct.regularPriceLabel UTF8String]);
        
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:products];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"name"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
    
    NSData *productData = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    NSArray *buffer = [NSKeyedUnarchiver unarchiveObjectWithData:productData];
    return buffer;
}



- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.salePriceLabel forKey:@"salePriceLabel"];
    [encoder encodeObject:self.product forKey:@"product"];
}

- (id)initWithCoder:(nonnull NSCoder *)decoder {
    if((self = [self init]))
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.salePriceLabel=[decoder decodeObjectForKey:@"salePriceLabel"];
        self.product = [decoder decodeObjectForKey:@"product"];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) copy = [[[self class] allocWithZone:zone] init];
    copy.name= self.name;
    copy.salePriceLabel=self.salePriceLabel;
    copy.product=self.product;
    return copy;
}

@end
