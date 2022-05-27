public with sharing class ProspectingOpportunitiesController {
  @AuraEnabled
  public static PaginatedResults getProspectingOpportunities(String accountId) {
    String filter1 =
      'AccountId = ' +
      '\'' +
      String.escapeSingleQuotes(accountId) +
      '\'';
    String filter2 = 'StageName = \'' + Constants.STAGE_NAME_PROSPECTING + '\'';

    QueryFactory queryFactory = new QueryFactory()
      .setSObjectType(Opportunity.SObjectType)
      .setFields(Label.Prospecting_Opportunity_Fields)
      .setFilters(new List<String>{ filter1, filter2 });

    return QueryService.getRecords(queryFactory);
  }
}
