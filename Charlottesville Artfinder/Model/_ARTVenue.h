// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ARTVenue.h instead.

#import <CoreData/CoreData.h>


extern const struct ARTVenueAttributes {
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *deleted;
	__unsafe_unretained NSString *emailAddress;
	__unsafe_unretained NSString *homepageURL;
	__unsafe_unretained NSString *imageURL;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *localImagePath;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *organizationName;
	__unsafe_unretained NSString *parseObjectID;
	__unsafe_unretained NSString *phone;
	__unsafe_unretained NSString *primaryCategory;
	__unsafe_unretained NSString *secondaryCategory;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *streetAddress;
	__unsafe_unretained NSString *thumbnailData;
	__unsafe_unretained NSString *updatedAt;
	__unsafe_unretained NSString *venueDescription;
	__unsafe_unretained NSString *zip;
} ARTVenueAttributes;

extern const struct ARTVenueRelationships {
} ARTVenueRelationships;

extern const struct ARTVenueFetchedProperties {
} ARTVenueFetchedProperties;























@interface ARTVenueID : NSManagedObjectID {}
@end

@interface _ARTVenue : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ARTVenueID*)objectID;





@property (nonatomic, strong) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* deleted;



//- (BOOL)validateDeleted:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* emailAddress;



//- (BOOL)validateEmailAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* homepageURL;



//- (BOOL)validateHomepageURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* imageURL;



//- (BOOL)validateImageURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* localImagePath;



//- (BOOL)validateLocalImagePath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* organizationName;



//- (BOOL)validateOrganizationName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* parseObjectID;



//- (BOOL)validateParseObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* phone;



//- (BOOL)validatePhone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* primaryCategory;



//- (BOOL)validatePrimaryCategory:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* secondaryCategory;



//- (BOOL)validateSecondaryCategory:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* state;



//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* streetAddress;



//- (BOOL)validateStreetAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSData* thumbnailData;



//- (BOOL)validateThumbnailData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* venueDescription;



//- (BOOL)validateVenueDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* zip;



@property int32_t zipValue;
- (int32_t)zipValue;
- (void)setZipValue:(int32_t)value_;

//- (BOOL)validateZip:(id*)value_ error:(NSError**)error_;






@end

@interface _ARTVenue (CoreDataGeneratedAccessors)

@end

@interface _ARTVenue (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSString*)primitiveDeleted;
- (void)setPrimitiveDeleted:(NSString*)value;




- (NSString*)primitiveEmailAddress;
- (void)setPrimitiveEmailAddress:(NSString*)value;




- (NSString*)primitiveHomepageURL;
- (void)setPrimitiveHomepageURL:(NSString*)value;




- (NSString*)primitiveImageURL;
- (void)setPrimitiveImageURL:(NSString*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSString*)primitiveLocalImagePath;
- (void)setPrimitiveLocalImagePath:(NSString*)value;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSString*)primitiveOrganizationName;
- (void)setPrimitiveOrganizationName:(NSString*)value;




- (NSString*)primitiveParseObjectID;
- (void)setPrimitiveParseObjectID:(NSString*)value;




- (NSString*)primitivePhone;
- (void)setPrimitivePhone:(NSString*)value;




- (NSString*)primitivePrimaryCategory;
- (void)setPrimitivePrimaryCategory:(NSString*)value;




- (NSString*)primitiveSecondaryCategory;
- (void)setPrimitiveSecondaryCategory:(NSString*)value;




- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;




- (NSString*)primitiveStreetAddress;
- (void)setPrimitiveStreetAddress:(NSString*)value;




- (NSData*)primitiveThumbnailData;
- (void)setPrimitiveThumbnailData:(NSData*)value;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;




- (NSString*)primitiveVenueDescription;
- (void)setPrimitiveVenueDescription:(NSString*)value;




- (NSNumber*)primitiveZip;
- (void)setPrimitiveZip:(NSNumber*)value;

- (int32_t)primitiveZipValue;
- (void)setPrimitiveZipValue:(int32_t)value_;




@end
