public with sharing class QueryService {
  /**
   * @description Queries for records based on the provided QueryFactory instance
   * @param  queryFactory Builds the SOQL queries needed to get the records
   * @return              Returns a paginated list of records
   */
  public static PaginatedResults getRecords(QueryFactory queryFactory) {
    PaginatedResults paginatedResults = new PaginatedResults();

    try {
      String recordQuery = queryFactory.toRecordQuery();
      String countQuery = queryFactory.toCountQuery();

      paginatedResults.fields = describeFields(
        queryFactory.getSObjectType(),
        queryFactory.getFields()
      );
      paginatedResults.results = Database.query(recordQuery);
      paginatedResults.totalResults = Database.countQuery(countQuery);
    } catch (Exception e) {
      paginatedResults.error = e.getMessage();
    }

    return paginatedResults;
  }

  private static List<FieldDescribe> describeFields(
    SObjectType sObjectType,
    List<String> fieldApiNames
  ) {
    DescribeSObjectResult describeResult = sObjectType.getDescribe();
    Map<String, SObjectField> fieldsMap = describeResult.fields.getMap();
    List<FieldDescribe> fieldDescribes = new List<FieldDescribe>();

    for (String fieldApiName : fieldApiNames) {
      SObjectField sObjectField = fieldsMap.get(fieldApiName);
      fieldDescribes.add(new FieldDescribe(sObjectField));
    }

    return fieldDescribes;
  }
}
