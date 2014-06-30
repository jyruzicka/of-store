//  JRTask.h
//
//  For license information see the LICENSE file

#import "JROFObject.h"
@class OmniFocusTask;
@class JRProject;

/**
 * Represents a task in the OmniFocus tree
 */
@interface JRTask : JROFObject {
    NSString *_name, *_id;
    NSString *_projectName, *_projectID;
    NSDate *_creationDate, *_completionDate, *_deferredDate;
}

/**
 * The OmniFocus task this object represents.
 */
@property (atomic,readonly) OmniFocusTask *task;

///---------------------------------
/// @name Initializers and factories
///---------------------------------

/**
 * Default initializer
 *
 * @param task The OmniFocus task this object represents
 * @param parent The task's parent.
 */
-(id)initWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent;

/**
 * Default factory.
 *
 * @see initWithTask:parent:
 */
+(JRTask *)taskWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent;

/**
 * Generate an array of tasks from an array of `OmniFocusTasks` objects.
 *
 * @param parent The parent object for all generated tasks.
 */
+(NSMutableArray *)tasksFromArray:(NSArray *)tasks parent:(JROFObject *)parent;

///-----------------
/// @name Properties
///-----------------

/**
 * @return The task's creation date
 */
-(NSDate *)creationDate;

/**
 * @return The task's defer date, or `nil` if not set.
 */
-(NSDate *)deferredDate;

/**
 * @return The task's completion date, or `nil` if not set.
 */
-(NSDate *)completionDate;

/**
 * @return YES if the task's context starts with "Waiting"
 */
-(BOOL)isWaiting;

/**
 * @return The name of the task's containing project.
 */
-(NSString *)projectName;

/**
 * @return The ID of the task's containing project.
 */
-(NSString *)projectID;

///----------------
/// @name Exporting
///----------------

/**
 * @return A list of columns and their types used to represent a JRTask in SQL.
 */
+(NSDictionary *)columns;

/**
 * @return A list of JRTask values as a dictionary, for export to SQL.
 */
-(NSDictionary *)asDict;
@end
