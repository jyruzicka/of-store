/*
 * OmniFocus.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class OmniFocusApplication, OmniFocusDocument, OmniFocusSection, OmniFocusFolder, OmniFocusProject, OmniFocusTask, OmniFocusFlattenedTask;

@interface OmniFocusApplication : SBApplication
- (OmniFocusDocument *)defaultDocument;
@end

@interface OmniFocusDocument : SBObject
- (SBElementArray *) folders;
- (SBElementArray *) projects;
@end

@interface OmniFocusSection : SBObject
@end

@interface OmniFocusFolder : OmniFocusSection
- (NSString *) id;
- (NSString *)name;
- (SBElementArray *) folders;
- (SBElementArray *) projects;
@end

@interface OmniFocusProject : OmniFocusSection
- (NSString *) id;
- (NSString *) name;
- (OmniFocusTask *) rootTask;
- (id) creationDate;
- (id) completionDate;
- (BOOL) completed;
@end

@interface OmniFocusTask : SBObject
- (NSString *) id;
- (NSString *) name;
- (SBElementArray *) flattenedTasks;
- (id) creationDate;
- (id) completionDate;
- (BOOL) completed;
@end

@interface OmniFocusFlattenedTask : OmniFocusTask
@end
