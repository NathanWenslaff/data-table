public with sharing class FieldDescribe {
  @AuraEnabled
  public String apiName;
  @AuraEnabled
  public String label;

  public FieldDescribe(SObjectField sObjectField) {
    DescribeFieldResult describeFieldResult = sObjectField.getDescribe();

    this.apiName = describeFieldResult.getName();
    this.label = describeFieldResult.getLabel();
  }
}
