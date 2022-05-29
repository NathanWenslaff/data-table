public with sharing class ProspectingOpportunitiesController {
  @TestVisible
  private static String mockFields;

  @AuraEnabled
  public static PaginatedResults getProspectingOpportunities(String accountId) {
    try {
      String filter1 =
        'AccountId = \'' +
        String.escapeSingleQuotes(accountId) +
        '\'';
      String filter2 =
        'StageName = \'' +
        Constants.STAGE_NAME_PROSPECTING +
        '\'';
      String fields = mockFields != null
        ? mockFields
        : Label.Prospecting_Opportunity_Fields; // no code coverage for this line

      QueryFactory queryFactory = new QueryFactory()
        .setSObjectType(Opportunity.SObjectType)
        .setFields(fields)
        .setFilters(new List<String>{ filter1, filter2 });

      return QueryService.getRecords(queryFactory);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  // Custom Labels are dynamic and we want to make sure unit tests work as expected regardless of the value of the custom label
  @TestVisible
  private static void mockFields(String commaSeparatedFields) {
    mockFields = commaSeparatedFields;
  }
}
