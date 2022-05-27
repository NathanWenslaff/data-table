public with sharing class QueryFactory {
  private static final String COMMA_SEPARATED_FIELD_NAMES_REGEX = '^[A-Za-z0-9_]+(?:,[A-Za-z0-9_]+)*$';

  SObjectType sObjectType;
  List<String> fields;
  List<String> filters;

  public SObjectType getSObjectType() {
    return this.sObjectType;
  }

  public QueryFactory setSObjectType(SObjectType sObjectType) {
    this.sObjectType = sObjectType;
    return this;
  }

  public List<String> getFields() {
    return this.fields;
  }

  public QueryFactory setFields(String commaSeparatedFields) {
    return this.setFields(
      getFieldApiNamesFromCommaSeparatedList(commaSeparatedFields)
    );
  }

  public QueryFactory setFields(List<String> fields) {
    this.fields = fields;
    return this;
  }

  public QueryFactory setFilters(List<String> filters) {
    this.filters = filters;
    return this;
  }

  public String toRecordQuery() {
    return this.toQuery(false);
  }

  public String toCountQuery() {
    return this.toQuery(true);
  }

  private String toQuery(Boolean isCountQuery) {
    this.validate();

    List<String> clauses = new List<String>();

    // SELECT
    if (isCountQuery) {
      clauses.add('SELECT COUNT()');
    } else {
      clauses.add('SELECT ' + String.join(this.fields, ', '));
    }

    // FROM
    clauses.add('FROM ' + String.valueOf(this.sObjectType));

    // WHERE
    if (this.filters != null && !this.filters.isEmpty()) {
      clauses.add('WHERE ' + String.join(this.filters, ' AND '));
    } else {
      System.debug('No filters included in query');
    }

    return String.join(clauses, ' ');
  }

  private void validate() {
    if (this.sObjectType == null) {
      throw new QueryException(
        'Cannot build SOQL query without an SObjectType'
      );
    } else if (this.fields == null || this.fields.isEmpty()) {
      throw new QueryException(
        'Cannot build SOQL query without a list of fields'
      );
    }
  }

  private static List<String> getFieldApiNamesFromCommaSeparatedList(
    String commaSeparatedFields
  ) {
    Boolean matchesRegex = Pattern.matches(
      COMMA_SEPARATED_FIELD_NAMES_REGEX,
      commaSeparatedFields
    );

    if (matchesRegex) {
      return commaSeparatedFields.split(',');
    } else {
      throw new QueryException(
        'Not a valid list of comma-separated field names'
      );
    }
  }
}
