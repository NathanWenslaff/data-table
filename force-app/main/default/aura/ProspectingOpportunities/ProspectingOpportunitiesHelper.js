({
  getRecords: function (component) {
    var action = component.get("c.getProspectingOpportunities");
    action.setParams({ accountId: component.get("v.recordId") });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var paginatedResults = response.getReturnValue();
        component.set("v.records", paginatedResults.results);
        component.set("v.fields", paginatedResults.fields);

        if (paginatedResults.error) {
          component.set("v.message", paginatedResults.error);
        } else if (paginatedResults.results.length === 0) {
          component.set(
            "v.message",
            "No Prospecting Opportunity records found"
          );
        }
      } else {
        component.set("v.message", response.getError()[0]);
      }

      component.set("v.loading", false);
    });
    $A.enqueueAction(action);
  },

  createRecord: function (component, event, helper) {
    var opportunityRecordCreator = component.find("opportunityRecordCreator");
    opportunityRecordCreator.getNewRecord(
      "Opportunity",
      null,
      false,
      $A.getCallback(function () {
        var record = component.get("v.newOpportunity"),
          dateStringFormat = "YYYY-MM-DD",
          dateStringYYYYMMDD = $A.localizationService.formatDate(
            new Date(),
            dateStringFormat
          ),
          newOpportunityError = opportunityRecordCreator.get("v.targetError");

        if (newOpportunityError || !record) {
          component.set(
            "v.message",
            "Failed to initialize a new Opportunity record"
          );
        }

        record.AccountId = component.get("v.recordId");
        record.Name = "New Opp";
        record.StageName = "Prospecting";
        record.CloseDate = dateStringYYYYMMDD;
        component.set("v.newOpportunity", record);

        opportunityRecordCreator.saveRecord(function (result) {
          if (result.state === "SUCCESS" || result.state === "DRAFT") {
            $A.get("e.force:refreshView").fire();
            helper.getRecords(component, event, helper);
          } else {
            component.set(
              "v.message",
              "Failed to create new Opportunity record"
            );
            component.set("v.loading", false);
          }
        });
      })
    );
  }
});
