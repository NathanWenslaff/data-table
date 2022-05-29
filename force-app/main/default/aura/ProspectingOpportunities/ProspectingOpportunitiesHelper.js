({
  getRecords: function (component) {
    return window
      .executeAction(component, "c.getProspectingOpportunities", {
        accountId: component.get("v.recordId")
      })
      .then(function (paginatedResults) {
        if (paginatedResults.error) {
          throw new Error(paginatedResults.error);
        } else if (paginatedResults.results.length === 0) {
          component.set("v.hasNoRecords", true);
          throw new Error("No Prospecting Opportunity records found");
        } else {
          component.set("v.records", paginatedResults.results);
          component.set("v.fields", paginatedResults.fields);
        }
      });
  },

  initializeRecord: function (component) {
    return new Promise(function (resolve, reject) {
      var opportunityRecordCreator = component.find("opportunityRecordCreator");
      opportunityRecordCreator.getNewRecord(
        "Opportunity",
        null,
        false,
        function () {
          var record = component.get("v.newOpportunity"),
            newOpportunityError = opportunityRecordCreator.get("v.targetError");

          if (newOpportunityError || !record) {
            reject(new Error("Failed to initialize a new Opportunity record"));
          } else {
            var dateStringFormat = "YYYY-MM-DD",
              dateStringYYYYMMDD = $A.localizationService.formatDate(
                new Date(),
                dateStringFormat
              );

            record.AccountId = component.get("v.recordId");
            record.Name = "New Opp";
            record.StageName = "Prospecting";
            record.CloseDate = dateStringYYYYMMDD;
            component.set("v.newOpportunity", record);
            resolve();
          }
        }
      );
    });
  },

  createRecord: function (component) {
    return new Promise(function (resolve, reject) {
      var opportunityRecordCreator = component.find("opportunityRecordCreator");
      opportunityRecordCreator.saveRecord(function (result) {
        if (result.state === "SUCCESS" || result.state === "DRAFT") {
          var hasNoRecords = component.get("v.hasNoRecords");

          if (hasNoRecords) {
            component.set("v.hasNoRecords", false);
            component.set("v.message", "");
          }

          component.set("v.hasNoRecords", false);
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            title: "Success!",
            type: "Success",
            message: "New Opportunity record created!"
          });
          toastEvent.fire();
          $A.get("e.force:refreshView").fire();
          resolve();
        } else {
          reject(new Error("Failed to create new Opportunity record"));
        }
      });
    });
  }
});
