//
//  cdbfapi.h
//  cdbfapi
//
//  Created by Sergey Chehuta on 13.02.15.
//  Copyright (c) 2015 WhiteTown. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for cdbfapi.
FOUNDATION_EXPORT double cdbfapiVersionNumber;

//! Project version string for cdbfapi.
FOUNDATION_EXPORT const unsigned char cdbfapiVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <cdbfapi/PublicHeader.h>

@interface cdbfapi : NSObject

- (void) initLibrary:(NSInteger)magicNumber email:(nonnull NSString*)email;

- (BOOL) openDBFfile: (nonnull NSString *) filename;
- (void) closeDBFfile;

- (NSInteger) recCount;
- (NSInteger) fieldCount;

- (BOOL) getRecord:(NSInteger) recno;
- (BOOL) readRecord: (NSInteger) recno;
- (BOOL) writeRecord: (NSInteger) recno;

- (BOOL) readField: (NSInteger) recno fieldno: (NSInteger) fieldno;
- (BOOL) writeField: (NSInteger) recno fieldno: (NSInteger) fieldno;

- (NSInteger) indexOfField: (nonnull NSString*) fieldname NS_SWIFT_NAME(indexOfField(_:));

- (nullable NSString*) getString: (NSInteger) fieldno;
- (double) getValue: (NSInteger) fieldno;

- (nullable NSDate*) getDateTime: (NSInteger) fieldno;
- (int64_t) getTicks: (NSInteger) fieldno;

- (nullable NSData*) getMemoBuf:(NSInteger) fieldno;

- (BOOL) isMemoField: (NSInteger) fieldno;
- (BOOL) isNumericField: (NSInteger) fieldno;
- (BOOL) isDateField: (NSInteger) fieldno;

- (BOOL) isDeleted;
- (BOOL) isDeleted: (NSInteger) recno;

- (void) clearRecord;
- (void) clearField: (NSInteger) fieldno;

- (void) setField: (NSInteger) fieldno asString: (nullable NSString*) string NS_SWIFT_NAME(setField(_:asString:));
- (void) setField: (NSInteger) fieldno asDouble: (double) value NS_SWIFT_NAME(setField(_:asDouble:));
- (void) setField: (NSInteger) fieldno asString: (nullable NSString*) string asDouble: (double) value NS_SWIFT_NAME(setField(_:asString:asDouble:));

- (void) setMemoBuf:(NSInteger) fieldno data:(nonnull NSData*)data;

- (BOOL) markAsDeleted: (NSInteger) recno NS_SWIFT_NAME(markAsDeleted(_:));
- (BOOL) recallDeleted: (NSInteger) recno;

- (BOOL) deleteRecord: (NSInteger) recno;
- (BOOL) appendRecord: (BOOL) blank;
- (BOOL) insertRecord: (NSInteger) recno blank: (BOOL) blank;

- (void) setOrder: (nonnull NSString*) fieldlist;
- (void) setOrderA: (nonnull NSArray <NSString*>*) array;
- (void) unsetOrder;
- (void) descendingMode:(BOOL)descending;

- (void) setFilter: (nonnull NSString*) expression;
- (void) unsetFilter;
- (void) caseSensitiveMode:(BOOL)sensitive;

- (BOOL) pack;
- (BOOL) truncate:(NSInteger) recno;
- (BOOL) zap;

- (NSInteger) fileType;
- (nullable NSString*)filetypeAsText;

- (NSInteger) recordLength;
- (nonnull NSString*) lastUpdated;
- (NSInteger) headerSize;

- (nullable NSString*) filename;
- (nullable NSString*) filenameMemo;
- (nullable NSString*) driverName;

- (void)resetLastRecord;

- (nullable NSString*) fieldName: (NSInteger) fieldno;
- (char)      fieldType: (NSInteger) fieldno;
- (NSInteger) fieldLength: (NSInteger) fieldno;
- (NSInteger) fieldDecimal: (NSInteger) fieldno;

+ (nullable NSString*)typeAsText:(char)c NS_SWIFT_NAME(typeAsText(_:));

- (void) setEncoding: (NSInteger) encoding;
- (void) setDateFormat: (nonnull NSString*) format;
- (void) setDateDelimiter: (char) c;

- (BOOL) isReadOnly;
- (void) setReadOnly:(BOOL)value;

- (BOOL) prepareNewTable:(NSInteger) fileType;
- (BOOL) prepareNewTable:(NSInteger) fileType memoSize:(NSInteger)memoSize driver:(nullable NSString*)driver;

- (void) addField: (nonnull NSString*) fieldname fieldType: (char)c length: (NSInteger)length;
- (void) addField: (nonnull NSString*) fieldname fieldType: (char)c length: (NSInteger)length decimal: (NSInteger) decimal;

- (BOOL) createTable: (nonnull NSString*) filename;
- (BOOL) createAndOpenTable: (nonnull NSString*) filename;

- (void) setByte:(NSInteger)offset byte:(Byte)byte;
- (Byte) getByte:(NSInteger)offset;

@end


