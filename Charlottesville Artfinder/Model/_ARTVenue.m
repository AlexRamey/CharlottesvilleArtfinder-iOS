// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ARTVenue.m instead.

#import "_ARTVenue.h"

const struct ARTVenueAttributes ARTVenueAttributes = {
	.city = @"city",
	.createdAt = @"createdAt",
	.deletedStatus = @"deletedStatus",
	.emailAddress = @"emailAddress",
	.homepageURL = @"homepageURL",
	.imageURL = @"imageURL",
	.latitude = @"latitude",
	.localImagePath = @"localImagePath",
	.longitude = @"longitude",
	.organizationName = @"organizationName",
	.parseObjectID = @"parseObjectID",
	.phone = @"phone",
	.primaryCategory = @"primaryCategory",
	.secondaryCategory = @"secondaryCategory",
	.state = @"state",
	.streetAddress = @"streetAddress",
	.thumbnailData = @"thumbnailData",
	.updatedAt = @"updatedAt",
	.venueDescription = @"venueDescription",
	.zip = @"zip",
};

const struct ARTVenueRelationships ARTVenueRelationships = {
};

const struct ARTVenueFetchedProperties ARTVenueFetchedProperties = {
};

@implementation ARTVenueID
@end

@implementation _ARTVenue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ARTVenue" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ARTVenue";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ARTVenue" inManagedObjectContext:moc_];
}

- (ARTVenueID*)objectID {
	return (ARTVenueID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"zipValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"zip"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic city;






@dynamic createdAt;






@dynamic deletedStatus;






@dynamic emailAddress;






@dynamic homepageURL;






@dynamic imageURL;






@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic localImagePath;






@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic organizationName;






@dynamic parseObjectID;






@dynamic phone;






@dynamic primaryCategory;






@dynamic secondaryCategory;






@dynamic state;






@dynamic streetAddress;






@dynamic thumbnailData;






@dynamic updatedAt;






@dynamic venueDescription;






@dynamic zip;



- (int32_t)zipValue {
	NSNumber *result = [self zip];
	return [result intValue];
}

- (void)setZipValue:(int32_t)value_ {
	[self setZip:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveZipValue {
	NSNumber *result = [self primitiveZip];
	return [result intValue];
}

- (void)setPrimitiveZipValue:(int32_t)value_ {
	[self setPrimitiveZip:[NSNumber numberWithInt:value_]];
}










@end
