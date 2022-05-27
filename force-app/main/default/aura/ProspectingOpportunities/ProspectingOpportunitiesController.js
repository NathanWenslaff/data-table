({
  init: function (component, event, helper) {
    component.set("v.loading", true);

    helper
      .getRecords(component)
      .catch(
        $A.getCallback(function (error) {
          component.set("v.message", error.message);
        })
      )
      .finally(
        $A.getCallback(function () {
          component.set("v.loading", false);
        })
      );
  },

  createRecord: function (component, event, helper) {
    component.set("v.loading", true);

    helper
      .initializeRecord(component, event, helper)
      .then(
        $A.getCallback(function () {
          return helper.createRecord(component, event, helper);
        })
      )
      .then(
        $A.getCallback(function () {
          return helper.getRecords(component, event, helper);
        })
      )
      .catch(
        $A.getCallback(function (error) {
          component.set("v.message", error.message);
        })
      )
      .finally(
        $A.getCallback(function () {
          component.set("v.loading", false);
        })
      );
  }
});
