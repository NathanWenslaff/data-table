({
  init: function (component, event, helper) {
    component.set("v.loading", true);

    helper
      .getRecords(component)
      .catch(function (error) {
        component.set("v.message", error.message);
      })
      .finally(function () {
        component.set("v.loading", false);
      });
  },

  createRecord: function (component, event, helper) {
    component.set("v.loading", true);

    helper
      .initializeRecord(component, event, helper)
      .then(function () {
        return helper.createRecord(component, event, helper);
      })
      .then(function () {
        return helper.getRecords(component, event, helper);
      })
      .catch(function (error) {
        component.set("v.message", error.message);
      })
      .finally(function () {
        component.set("v.loading", false);
      });
  }
});
