/*
 * OmniFocus.h
 *
 * Additional methods, classes, etc. not used by JROFBridge have been stripped for size reasons.
 *
 * Some methods are duplicated in order to simulate both OF1 and OF2 implementations.
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class OmniFocusApplication, OmniFocusDocument, OmniFocusProject, OmniFocusTask, OmniFocusFlattenedTask, OmniFocusFlattenedProject;

enum OmniFocusProjectStatus {
  OmniFocusProjectStatusActive = 'FCPa' /* Active */,
  OmniFocusProjectStatusOnHold = 'FCPh' /* On Hold */,
  OmniFocusProjectStatusDone = 'FCPd' /* Done */,
  OmniFocusProjectStatusDropped = 'FCPD' /* Dropped */
};
typedef enum OmniFocusProjectStatus OmniFocusProjectStatus;

@interface OmniFocusApplication : SBApplication
- (OmniFocusDocument *) defaultDocument;
@end

@interface OmniFocusDocument : SBObject
- (SBElementArray *) projects;
- (SBElementArray *) folders;

- (SBElementArray *) flattenedProjects;
- (SBElementArray *) flattenedTasks;
- (SBElementArray *) flattenedFolders;
@end

@interface OmniFocusSection : SBObject
@end

@interface OmniFocusFolder : SBObject
- (NSString *) id;
- (NSString *) name;

- (SBElementArray *) folders;
- (SBElementArray *) projects;
@end

@interface OmniFocusProject : OmniFocusSection
- (NSString *) id;
- (NSString *) name;

- (OmniFocusTask *)rootTask;
- (OmniFocusTask *)nextTask;
- (OmniFocusProjectStatus) status;
- (id) container;

- (NSDate *) creationDate;
- (id) startDate;    //OF1
- (id) deferDate; //OF2

- (BOOL) completed;
- (id) completionDate;
@end

@interface OmniFocusTask : SBObject

- (NSString *) id;
- (NSString *) name;

- (SBElementArray *)flattenedTasks;

- (NSDate *) creationDate;
- (id) startDate;    //OF1
- (id) deferDate;   //OF2
- (id) context;

-(BOOL) completed;
-(id) completionDate;
@end

@interface OmniFocusContext : SBObject
- (NSString *) name;
@end


@interface OmniFocusFlattenedTask : OmniFocusTask
@end

@interface OmniFocusFlattenedProject : OmniFocusProject
@end