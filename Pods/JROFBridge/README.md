# JROFBridge

[![Version](https://img.shields.io/cocoapods/v/JROFBridge.svg?style=flat)](http://cocoadocs.org/docsets/JROFBridge)
[![License](https://img.shields.io/cocoapods/l/JROFBridge.svg?style=flat)](http://cocoadocs.org/docsets/JROFBridge)
[![Platform](https://img.shields.io/cocoapods/p/JROFBridge.svg?style=flat)](http://cocoadocs.org/docsets/JROFBridge)

Cocoa wrapper around OmniFocus' ScriptingBridge functionality. Navigate the project/folder/task tree, skip projects, write to a SQLite database.

## Usage

The OmniFocus application is represented by an instance of `JROmniFocus`, which can be loaded via `+[JROmniFocus instance]`:

```
#import <JROFBridge/JROmniFocus.h>

JROmniFocus *of = [JROmniFocus instance];

if (of == nil)
  NSLog(@"Looks like OmniFocus isn't running right now.");
else {
  switch (of.version) {
  case JROmniFocusVersion1:
    NSLog(@"OmniFocus 1 installed.");
    break;
  case JROmniFocusVersion2:
    NSLog(@"OmniFocus 2 Standard installed.");
    break;
  case JROmniFocusVersion2Pro:
    NSLog(@"OmniFocus 2 Pro installed.");
  }
}
```

You can fetch the documents' folder and projects via the appropriate properties (and fetch *their* folders and projects in a similar manner):

```
for (JRProject *p in of.projects)
  NSLog(@"Iterating over project: %@",p.name);

for (JRFolder *f in of.folders) {
  NSLog(@"Iterating over folder: %@", f.name);
  for (JRProject *p in f.projects)
    NSLog(@"  - Project: %@", p.name);
}
```

### Iterators

Want to perform an action on every task or project? There's a shiny method for that:

```
[of eachProject:(void ^(JRProject *p)){
  NSLog(@"I'm now iterating over the project: %@", p);  
}];

NSLog(@"List of completed tasks:");
[of eachTask:(void ^(JRTask *t)){
  if (t.isCompleted)
    NSLog(@"- %@ [%@]", t.name, t.id);
}];
```

Want to perform the same action on tasks *and* projects? Both classes subclass from `JROFObject`, which gives you some handy common methods.

```
NSLog(@"List of completed projects and tasks:");

void (^block)(JROFObject *) = ^(JROFObject *o){
  if (o.isCompleted) NSLog(@"[%@] %@", o.className, o.name);
};

[of eachProject:block];
[of eachTask:   block];
```

### Saving to file

`JROFBridge` comes with a handy serialization class, built on top of Flying Meat's [FMDB](https://github.com/ccgus/fmdb):

```
#import <JROFBridge/JRDatabase.h>

JRDatabase *db = [JRDatabase databaseWithLocation:@"database.db" type: JRDatabaseProjects];
```

You can make a database that records just tasks, just projects, or both using the `type` variable:

* `JRDatabaseTasks`: Just store tasks in this database
* `JRDatabaseProjects`: Just store projects in this database
* `(JRDatabaseProjects | JRDatabaseTasks)`: Store projects and tasks in this database

Would you like to make sure your database could possibly exist? What about if there's an existing database and you need to make sure that you can save everything to it? There's a method for that.

```
db.canExist # Returns false if the location is illegal (e.g. containing folder does not exist).

switch (db.overlapWithDatabaseFile) {
  case JRDatabaseExactMatch:
    NSLog(@"This database has just the right set of tables for us (and no more).");
    break;
  case JRDatabaseSubset:
    NSLog(@"This database has all the tables we need and more.");
    break;
  case JRDatabaseDoesNotExist:
    NSLog(@"There's no database here. When needed, I'll create one.");
    break;
  case JRDatabaseDoesNotMatch:
    NSLog(@"The database doesn't have the right set of tables for us.");
}

// An example:

JRDatabase *db1 = [JRDatabase databaseWithLocation:@"justProjects.db" type:JRDatabaseProjects];
[db1 database]; //Lazily create the database

JRDatabase *db2 = [JRDatabase databaseWithLocation:@"justProjects.db" type: (JRDatabaseProjects | JRDatabaseTasks)];
db.overlapWithDatabaseFile; //db2 needs a "projects" and "tasks" table, but only the "projects" table exists. Returns JRDatabaseDoesNotMatch
```

If you want to replace a database (as opposed to updating an existing database) you can use `-[JRDatabase purgeDatabase]`, which deletes the file and creates a new database for you.

Write to the database using `-[JRDatabase saveOFObject:(JROFObject *)o]`. This calls `-[JRDatabase saveTask:(JRTask *)t]` or `-[JRDatabase saveProject:(JRProject *)p]` as required.

## Requirements

* OmniFocus 1 or OmniFocus 2 Pro

**Note:** This binary is built and tested on OS X 10.9.3 "Mavericks", and I can't guarantee that it'll run smoothly or efficiently on any other platform. If you have any tales of success or failure on other versions of OS X, [let me know](mailto:jan@1klb.com) and I'll update accordingly.

## Installation

JROFBridge is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "JROFBridge", :git => "https://www.github.com/jyruzicka/JROFBridge.git"

## Author

Jan-Yves Ruzicka, jan@1klb.com

## License

JROFBridge is available under the MIT license. See the LICENSE file for more info.