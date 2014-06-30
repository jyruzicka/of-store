//  JRFolder.h
//
//  For license information see the LICENSE file

#import "JROFObject.h"
@class OmniFocusFolder, JRTask, JRProject;

/**
 * Represents a folder in the OmniFocus tree
 */
@interface JRFolder : JROFObject {
    NSString *_name, *_id;
    NSMutableArray *_folders, *_projects;
}

/**
 * The OmniFocus folder object
 */
@property (atomic,readonly) OmniFocusFolder *folder;

///---------------------------------
/// @name Initializers and factories
///---------------------------------

/**
 * Default initializer
 *
 * @param folder The OmniFocus folder object that this maps to.
 * @param parent The parent object. Set to `nil` for root objects.
 */
-(id)initWithFolder:(OmniFocusFolder *)folder parent:(JROFObject *)parent;

/**
 * Default factory
 *
 * @see initWithFolder:parent:
 */
+(id)folderWithFolder:(OmniFocusFolder *)folder parent:(JROFObject *)parent;

/**
 * Generate an array of folders from an array of `OmniFocusFolder` objects.
 *
 * @param parent The parent object for all generated folders.
 */
+(NSMutableArray *)foldersFromArray:(NSArray *)array parent:(JROFObject *)parent;

/**
 * Generate an array of folders from an array of `OmniFocusFolder` objects, excluding a subset of these.
 *
 * @param parent The parent object for all generated folders.
 * @param excluding An array of NSStrings. Folders will not be generated if their name is in this array.
 */
+(NSMutableArray *)foldersFromArray:(NSArray *)array parent:(JROFObject *)parent excluding:(NSArray *)exclusions;

///-------------------------
/// @name Collection getters
///-------------------------

/**
 * @return The folder's sub-folders.
 */
-(NSMutableArray *)folders;

/**
 * @return The folder's projects.
 */
-(NSMutableArray *)projects;

///--------------------------
/// @name Traversing the tree
///--------------------------

/**
 * Perform an action on each task contained within this folder.
 */
-(void)eachTask:(void (^)(JRTask *))function;

/**
 * Perform an action on each project contained within this folder.
 */
-(void)eachProject:(void (^)(JRProject *))function;
@end
