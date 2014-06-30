//  JRDatabaseQuery.h
//
//  For license information see the LICENSE file

#import <Foundation/Foundation.h>

/**
 * Internal object used for building SQLite database queries.
 */
@interface JRDatabaseQuery : NSObject

/**
 * The table the query is headed to
 */
@property NSString *table;

/**
 * Dictionary of values to update/insert/query/create.
 */
@property NSMutableDictionary *values;

/**
 * Primary key of the table (defaults to "id")
 */
@property NSString *primaryKey;

///---------------------------------
/// @name Initializers and factories
///---------------------------------

/**
 * Create a query linked to a table.
 *
 * @param table The table to perform this query on.
 */
-(id)initForTable:(NSString *)table;

/**
 * Create a query linked to a table, with a given set of values.
 *
 * @param table The table to perform this query on.
 * @param values Dictionary of values to pass to the query
 */
-(id)initForTable:(NSString *)table values: (NSDictionary *)values;

/**
 * Factory method.
 *
 * @see -initForTable:
 */
+(JRDatabaseQuery *)queryForTable:(NSString *)table;

/**
 * Factory method
 *
 * @see -initForTable:values:
 */
+(JRDatabaseQuery *)queryForTable:(NSString *)table values:(NSDictionary *)values;

///--------------------------------
/// @name Modifying the values hash
///--------------------------------

/**
 * Add a value to the hash
 * 
 * @param value The value to add
 * @param key The key to add it under
 */ 
-(void)addValue:(id)value forKey:(NSString *)key;

/**
 * Remove a given key from the hash.
 *
 * @return Whether or not the key existed in the hash
 */
-(BOOL)removeKey:(NSString *)key;

///--------------
/// @name Queries
///--------------

/**
 * Returns an insert SQLite statement, of the form:
 *
 *     INSERT INTO table (key1,key2,key3) VALUES (?,?,?);
 *
 * To be used when the record doesn't already exist in the database.
 *
 * @param values Byref array of values to include alongside the statement.
 * @return The SQL statement
 */
-(NSString *)insert:(NSArray **)values;

/**
 * Returns an update SQLite statement, of the form:
 *
 *     UPDATE table SET (key1=?,key2=?,key3=?) WHERE primaryKey=?;
 *
 * To be used when the record already exists in the database.
 *
 * @param values Byref array of values to include alongside the statement.
 * @return The SQL statement
 */
-(NSString *)update:(NSArray **)values;

/**
 * Returns a create SQLite statement, of the form:
 *
 *     CREATE TABLE table (PKEY INTEGER PRIMARY KEY,KEY2 VAL2, KEY3 VAL3);
 *
 * To be used when creating a table.
 *
 * @return The SQL statement
 */
-(NSString *)create;

/**
 * Returns a "count" SQLite statement, of the form:
 *
 *     SELECT COUNT(*) FROM table WHERE PKEY=?;
 *
 * To be used when you want to know if a given primary key already exists in the database.
 *
 * @param value Byref id of the value to include alongside the statement.
 * @return The SQL statement
 */
-(NSString *)count:(id *)value;
@end