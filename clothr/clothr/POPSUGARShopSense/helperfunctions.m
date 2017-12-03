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
@property (nonatomic, strong) NSMutableArray *brands;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *sizes;
@property (nonatomic, strong) NSMutableArray *retailers;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSMutableArray *buffer;
@property (nonatomic, strong) PSSProduct *product;
@end

typedef void(^myCompletion)(BOOL);
//BOOL check = false;

@implementation helperfunctions

@synthesize products = _products;
//@synthesize buffer = _buffer;
// Given `notes` contains an array of Note objects
//NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notes];
//[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"notes"];
//NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"notes"];
//NSArray *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];



- (void)fillProductBuffer:(NSString *)search :(NSNumber *)pagingIndex
{
    __block NSArray *buffer;
    [self searchQuery:search :pagingIndex :^(BOOL finished)
     {
         if(finished){
             //            while(!check){}
             printf("FINISHED");
             NSData *productData = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
             buffer = [NSKeyedUnarchiver unarchiveObjectWithData:productData];
             PSSProduct *thisProduct = buffer[(NSUInteger)0];
             printf("Unarchived name: %s\n", [thisProduct.name UTF8String]);
             //return buffer;
             //filledBuffer=buffer;
         }
     }];
    
    //NSData *productData = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    //NSArray *buffer = [NSKeyedUnarchiver unarchiveObjectWithData:productData];
    //    return buffer;
    
    //    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:myObject] forKey:@"MyObjectKey"];
    //    [defaults synchronize];
}

-(void) searchQuery:(NSString *)searchTerm :(NSNumber*)pagingIndex :(myCompletion) compblock{
    PSSProductQuery *productQuery = [[PSSProductQuery alloc] init];
    productQuery.searchTerm = searchTerm;
    NSData *filterData = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickedRetailerFilters"];
    NSArray *filters = [NSKeyedUnarchiver unarchiveObjectWithData:filterData];
    [productQuery addProductFilters:filters];
    printf("%lu", (unsigned long)filters.count);
    filterData = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickedBrandFilters"];
    filters = [NSKeyedUnarchiver unarchiveObjectWithData:filterData];
    printf("%lu", (unsigned long)filters.count);
//    filters.append
    [productQuery addProductFilters:filters];
    filterData = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickedSizeFilters"];
    filters = [NSKeyedUnarchiver unarchiveObjectWithData:filterData];
    printf("%lu", (unsigned long)filters.count);
    [productQuery addProductFilters:filters];
    filterData = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickedColorFilters"];
    filters = [NSKeyedUnarchiver unarchiveObjectWithData:filterData];
    printf("%lu", (unsigned long)filters.count);
    [productQuery addProductFilters:filters];
//    if(filters.count>0){
//    PSSProductFilter *thisfilter = productQuery.productFilters[(NSUInteger)0];
//    printf("filterid2: %d", [thisfilter.filterID integerValue]);
//    }
//    printf("filtercount: %d", filters.count);
//    [productQuery addProductFilters:filters];
    printf("here: %s\n", [productQuery.searchTerm UTF8String]);
    __weak typeof(self) weakSelf = self;
    [[PSSClient sharedClient] searchProductsWithQuery:productQuery offset:pagingIndex limit:[NSNumber numberWithInt:10] success:^(NSUInteger totalCount, NSArray *availableHistogramTypes, NSArray *products) {
        printf("ARCHIVING...\n");
        weakSelf.products = products;
        PSSProduct *thisProduct = self.products[(NSUInteger)0];
        printf("Archive name: %s\n", [thisProduct.name UTF8String]);
        printf("Archive count: %lu\n", (unsigned long)totalCount);
        //        printf("website url: %s\n", [thisProduct. UTF8String]); NSNumber *myNum = @(myNsIntValue);
        NSNumber *total= @(totalCount);
        printf("total: %d", total);
        if(pagingIndex>total)       //if the current item index > the total amount of items returned from api
        {
            NSArray *overset = @[@"overSet"];
            NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
            [data setObject:[NSKeyedArchiver archivedDataWithRootObject:overset] forKey:@"name"];
            [data synchronize];
        } else if (totalCount==0)        //if there are no items returned from the api
        {
            printf("TOTAL=========0");
            NSArray *noItems = @[@"noItems"];
            NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
            [data setObject:[NSKeyedArchiver archivedDataWithRootObject:noItems] forKey:@"name"];
            [data synchronize];
        } else
        {
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [data setObject:[NSKeyedArchiver archivedDataWithRootObject:products] forKey:@"name"];
        [data synchronize];
        NSData *productData = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
        NSArray *buffer = [NSKeyedUnarchiver unarchiveObjectWithData:productData];
        PSSProduct *thisProduct2 = buffer[(NSUInteger)0];
        printf("Unarchived name2: %s\n", [thisProduct2.name UTF8String]);
        }
        //        check=true;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
    compblock(NO);
    return;
}

-(void)fillBrandBuffer
{
    __weak typeof(self) weakSelf = self;
    [[PSSClient sharedClient] getBrandsSuccess:^(NSArray *brands) {
//        weakSelf.brands = brands;
        for(int i=0;i<200;i++)
        {
            [weakSelf.brands addObject:brands[i]];
        }
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [data setObject:[NSKeyedArchiver archivedDataWithRootObject:brands] forKey:@"brand"];
        [data synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
}

-(void)fillSizeBuffer
{
    __weak typeof(self) weakSelf = self;
    [[PSSClient sharedClient] getSizesSuccess:^(NSArray *sizes) {
        //        weakSelf.brands = brands;
        printf("%lu", (unsigned long)sizes.count);
        for(int i=0;i<5;i++)
        {
            [weakSelf.sizes addObject:sizes[i]];
        }
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [data setObject:[NSKeyedArchiver archivedDataWithRootObject:sizes] forKey:@"size"];
        [data synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
}

-(void)fillColorBuffer
{
    __weak typeof(self) weakSelf = self;
    [[PSSClient sharedClient] getColorsSuccess:^(NSArray *colors) {
        //        weakSelf.brands = brands;
        for(int i=0;i<14;i++)
        {
            [weakSelf.colors addObject:colors[i]];
        }
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [data setObject:[NSKeyedArchiver archivedDataWithRootObject:colors] forKey:@"color"];
        [data synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
}


-(void)fillRetailerBuffer
{
    __weak typeof(self) weakSelf = self;
    [[PSSClient sharedClient] getRetailersSuccess:^(NSArray *retailers) {
//        weakSelf.retailers = retailers;
        for(int i=0;i<200;i++)
        {
            [weakSelf.retailers addObject:retailers[i]];
        }
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [data setObject:[NSKeyedArchiver archivedDataWithRootObject:retailers] forKey:@"retailer"];
        [data synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
}

-(void)fillCategoriesBuffer
{
    __weak typeof(self) weakSelf = self;
    [[PSSClient sharedClient] categoryTreeFromCategoryID:nil depth:nil success:^(PSSCategoryTree *categoryTree) {
        weakSelf.categories = categoryTree.rootCategory.childCategories;
//        [weakSelf.tableView reloadData];
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [data setObject:[NSKeyedArchiver archivedDataWithRootObject:categoryTree.rootCategory.childCategories] forKey:@"categories"];
        [data synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
}

- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeObject:self.product forKey:@"name"];
    [encoder encodeObject:self.salePriceLabel forKey:@"salePriceLabel"];
    //[encoder encodeObject:self.product forKey:@"product"];
}

- (id)initWithCoder:(nonnull NSCoder *)decoder {
    if((self = [self init]))
    {
        self.product = [decoder decodeObjectForKey:@"name"];
        self.salePriceLabel=[decoder decodeObjectForKey:@"salePriceLabel"];
        //self.product = [decoder decodeObjectForKey:@"product"];
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

