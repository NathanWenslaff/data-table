@isTest
private with sharing class QueryFactoryTest {
  @isTest
  static void getters() {
    // Given
    SObjectType sObjectType = Account.SObjectType;
    List<String> fields = new List<String>{ String.valueOf(Account.Id) };

    // When
    Test.startTest();

    QueryFactory queryFactory = new QueryFactory()
      .setSObjectType(sObjectType)
      .setFields(fields);

    Test.stopTest();

    // Then
    System.assertEquals(sObjectType, queryFactory.getSObjectType());
    System.assertEquals(fields, queryFactory.getFields());
  }

  @isTest
  static void noFilters() {
    // Given
    SObjectType sObjectType = Account.SObjectType;
    List<String> fields = new List<String>{ String.valueOf(Account.Id) };

    // When
    Test.startTest();

    QueryFactory queryFactory = new QueryFactory()
      .setSObjectType(sObjectType)
      .setFields(fields);

    String recordQueryResult = queryFactory.toRecordQuery();
    String countQueryResult = queryFactory.toCountQuery();

    Test.stopTest();

    // Then
    System.assertEquals(sObjectType, queryFactory.getSObjectType());
    System.assertEquals('SELECT Id FROM Account', recordQueryResult);
    System.assertEquals('SELECT COUNT() FROM Account', countQueryResult);
  }

  @isTest
  static void withOneFilter() {
    // Given
    SObjectType sObjectType = Account.SObjectType;
    List<String> fields = new List<String>{ String.valueOf(Account.Id) };
    List<String> filters = new List<String>{ 'AccountNumber != null' };

    // When
    Test.startTest();

    QueryFactory queryFactory = new QueryFactory()
      .setSObjectType(sObjectType)
      .setFields(fields)
      .setFilters(filters);

    String recordQueryResult = queryFactory.toRecordQuery();
    String countQueryResult = queryFactory.toCountQuery();

    Test.stopTest();

    // Then
    System.assertEquals(
      'SELECT Id FROM Account WHERE AccountNumber != null',
      recordQueryResult
    );
    System.assertEquals(
      'SELECT COUNT() FROM Account WHERE AccountNumber != null',
      countQueryResult
    );
  }

  @isTest
  static void withTwoFilters() {
    // Given
    SObjectType sObjectType = Account.SObjectType;
    List<String> fields = new List<String>{ String.valueOf(Account.Id) };
    List<String> filters = new List<String>{
      'AccountNumber != null',
      'Type = \'Prospect\''
    };

    // When
    Test.startTest();

    QueryFactory queryFactory = new QueryFactory()
      .setSObjectType(sObjectType)
      .setFields(fields)
      .setFilters(filters);

    String recordQueryResult = queryFactory.toRecordQuery();
    String countQueryResult = queryFactory.toCountQuery();

    Test.stopTest();

    // Then
    System.assertEquals(
      'SELECT Id FROM Account WHERE AccountNumber != null AND Type = \'Prospect\'',
      recordQueryResult
    );
    System.assertEquals(
      'SELECT COUNT() FROM Account WHERE AccountNumber != null AND Type = \'Prospect\'',
      countQueryResult
    );
  }

  @isTest
  static void withInvalidCommaSeparatedFieldNames() {
    // Given
    SObjectType sObjectType = Account.SObjectType;
    Exception error;

    // When
    Test.startTest();

    try {
      QueryFactory queryFactory = new QueryFactory()
        .setSObjectType(sObjectType)
        .setFields('(Invalid)');
    } catch (Exception e) {
      // expected behavior
      error = e;
    }

    Test.stopTest();

    // Then
    System.assertEquals(
      'Not a valid list of comma-separated field names',
      error.getMessage()
    );
  }

  @isTest
  static void withValidCommaSeparatedFieldNames() {
    // Given
    SObjectType sObjectType = Account.SObjectType;
    String fields = 'Id,AccountNumber';

    // When
    Test.startTest();

    QueryFactory queryFactory = new QueryFactory()
      .setSObjectType(sObjectType)
      .setFields(fields);

    String recordQueryResult = queryFactory.toRecordQuery();
    String countQueryResult = queryFactory.toCountQuery();

    Test.stopTest();

    // Then
    System.assertEquals(
      'SELECT Id, AccountNumber FROM Account',
      recordQueryResult
    );
    System.assertEquals('SELECT COUNT() FROM Account', countQueryResult);
  }

  @isTest
  static void withMissingSObjectType() {
    // Given
    List<String> fields = new List<String>{ String.valueOf(Account.Id) };
    Exception error;

    // When
    Test.startTest();

    try {
      QueryFactory queryFactory = new QueryFactory().setFields(fields);
      queryFactory.toRecordQuery();
    } catch (Exception e) {
      // expected behavior
      error = e;
    }

    Test.stopTest();

    // Then
    System.assertEquals(
      'Cannot build SOQL query without an SObjectType',
      error.getMessage()
    );
  }

  @isTest
  static void withMissingFields() {
    // Given
    SObjectType sObjectType = Account.SObjectType;
    Exception error;

    // When
    Test.startTest();

    try {
      QueryFactory queryFactory = new QueryFactory()
        .setSObjectType(sObjectType);
      queryFactory.toRecordQuery();
    } catch (Exception e) {
      // expected behavior
      error = e;
    }

    Test.stopTest();

    // Then
    System.assertEquals(
      'Cannot build SOQL query without a list of fields',
      error.getMessage()
    );
  }
}
