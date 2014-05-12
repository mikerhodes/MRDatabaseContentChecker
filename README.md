# MRDatabaseContentChecker

[![Version](http://cocoapod-badges.herokuapp.com/v/MRDatabaseContentChecker/badge.png)](http://cocoadocs.org/docsets/MRDatabaseContentChecker)
[![Platform](http://cocoapod-badges.herokuapp.com/p/MRDatabaseContentChecker/badge.png)](http://cocoadocs.org/docsets/MRDatabaseContentChecker)

MRDatabaseContentChecker is a small library to make checking the contents
of a database easier and more literate in your tests. It tries to stay out
your way and make writing tedious checks simpler and less error prone.

It requires that you are using FMDB.

## Usage

The simplest example, using SenTest, is something like the following:

```objc
FMDatabase *db = [...];

NSError *validationError;
NSArray *expectedRows = @[
                          @[@"docId"],  // first array is column headers
                          @[ob.docId]   // expected data starts in row 2
                          ];
STAssertTrue([dc checkDatabase:db
                         table:@"docs"
                       hasRows:expectedRows
                         error:&validationError],
             [dc formattedErrors:validationError]);
```

Essentially:

1. Create your expected values array. This is an array of arrays. The first
   array always contains the column headers you want to check. The following
   rows define the data you expect to find.
1. Call `-checkDatabase:table:hasRows:error:` in a testing macro.
1. If that returns `NO`, use the `-formattedErrors` helper to print the
   failures.

The next level up is building the array programatically:

```objc
NSMutableArray *expectedRows = [NSMutableArray array];
[expectedRows addObject:@[@"sequence",
                          @"parent",
                          @"revid",
                          @"current",
                          @"json"]];

for (int counter = 1; counter <= numOfUpdates + 1; counter++) {

    // To check against numbers, use NSNumber -- note this
    // NSInteger is boxed below.
    NSInteger expectedSeq = counter;

    // Here, the parent is expected to be null for the first item,
    // and refer to the previous object for future objects. You
    // can use different data types for the values in a single
    // column.
    NSObject *expectedParent;
    if (expectedSeq == 1) {
        // You can check against NSNull for null values
        expectedParent = [NSNull null];
    } else {
        expectedParent = @(expectedSeq - 1);
    }

    // Use a regex to check the database value against the regex,
    // rather than having to match an exact string. Basically, the
    // check passes if there's one or more matches.
    NSString *revId = [NSString stringWithFormat:@"^%i-", counter];
    NSRegularExpression *revIdRegEx = [NSRegularExpression
                                       regularExpressionWithPattern:revId
                                       options:0
                                       error:nil];

    // Use (boxed) BOOL values if you need to.
    BOOL expectedCurrent = (counter == numOfUpdates +1);

    // Finally, you can use NSData instances -- useful for checking
    // JSON data.
    NSDictionary *expectedDict = [expectedData objectAtIndex:counter];
    NSData *json = [NSJSONSerialization dataWithJSONObject:expectedDict
                                                   options:0
                                                     error:nil];

    NSArray *row = @[@(expectedSeq),
                     expectedParent,
                     revIdRegEx,
                     @(expectedCurrent),
                     json];
    [expectedRows addObject:row];
}

NSError *validationError;
STAssertTrue([dc checkDatabase:db
                         table:@"revs"
                       hasRows:expectedRows
                         error:&validationError],
             [dc formattedErrors:validationError]);
```

## Requirements

## Installation

MRDatabaseContentChecker is available through [CocoaPods](http://cocoapods.org),
to install it add the following line to your Podfile:

    pod "MRDatabaseContentChecker"

## Author

Michael Rhodes, mike.rhodes@gmail.com

## License

MRDatabaseContentChecker is available under the Apache v2 license. See the LICENSE file for more info.

