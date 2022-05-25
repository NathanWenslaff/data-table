public with sharing class QueryService {
  private static final String COMMA_SEPARATED_FIELD_NAMES_REGEX = '^[A-Za-z0-9_]+(?:,[A-Za-z0-9_]+)*$';

  public static PaginatedResults getRecords(
    List<String> fieldApiNames,
    SObjectType sObjectType,
    List<String> filters
  ) {
    System.debug('fieldApiNames: ' + fieldApiNames);
    System.debug('sObjectType: ' + sObjectType);
    System.debug('filters: ' + filters);

    PaginatedResults paginatedResults = new PaginatedResults();

    try {
      System.debug('Building SOQL query');

      QueryFactory queryFactory = new QueryFactory()
        .setSObjectType(String.valueOf(sObjectType))
        .setFields(fieldApiNames)
        .setFilters(filters);

      String recordQuery = queryFactory.toRecordQuery();
      String countQuery = queryFactory.toCountQuery();

      System.debug('recordQuery: ' + recordQuery);
      System.debug('countQuery: ' + countQuery);

      paginatedResults.results = Database.query(recordQuery);
      paginatedResults.totalResults = Database.countQuery(countQuery);
      paginatedResults.fields = describeFields(sObjectType, fieldApiNames);
    } catch (Exception e) {
      paginatedResults.error = e.getMessage();
    }

    return paginatedResults;
  }

  public static List<String> getFieldApiNamesFromCommaSeparatedList(
    String commaSeparatedFields
  ) {
    System.debug('commaSeparatedFields: ' + commaSeparatedFields);

    Boolean matchesRegex = Pattern.matches(
      COMMA_SEPARATED_FIELD_NAMES_REGEX,
      commaSeparatedFields
    );

    System.debug('matchesRegex: ' + matchesRegex);

    if (matchesRegex) {
      return commaSeparatedFields.split(',');
    } else {
      throw new QueryException(
        'Not a valid list of comma-separated field names'
      );
    }
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
