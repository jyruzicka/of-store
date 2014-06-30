#import "JRDatabaseQuery.h"

@implementation JRDatabaseQuery

#pragma mark Initializers and factories

-(id)initForTable:(NSString *)table {
  return [self initForTable:table values:[NSMutableDictionary dictionary]];
}

-(id)initForTable:(NSString *)table values:(NSDictionary *)values {
   if (self = [super init]) {
    self.table = table;
    self.values = [NSMutableDictionary dictionaryWithDictionary: values];
    self.primaryKey = @"id";
  }

  return self;
}

+(JRDatabaseQuery *)queryForTable:(NSString *)table {
  return [[self alloc] initForTable:table];
}

+(JRDatabaseQuery *)queryForTable:(NSString *)table values: (NSDictionary *)values {
  return [[self alloc] initForTable:table values:values];
}

#pragma mark Add values
-(void)addValue:(id)value forKey:(NSString *)key {
  self.values[key] = value;
}

-(BOOL)removeKey:(NSString *)key{
  if ([self.values objectForKey:key]) {
    [self.values removeObjectForKey:key];
    return YES;
  }
  else return NO;
}

#pragma mark - Strings for actions
-(NSString *)insert:(NSArray **)values {
  //Question marks
  NSMutableArray *qmarks = [NSMutableArray arrayWithCapacity:self.values.count];
  for (int i=0;i<self.values.count;i++) [qmarks addObject:@"?"];

  //Key strings
  NSArray *dkeys = self.values.allKeys;

  //Value strings
  NSMutableArray *dvalues = [NSMutableArray array]; //Ensure order is maintained
  for (NSString *k in dkeys) [dvalues addObject: self.values[k]];
  *values = [NSArray arrayWithArray: dvalues];

  //Return a string
  return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);",
                   self.table,[dkeys componentsJoinedByString:@","],
                   [qmarks componentsJoinedByString:@","]];
}

-(NSString *)update:(NSArray **)values {
  NSArray *keys;
  id pKeyValue = [self primaryKeyValueWithRemainder:&keys];
  
  //Value strings
  NSMutableArray *keyStrings = [NSMutableArray array];
  NSMutableArray *rValues = [NSMutableArray array]; //Ensure order is maintained
  for (NSString *k in keys) {
    [rValues addObject: self.values[k]];
    [keyStrings addObject: [NSString stringWithFormat:@"%@=?", k]];
  }
  [rValues addObject:pKeyValue]; //Primary key goes on the end

  *values = [NSArray arrayWithArray: rValues];

  //Return a string
  return [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?;",
                   self.table,[keyStrings componentsJoinedByString:@","],
                   self.primaryKey];
}

-(NSString *)create {
  NSArray *keys;
  NSString *pKeyType = (NSString *)[self primaryKeyValueWithRemainder:&keys];

  //Now make columns
  NSMutableArray *columns = [NSMutableArray array];
  for (NSString *k in keys)
    [columns addObject:[NSString stringWithFormat:@"%@ %@",k, self.values[k]]];

  //Make into query
  return [NSString stringWithFormat:@"CREATE TABLE %@ (%@ %@ PRIMARY KEY,%@);",
                   self.table, self.primaryKey, pKeyType, [columns componentsJoinedByString:@","]];
}

-(NSString *)count:(id *)value {
  *value = [self primaryKeyValueWithRemainder:nil];
  return [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@=?",self.table, self.primaryKey];
}

#pragma mark Private methods

-(id)primaryKeyValueWithRemainder:(NSArray **)keys {
  id v = [self.values objectForKey:self.primaryKey];
  if (v) {
    if (keys) {
      NSMutableArray *mKeys = [NSMutableArray arrayWithArray:self.values.allKeys];
      [mKeys removeObject:self.primaryKey];
      *keys = [NSArray arrayWithArray:mKeys];
    }
  }
  else {
    NSString *er = [NSString stringWithFormat: @"No primary key value given (table: %@, primary key: %@).",self.table,self.primaryKey];
    NSException *e = [NSException exceptionWithName:@"PrimaryKeyNotSetException" reason:er userInfo:nil];
    [e raise];
  }
  return v;
}
@end