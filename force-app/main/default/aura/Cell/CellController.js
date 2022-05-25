({
  init: function (component) {
    var record = component.get("v.record"),
      field = component.get("v.field");

    component.set("v.value", record[field.apiName]);
  }
});
