//  JROmniFocus.h
//
//  For license information see the LICENSE file

#import <Foundation/Foundation.h>

@class JROFObject, OmniFocusApplication, JRProject, JRTask;

/**
 * Enum of OmniFocus versions
 */
typedef enum {JROmniFocusVersion1, JROmniFocusVersion2Standard, JROmniFocusVersion2Pro} JROmniFocusVersion;

/**
 * Acts as a wrapper object for omnifocus itself.
 * Used to determine which version of OmniFocus is running
 * (1, 2 or Pro), whether it's running, and to return the
 * default document.
 *
 * Singleton object. Get the current application with `+[OmniFocus instance]`
 */
@interface JROmniFocus : NSObject {
    NSMutableArray *_projects, *_folders;
    NSMutableArray *_flattenedProjects, *_flattenedFolders, *_flattenedTasks;
    JROmniFocusVersion version;
}

/**
 * The OmniFocus application we're mapping to.
 */
@property OmniFocusApplication *application;

/**
 * The process string (bundle identifier) of this particular application.
 */
@property NSString *processString;

/**
 * Any top-level folders with names in this array will be ignored by the program.
 */
@property NSArray *excludedFolders;

///---------------------------------
/// @name Initializers and factories
///---------------------------------

/**
 * Default initializer
 */
-(id)init;

/**
 * Default factory
 */
+(JROmniFocus *)instance;

///--------------------------------------
/// @name Instance methods and properties
///--------------------------------------

/**
 * @return The version of the current application
 * 
 * @see JROmniFocusVersion
 */
-(JROmniFocusVersion)version;

/**
 * @return An array of top-level folders contained by the application.
 * 
 * @see excludedFolders
 */
-(NSMutableArray *)folders;

/**
 * @return An array of top-level projects contained by the application.
 */
-(NSMutableArray *)projects;

/**
 * @return An array of all folders contained by the application.
 *
 * @see excludedFolders
 */
-(NSMutableArray *)flattenedFolders;

/**
 * @return An array of all projects contained by the application.
 */
-(NSMutableArray *)flattenedProjects;

/**
 * @return An array of all tasks contained by the application.
 */
-(NSMutableArray *)flattenedTasks;

///----------------
/// @name Iterators
///----------------

/**
 * Run a block on every task in the application.
 *
 * @see excludedFolders
 */
-(void)eachTask:(void (^)(JRTask *))function;

/**
 * Run a block on every project in the application.
 *
 * @see excludedFolders
 */
-(void)eachProject:(void (^)(JRProject *))function;

@end
