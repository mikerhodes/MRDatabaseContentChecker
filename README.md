# MRDatabaseContentChecker

[![Version](http://cocoapod-badges.herokuapp.com/v/MRDatabaseContentChecker/badge.png)](http://cocoadocs.org/docsets/MRDatabaseContentChecker)
[![Platform](http://cocoapod-badges.herokuapp.com/p/MRDatabaseContentChecker/badge.png)](http://cocoadocs.org/docsets/MRDatabaseContentChecker)

MRDatabaseContentChecker is a small library to make checking the contents
of a database easier and more literate in your tests. It tries to stay out
your way and make writing tedious checks simpler and less error prone.

You can test the content of either tables or queries.

MRDatabaseContentChecker requires that you are using FMDB.

## Usage

You can check either the full content of database tables, or the results of
a query (as they're both table-like structures).

### Tables

The simplest example, using SenTest, is something like the following:

```objc
FMDatabase *db = [...];
MRDatabaseContentChecker *dc = [[MRDatabaseContentChecker alloc] init];

NSError *validationError;
NSArray *expectedRows = @[
    @[@"first_name", @"surname"],  // first array is column headers
    @[@"Mike",       @"Rhodes"],   // expected data starts in row 2
    @[@"John",       @"Smith"]     // and continues...
];
STAssertTrue([dc checkDatabase:db
                         table:@"users"
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

### Queries

The above example can be rewritten to use a query rather than a table name:

```objc
FMDatabase *db = [...];
MRDatabaseContentChecker *dc = [[MRDatabaseContentChecker alloc] init];

NSError *validationError;
NSArray *expectedRows = @[  /* as before */  ];
STAssertTrue([dc checkDatabase:db
                         query:@"select first_name, surname from users;"
                       hasRows:expectedRows
                         error:&validationError],
             [dc formattedErrors:validationError]);
```

At the moment, there's no support for placeholders; you control the SQL
you're generating in your tests. Or, if not, feel free to open a PR as I'm
not in the slightest averse to including further features.

### Caveats

* The table-checking variant relies on the "undefined" ordering that SQLite
  returns rows in. Right now, if this doesn't work, using the query variant is
  neccessary to allow an `ORDER BY` clause to be included.
* There is no limit enforced on the number of errors reported. This may be
  a problem if there are millions of errors as every error has an
  entry in the error object passed out of the method.

### Checks reference

`-checkDatabase:table:hasRows:error:` and `-checkDatabase:query:hasRows:error:`
check:

- Each expected value matches is corresponding item in the result set.
- There are the same number of results as expected.

#### Types

As shown above, expected values are passed as an array of arrays. Each
expected value is check against its corresponding entry in the result set
based on its type. The allowed types are:

<dl>
<dt>NSString</dt>
<dd>NSString objects are checked using -isEqual.</dd>
<dt>NSNumber</dt>
<dd>NSNumber objects are checked using -isEqual against -longLongIntForColumn
values from the database.</dd>
<dt>BOOL (boxed)</dt>
<dd>As a boxed BOOL is an NSNumber, see NSNumber.</dd>
<dt>NSData</dt>
<dd>NSData objects are checked using -isEqual against -dataForColumn
value from database.</dd>
<dt>NSRegularExpression</dt>
<dd>This check passes if the return value from
-numberOfMatchesInString:options:error: returns one or more matches.</dd>
<dt>[NSNull null]</dt>
<dd>This check checks [NSNull null] against the value returned for
the column by -objectForColumnName:.</dd>
</dl>

Using an unsupported type (or a class that isn't a subclass of a supported
type) will result in a failure checking the value.

You can pass different datatypes for a given column's expected values:

```objc
expectedRows = @[
    @[@"name",        @"github_username", @"age"],
    @[@"Mike Rhodes", @"mikerhodes",      @30],
    @[@"John Smith",  [NSNull null],      @27]
];
```

## Requirements

MRDatabaseContentChecker depends on:

* FMDB

## Installation

MRDatabaseContentChecker is available through [CocoaPods](http://cocoapods.org),
to install it add the following line to your Podfile:

    pod "MRDatabaseContentChecker"

## Author

Michael Rhodes, mike.rhodes@gmail.com

## License

MRDatabaseContentChecker is available under the Apache v2 license. See the LICENSE file for more info.

