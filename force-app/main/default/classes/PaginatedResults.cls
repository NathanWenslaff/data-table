public with sharing class PaginatedResults {
    @AuraEnabled public List<FieldDescribe> fields; // list of fields (in order) included in the query
    @AuraEnabled public List<SObject> results; // list of records in this page
    @AuraEnabled public Integer totalResults; // total number of records
    @AuraEnabled public String error;
}
