public with sharing class ProspectingOpportunitiesController {
  @AuraEnabled
  public static PaginatedResults getProspectingOpportunities(String accountId) {
    System.debug('accountId: ' + accountId);

    List<String> fieldApiNames = QueryService.getFieldApiNamesFromCommaSeparatedList(
      Label.Prospecting_Opportunity_Fields
    );

    System.debug('fieldApiNames: ' + fieldApiNames);

    List<String> filters = new List<String>{
      'AccountId = ' +
      '\'' +
      String.escapeSingleQuotes(accountId) +
      '\''
    };

    return QueryService.getRecords(
      fieldApiNames,
      Opportunity.SObjectType,
      filters
    );
  }
}
