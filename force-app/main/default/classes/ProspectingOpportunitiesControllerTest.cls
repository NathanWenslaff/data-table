@isTest
private with sharing class ProspectingOpportunitiesControllerTest {
  private static final String ACCOUNT_NAME1 = 'Test 1';
  private static final String ACCOUNT_NAME2 = 'Test 2';

  private static final String OPPORTUNITY_NAME1 = 'Opportunity 1';
  private static final String OPPORTUNITY_NAME2 = 'Opportunity 2';
  private static final String OPPORTUNITY_NAME3 = 'Opportunity 3';
  private static final String OPPORTUNITY_NAME4 = 'Opportunity 4';

  @TestSetup
  static void setup() {
    Account account1 = new Account(Name = ACCOUNT_NAME1);
    Account account2 = new Account(Name = ACCOUNT_NAME2);

    insert new List<Account>{ account1, account2 };

    Opportunity opportunity1 = new Opportunity(
      AccountId = account1.Id,
      Name = OPPORTUNITY_NAME1,
      CloseDate = Date.today(),
      StageName = Constants.STAGE_NAME_PROSPECTING
    );
    Opportunity opportunity2 = new Opportunity(
      AccountId = account1.Id,
      Name = OPPORTUNITY_NAME2,
      CloseDate = Date.today(),
      StageName = Constants.STAGE_NAME_QUALIFICATION
    );
    Opportunity opportunity3 = new Opportunity(
      AccountId = account2.Id,
      Name = OPPORTUNITY_NAME3,
      CloseDate = Date.today(),
      StageName = Constants.STAGE_NAME_PROSPECTING
    );
    Opportunity opportunity4 = new Opportunity(
      AccountId = account2.Id,
      Name = OPPORTUNITY_NAME4,
      CloseDate = Date.today(),
      StageName = Constants.STAGE_NAME_QUALIFICATION
    );

    insert new List<Opportunity>{
      opportunity1,
      opportunity2,
      opportunity3,
      opportunity4
    };
  }

  @isTest
  static void getProspectingOpportunities() {
    // Given
    Account account1 = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME1];
    Account account2 = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME2];
    Opportunity opportunity1 = [
      SELECT Id
      FROM Opportunity
      WHERE Name = :OPPORTUNITY_NAME1
    ];
    Opportunity opportunity2 = [
      SELECT Id
      FROM Opportunity
      WHERE Name = :OPPORTUNITY_NAME2
    ];
    Opportunity opportunity3 = [
      SELECT Id
      FROM Opportunity
      WHERE Name = :OPPORTUNITY_NAME3
    ];
    Opportunity opportunity4 = [
      SELECT Id
      FROM Opportunity
      WHERE Name = :OPPORTUNITY_NAME4
    ];
    ProspectingOpportunitiesController.mockFields('Id,Name');

    // When
    Test.startTest();

    PaginatedResults result1 = ProspectingOpportunitiesController.getProspectingOpportunities(
      account1.Id
    );
    PaginatedResults result2 = ProspectingOpportunitiesController.getProspectingOpportunities(
      account2.Id
    );

    Test.stopTest();

    // Then
    DescribeFieldResult opportunityIdFieldDescribe = Schema.Opportunity.Id.getDescribe();
    DescribeFieldResult opportunityNameFieldDescribe = Schema.Opportunity.Name.getDescribe();

    System.assertEquals(2, result1.fields.size());
    System.assertEquals(
      opportunityIdFieldDescribe.getName(),
      result1.fields[0].apiName
    );
    System.assertEquals(
      opportunityIdFieldDescribe.getLabel(),
      result1.fields[0].label
    );
    System.assertEquals(
      opportunityNameFieldDescribe.getName(),
      result1.fields[1].apiName
    );
    System.assertEquals(
      opportunityNameFieldDescribe.getLabel(),
      result1.fields[1].label
    );
    System.assertEquals(1, result1.results.size());
    System.assertEquals(opportunity1.Id, ((Opportunity) result1.results[0]).Id);
    System.assertEquals(1, result1.totalResults);
    System.assertEquals(null, result1.error);

    System.assertEquals(2, result2.fields.size());
    System.assertEquals(
      opportunityIdFieldDescribe.getName(),
      result2.fields[0].apiName
    );
    System.assertEquals(
      opportunityIdFieldDescribe.getLabel(),
      result2.fields[0].label
    );
    System.assertEquals(
      opportunityNameFieldDescribe.getName(),
      result2.fields[1].apiName
    );
    System.assertEquals(
      opportunityNameFieldDescribe.getLabel(),
      result2.fields[1].label
    );
    System.assertEquals(1, result2.results.size());
    System.assertEquals(opportunity3.Id, ((Opportunity) result2.results[0]).Id);
    System.assertEquals(1, result2.totalResults);
    System.assertEquals(null, result2.error);
  }
}
