//  JRDatabase.h
//
//  For license information see the LICENSE file

#import <Foundation/Foundation.h>

@class JROFObject,  JRProject, JRTask;

@class FMDatabase;

/**
 * Should this database store information on projects, tasks, or both?
 * To allow >1 type in the database, combine values with a bitwise OR.
 */
typedef enum {JRDatabaseProjects=1,JRDatabaseTasks=2} JRDatabaseType;

/**
 * Used to indicate whether a database on file will take data from this
 * class or not.
 *
 * * `JRDatabaseExactMatch`: Tables match this class' storage capabilities exactly.
 * * `JRDatabaseSubset`: Database has additional tables that this class won't use.
 * * `JRDatabaseDoesNotExist`: Database doesn't exist yet - will be auto-created.
 * * `JRDatabaseDoesNotMatch`: Database doesn't have the tables for this class.
 */
typedef enum {JRDatabaseExactMatch,JRDatabaseSubset,JRDatabaseDoesNotExist,JRDatabaseDoesNotMatch} JRDatabaseOverlap;

/**
 * Wrapper around `JROFBridge` database storage functionality. Does not deal with data retrieval,
 * only writing.
 */
@interface JRDatabase : NSObject {
    FMDatabase *_database;
}

/**
 * The database's location on disk.
 */
@property NSString *location;

/**
 * The number of projects recorded this session.
 */
@property NSUInteger projectsRecorded;

/**
 * The number of tasks recorded this session.
 */
@property NSUInteger tasksRecorded;

/**
 * The type of database (i.e. what data it should store). Set at creation.
 */
@property (readonly) JRDatabaseType type;

///---------------------------------
/// @name Initializers and factories
///---------------------------------

/**
 * Default initializer
 * 
 * @param location The database's location on disk.
 * @param type The type of data this database will be storing
 */
-(id)initWithLocation:(NSString *)location type:(JRDatabaseType)type;

/**
 * Default factory
 *
 * @see -initWithLocation:type:
 */
+(id)databaseWithLocation:(NSString *)location type:(JRDatabaseType)type;

///-------------------------------------------
/// @name Database evaluation and modification
///-------------------------------------------

/**
 * @return Can this database exist in the filesystem without creating additional folders?
 */
-(BOOL)canExist;

/**
 * @return Is this database correctly formatted, given the type of database we're creating?
 * @see JRDatabaseType
 */
-(JRDatabaseOverlap)overlapWithDatabaseFile;

/**
 * @return The database object. Lazily loaded.
 */
-(FMDatabase *)database;

/**
 * Deletes the database from disk, allowing a new one to be created.
 *
 * @return If an error occurs while purging the database.
 */
-(NSError *)purgeDatabase;

///-------------------
/// @name Saving items
///-------------------

/**
 * Save a `JROFObject` to the database.
 * 
 * @return If an error occurs while writing the file.
 */
-(NSError *)saveOFObject:(JROFObject *)o;

/**
 * Save a `JRTask` to the database.
 * 
 * @return If an error occurs while writing the file.
 */
-(NSError *)saveTask:(JRTask *)t;

/**
 * Save a `JRProject` to the database.
 * 
 * @return If an error occurs while writing the file.
 */
-(NSError *)saveProject:(JRProject *)p;
@end
