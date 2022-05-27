@isTest
private with sharing class FieldDescribeTest {
  @isTest
  static void constructor() {
    // Given
    SObjectField sObjectField1 = Account.Id;
    SObjectField sObjectField2 = Account.Name;
    SObjectField sObjectField3 = Account.AccountNumber;

    // When
    Test.startTest();

    FieldDescribe result1 = new FieldDescribe(sObjectField1);
    FieldDescribe result2 = new FieldDescribe(sObjectField2);
    FieldDescribe result3 = new FieldDescribe(sObjectField3);

    Test.stopTest();

    // Then
    DescribeFieldResult describeFieldResult = sObjectField1.getDescribe();
    System.assertEquals(describeFieldResult.getName(), result1.apiName);
    System.assertEquals(describeFieldResult.getLabel(), result1.label);

    describeFieldResult = sObjectField2.getDescribe();
    System.assertEquals(describeFieldResult.getName(), result2.apiName);
    System.assertEquals(describeFieldResult.getLabel(), result2.label);

    describeFieldResult = sObjectField3.getDescribe();
    System.assertEquals(describeFieldResult.getName(), result3.apiName);
    System.assertEquals(describeFieldResult.getLabel(), result3.label);
  }
}
