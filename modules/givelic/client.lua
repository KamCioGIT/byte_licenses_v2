local GiveLic = require 'modules.givelic.shared'
RegisterNetEvent('licenses:openMenu')
AddEventHandler('licenses:openMenu', function(target, options)
    lib.registerContext({
        id = 'give_license',
        title = (GiveLic.Notify.Menu.Title):format(target),
        options = options
    })

    lib.showContext('give_license')
end)