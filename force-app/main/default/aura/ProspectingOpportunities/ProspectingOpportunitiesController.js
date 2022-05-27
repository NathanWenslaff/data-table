({
  init: function (component, event, helper) {
    component.set("v.loading", true);

    helper.getRecords(component);
  },

  createRecord: function (component, event, helper) {
    component.set("v.loading", true);

    helper.createRecord(component, event, helper);
  }
});
