//
//  DatabaseContentCheckerExampleTests.m
//  DatabaseContentCheckerExampleTests
//
//  Created by Michael Rhodes on 12/05/2014.
//  Copyright (c) 2014 Small Text. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FMDatabase.h"
#import "MRDatabaseContentChecker.h"

@interface DatabaseContentCheckerExampleTests : XCTestCase
@property FMDatabase *db;
@end

@implementation DatabaseContentCheckerExampleTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    //need to create a databse
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSString *dbPath = [cachePath stringByAppendingPathComponent:@"database.sqlite"];
    
    self.db = [FMDatabase
               databaseWithPath:dbPath];
    [self.db open];
    [self.db executeUpdate:@"CREATE TABLE test(textData text, numericData int, moreText text)"];
    
    // Building the string ourself
    NSArray * array = @[@4, @1, @9];
    
    for(int i=0; i<3; i++) {
    
        NSString * textData = @"aRandomTextString";
        NSString * iAsString = [NSString stringWithFormat:@"%@",array[i]];
        NSString *query = [NSString stringWithFormat:@"insert into test values('%@', %d, '%@')",
                           [textData stringByAppendingString:iAsString],
                           25+i,
                           @"someMoreRandomText"];
        [self.db executeUpdate:query];
    }
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [self.db executeUpdate:@"DROP TABLE test"];
}

- (void)testSuccessfulCompareOrdered
{
 
    MRDatabaseContentChecker *checker = [[MRDatabaseContentChecker alloc] init];
    NSError * error;
    
    NSArray * content = @[ @[@"textData", @"numericData", @"moreText"],
                           @[@"aRandomTextString1", @(26), @"someMoreRandomText"],
                           @[@"aRandomTextString4", @(25), @"someMoreRandomText"],
                           @[@"aRandomTextString9", @(27), @"someMoreRandomText"],
                       ];
    
    BOOL dbCheckResult = [checker checkDatabase:self.db
                                          table:@"test"
                                        hasRows:content
                                        orderBy:@[@"textData"]
                                          error:&error];
    
    XCTAssertNil(error, @"An error occured checking the database");
    XCTAssertTrue(dbCheckResult, @"DB check returned false");
    
}

- (void)testSuccessfulComparedUnordered
{
    MRDatabaseContentChecker *checker = [[MRDatabaseContentChecker alloc]init];
    NSError * error;
    
    NSArray * content = @[ @[@"textData", @"numericData",@"moreText"],
                           @[@"aRandomTextString4",@(25),@"someMoreRandomText"],
                           @[@"aRandomTextString1",@(26),@"someMoreRandomText"],
                           @[@"aRandomTextString9",@(27),@"someMoreRandomText"],
                           ];
    
    BOOL dbCheckResult = [checker checkDatabase:self.db
                                          table:@"test"
                                        hasRows:content
                                          error:&error];
    
    XCTAssertNil(error, @"An error occured checking the database");
    XCTAssertTrue(dbCheckResult, @"DB check returned false");
}


@end
