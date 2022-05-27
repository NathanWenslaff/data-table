public with sharing class QueryService {
  public static PaginatedResults getRecords(QueryFactory queryFactory) {
    PaginatedResults paginatedResults = new PaginatedResults();

    try {
      String recordQuery = queryFactory.toRecordQuery();
      String countQuery = queryFactory.toCountQuery();

      paginatedResults.results = Database.query(recordQuery);
      paginatedResults.totalResults = Database.countQuery(countQuery);
      paginatedResults.fields = describeFields(
        queryFactory.getSObjectType(),
        queryFactory.getFields()
      );
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
      fieldDescribes.add(describeField(fieldsMap.get(fieldApiName)));
    }

    return fieldDescribes;
  }

  private static FieldDescribe describeField(SObjectField sObjectField) {
    DescribeFieldResult describeFieldResult = sObjectField.getDescribe();

    FieldDescribe fieldDescribe = new FieldDescribe();
    fieldDescribe.apiName = describeFieldResult.getName();
    fieldDescribe.label = describeFieldResult.getLabel();

    return fieldDescribe;
  }
}
