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
      } else {
        component.set("v.error", response.getError()[0]);
      }

      component.set("v.loading", false);
    });
    $A.enqueueAction(action);
  }
});
