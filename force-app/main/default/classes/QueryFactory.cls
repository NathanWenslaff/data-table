public with sharing class QueryFactory {
  String sObjectType;
  List<String> fields;
  List<String> filters;

  public QueryFactory setSObjectType(String sObjectType) {
    this.sObjectType = sObjectType;
    return this;
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
    clauses.add('FROM ' + this.sObjectType);

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
}
