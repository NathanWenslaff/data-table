@isTest
private with sharing class QueryServiceTest {
  private static final String ACCOUNT_NAME1 = 'Account 1';
  private static final String ACCOUNT_NAME2 = 'Account 2';

  @TestSetup
  static void setup() {
    Account account1 = new Account(Name = ACCOUNT_NAME1);
    Account account2 = new Account(Name = ACCOUNT_NAME2);

    insert new List<Account>{ account1, account2 };
  }

  @isTest
  static void getRecordsWithValidAccountId() {
    // Given
    Account account1 = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME1];
    Account account2 = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME2];

    String filter1 = 'Id = ' + '\'' + account1.Id + '\'';
    String filter2 = 'Id = ' + '\'' + account2.Id + '\'';

    QueryFactory queryFactory1 = new QueryFactory()
      .setSObjectType(Account.SObjectType)
      .setFields(new List<String>{ 'Id', 'Name' })
      .setFilters(new List<String>{ filter1 });

    QueryFactory queryFactory2 = new QueryFactory()
      .setSObjectType(Account.SObjectType)
      .setFields(new List<String>{ 'Id', 'Name' })
      .setFilters(new List<String>{ filter2 });

    // When
    Test.startTest();

    PaginatedResults result1 = QueryService.getRecords(queryFactory1);
    PaginatedResults result2 = QueryService.getRecords(queryFactory2);

    Test.stopTest();

    // Then
    DescribeFieldResult accountIdFieldDescribe = Schema.Account.Id.getDescribe();
    DescribeFieldResult accountNameFieldDescribe = Schema.Account.Name.getDescribe();

    System.assertEquals(2, result1.fields.size());
    System.assertEquals(
      accountIdFieldDescribe.getName(),
      result1.fields[0].apiName
    );
    System.assertEquals(
      accountIdFieldDescribe.getLabel(),
      result1.fields[0].label
    );
    System.assertEquals(
      accountNameFieldDescribe.getName(),
      result1.fields[1].apiName
    );
    System.assertEquals(
      accountNameFieldDescribe.getLabel(),
      result1.fields[1].label
    );
    System.assertEquals(1, result1.results.size());
    System.assertEquals(account1.Id, ((Account) result1.results[0]).Id);
    System.assertEquals(1, result1.totalResults);
    System.assertEquals(null, result1.error);

    System.assertEquals(2, result2.fields.size());
    System.assertEquals(
      accountIdFieldDescribe.getName(),
      result2.fields[0].apiName
    );
    System.assertEquals(
      accountIdFieldDescribe.getLabel(),
      result2.fields[0].label
    );
    System.assertEquals(
      accountNameFieldDescribe.getName(),
      result2.fields[1].apiName
    );
    System.assertEquals(
      accountNameFieldDescribe.getLabel(),
      result2.fields[1].label
    );
    System.assertEquals(1, result2.results.size());
    System.assertEquals(account2.Id, ((Account) result2.results[0]).Id);
    System.assertEquals(1, result2.totalResults);
    System.assertEquals(null, result2.error);
  }

  @isTest
  static void getRecordsWithInvalidAccountId() {
    // Given
    Account account1 = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME1];

    String filter1 = 'Id = \'invalid id\'';

    QueryFactory queryFactory1 = new QueryFactory()
      .setSObjectType(Account.SObjectType)
      .setFields(new List<String>{ 'Id', 'Name' })
      .setFilters(new List<String>{ filter1 });

    // When
    Test.startTest();

    PaginatedResults result1 = QueryService.getRecords(queryFactory1);

    Test.stopTest();

    // Then
    System.assertEquals(2, result1.fields.size());

    DescribeFieldResult fieldDescribe = Schema.Account.Id.getDescribe();
    System.assertEquals(fieldDescribe.getName(), result1.fields[0].apiName);
    System.assertEquals(fieldDescribe.getLabel(), result1.fields[0].label);

    fieldDescribe = Schema.Account.Name.getDescribe();
    System.assertEquals(fieldDescribe.getName(), result1.fields[1].apiName);
    System.assertEquals(fieldDescribe.getLabel(), result1.fields[1].label);

    System.assertEquals(null, result1.results);
    System.assertEquals('invalid ID field: invalid id', result1.error);
  }
}
