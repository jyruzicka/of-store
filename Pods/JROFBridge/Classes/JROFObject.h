//  JROFObject.h
//
//  For license information see the LICENSE file

#import <Foundation/Foundation.h>

/**
 * General superclass object for OmniFocus mapped objects.
 */
@interface JROFObject : NSObject

/**
 * Most objects have a parent - the object one step up in the hierarchy.
 */
@property (atomic) JROFObject *parent;

///---------------------------------
/// @name Initializers and factories
///---------------------------------

/**
 * Default initializer
 */
-(id)initWithParent:(JROFObject *)parent;

/**
 * Default factory
 */
+(id)objectWithParent:(JROFObject *)parent;

///-----------------
/// @name Properties
///-----------------

/**
 * @return The name of the object.
 */
-(NSString *)name;

/**
 * @return Omnifocus' internal ID string/
 */
-(NSString *)id;

/**
 * @return A string representing the hierarchy of folders and projects above this object.
 */
-(NSString *)ancestry;

/**
 * @return Whether or not a given string exists in this object's ancestry.
 */
-(BOOL)hasAncestor:(NSString *)ancestor;

/**
 * @return Has this object been marked complete?
 */
-(BOOL)isCompleted;
@end
