Feature: Outputting Value Objects

  @announce
  Scenario: Generating a Builder
    Given a file named "project/values/RMPage.value" with:
      """
      %library name=MyLib
      %type name=RMSomeObject library=SomeLib file=AnotherFile
      %type name=RMFooObject
      %type name=RMSomeEnum canForwardDeclare=false
      RMPage includes(RMBuilder) {
        BOOL doesUserLike
        NSString* identifier
        NSInteger likeCount
        RMRating* rating
        RMEnum(NSUInteger) someEnumValue
        %import library=RMCustomLibrary
        RMLibType* customLibObject
      }
      """
    And a file named "project/.valueObjectConfig" with:
      """
      { }
      """
    When I run `../../bin/generate project`
    Then the file "project/values/RMPageBuilder.h" should contain:
      """
      #import <Foundation/Foundation.h>
      #import <MyLib/RMSomeEnum.h>
      #import <MyLib/RMEnum.h>

      @class RMPage;
      @class RMSomeObject;
      @class RMFooObject;
      @class RMRating;
      @class RMLibType;

      @interface RMPageBuilder : NSObject

      + (instancetype)page;

      + (instancetype)pageFromExistingPage:(RMPage *)existingPage;

      - (RMPage *)build;

      - (instancetype)withDoesUserLike:(BOOL)doesUserLike;

      - (instancetype)withIdentifier:(NSString *)identifier;

      - (instancetype)withLikeCount:(NSInteger)likeCount;

      - (instancetype)withRating:(RMRating *)rating;

      - (instancetype)withSomeEnumValue:(RMEnum)someEnumValue;

      - (instancetype)withCustomLibObject:(RMLibType *)customLibObject;

      @end

      """
   And the file "project/values/RMPageBuilder.m" should contain:
      """
      #import <MyLib/RMPage.h>
      #import "RMPageBuilder.h"
      #import <MyLib/RMRating.h>
      #import <RMCustomLibrary/RMLibType.h>

      @implementation RMPageBuilder
      {
        BOOL _doesUserLike;
        NSString *_identifier;
        NSInteger _likeCount;
        RMRating *_rating;
        RMEnum _someEnumValue;
        RMLibType *_customLibObject;
      }

      + (instancetype)page
      {
        return [[RMPageBuilder alloc] init];
      }

      + (instancetype)pageFromExistingPage:(RMPage *)existingPage
      {
        return [[[[[[[RMPageBuilder page]
                     withDoesUserLike:existingPage.doesUserLike]
                    withIdentifier:existingPage.identifier]
                   withLikeCount:existingPage.likeCount]
                  withRating:existingPage.rating]
                 withSomeEnumValue:existingPage.someEnumValue]
                withCustomLibObject:existingPage.customLibObject];
      }

      - (RMPage *)build
      {
        return [[RMPage alloc] initWithDoesUserLike:_doesUserLike identifier:_identifier likeCount:_likeCount rating:_rating someEnumValue:_someEnumValue customLibObject:_customLibObject];
      }

      - (instancetype)withDoesUserLike:(BOOL)doesUserLike
      {
        _doesUserLike = doesUserLike;
        return self;
      }

      - (instancetype)withIdentifier:(NSString *)identifier
      {
        _identifier = [identifier copy];
        return self;
      }

      - (instancetype)withLikeCount:(NSInteger)likeCount
      {
        _likeCount = likeCount;
        return self;
      }

      - (instancetype)withRating:(RMRating *)rating
      {
        _rating = [rating copy];
        return self;
      }

      - (instancetype)withSomeEnumValue:(RMEnum)someEnumValue
      {
        _someEnumValue = someEnumValue;
        return self;
      }

      - (instancetype)withCustomLibObject:(RMLibType *)customLibObject
      {
        _customLibObject = [customLibObject copy];
        return self;
      }

      @end

      """
