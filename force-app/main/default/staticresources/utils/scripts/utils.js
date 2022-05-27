window.executeAction = (function (component, actionName, params) {
    return new Promise(function (resolve, reject) {
        var action = component.get(actionName);
        if (params) {
            action.setParams(params);
        }
        action.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === 'SUCCESS') {
                resolve(response.getReturnValue());
            } else {
                reject(response.getError()[0]);
            }
        });
        $A.enqueueAction(action);
    });
});