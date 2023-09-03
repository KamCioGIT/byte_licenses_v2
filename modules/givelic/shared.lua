GiveLic = {
    Command = 'givelic',
    CommandHelp = 'Gives a license to a player. Syntax: /givelic <John_Doe>',
    ParamHelp = 'The player to give the license to.',
    AllowSelfGive = true,
    AccountName = 'bank',
    Notify = {
        Title = 'Licensesystem',
        UnkownError = 'An unknown error occured.',
        NoPermission = 'You do not have permission to use this command.',
        TargetNotFound = 'Target not found.',
        NoSelfGive = 'You can not give yourself a license.',
        PlayerNotNearby = 'The player is not nearby.',
        Distance = {
            Nearby = 'You have to be nearby %s.',
            NearbyTrim = ' or '
        },
        Menu = {
            Give = 'Give license for %s$',
            Title = 'Issue licenses to %s'
        },
        Item = {
            Description = 'Holder: %s  \nType: %s',
            NoPlace = 'You dont have enough place.',
            NotEnoughMoney = 'You dont have enough money.'
        },
        Issued = {
            FactionNotify = 'Grade %s | %s gave %s the license %s.',
            GaveLicense = 'You gave %s the license %s.',
            GotLicense = '%s gave you the license %s.'
        }
    },
    Licenses = {
        {
            ItemName = 'mastercard',
            AllowedJobs = {{name = 'police', grade = 1}},
            Type = 'license-driving-a',
            Label = 'Drivinglicense A',
            Icon = 'car',
            Price = 15000
        },
        {
            ItemName = 'mastercard',
            AllowedJobs = {{name = 'ambulance', grade = 2}},
            Type = 'license-driving-b',
            Label = 'Drivinglicense B',
            Icon = 'car',
            Price = 15000
        },
    },
    Distance = {
        BetweenPlayers = 1.5,
        Other = {
            {
                label = 'DMV-HQ',
                position = vector3(-820.5547, -1332.5043, 5.1502),
                distance = 50.0 -- Distance
            },
        }
    }
}

return GiveLic