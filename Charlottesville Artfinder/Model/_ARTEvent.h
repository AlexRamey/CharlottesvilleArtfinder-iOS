// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ARTEvent.h instead.

#import <CoreData/CoreData.h>


extern const struct ARTEventAttributes {
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *eventDescription;
	__unsafe_unretained NSString *eventID;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *spanEndDate;
	__unsafe_unretained NSString *spanStartDate;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *title;
} ARTEventAttributes;

extern const struct ARTEventRelationships {
} ARTEventRelationships;

extern const struct ARTEventFetchedProperties {
} ARTEventFetchedProperties;












@interface ARTEventID : NSManagedObjectID {}
@end

@interface _ARTEvent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ARTEventID*)objectID;





@property (nonatomic, strong) NSString* category;



//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* eventDescription;



//- (BOOL)validateEventDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* eventID;



//- (BOOL)validateEventID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* location;



//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* spanEndDate;



//- (BOOL)validateSpanEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* spanStartDate;



//- (BOOL)validateSpanStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _ARTEvent (CoreDataGeneratedAccessors)

@end

@interface _ARTEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCategory;
- (void)setPrimitiveCategory:(NSString*)value;




- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSString*)primitiveEventDescription;
- (void)setPrimitiveEventDescription:(NSString*)value;




- (NSString*)primitiveEventID;
- (void)setPrimitiveEventID:(NSString*)value;




- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;




- (NSDate*)primitiveSpanEndDate;
- (void)setPrimitiveSpanEndDate:(NSDate*)value;




- (NSDate*)primitiveSpanStartDate;
- (void)setPrimitiveSpanStartDate:(NSDate*)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
