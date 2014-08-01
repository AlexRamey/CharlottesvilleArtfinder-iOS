// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ARTEvent.m instead.

#import "_ARTEvent.h"

const struct ARTEventAttributes ARTEventAttributes = {
	.category = @"category",
	.endDate = @"endDate",
	.eventDescription = @"eventDescription",
	.eventID = @"eventID",
	.location = @"location",
	.spanEndDate = @"spanEndDate",
	.spanStartDate = @"spanStartDate",
	.startDate = @"startDate",
	.title = @"title",
};

const struct ARTEventRelationships ARTEventRelationships = {
};

const struct ARTEventFetchedProperties ARTEventFetchedProperties = {
};

@implementation ARTEventID
@end

@implementation _ARTEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ARTEvent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ARTEvent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ARTEvent" inManagedObjectContext:moc_];
}

- (ARTEventID*)objectID {
	return (ARTEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic category;






@dynamic endDate;






@dynamic eventDescription;






@dynamic eventID;






@dynamic location;






@dynamic spanEndDate;






@dynamic spanStartDate;






@dynamic startDate;






@dynamic title;











@end
