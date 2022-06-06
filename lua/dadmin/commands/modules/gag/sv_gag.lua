da.commands:Command 'gag'
:Callback(function(cmd, pl, args, suppress)
    local targ = args[1]
    local time = args[2] and args[2] * 60

    if targ:IsGagged() then
        da.sendmsg(pl, targ, ' is already gagged!')
        return
    end

    targ:SetGagged(true)

    if (time) then
        timer.Create(pl:SteamID() .. 'dadmin.gag', time, 1, function()
            if not IsValid(targ) and targ:IsGagged() then return end
            targ:SetGagged(false)
            da.sendmsg(targ, 'You\'re no longer gagged.')
        end)
    end

    if not (suppress) then
        if (time) then
            da.amsg('# gagged # for #.')
                :Insert(pl)
                :Insert(targ)
                :Insert(string.NiceTime(time))
                :Send()
        else
            da.amsg('# gagged #.')
                :Insert(pl)
                :Insert(targ)
                :Send()
        end
    end
end)

da.commands:Command 'ungag'
:Callback(function(cmd, pl, args, suppress)
    local targ = args[1]

    if not targ:IsGagged() then
        da.sendmsg(pl, targ, ' isn\'t gagged!')
        return
    end

    targ:SetGagged(false)
    timer.Remove(pl:SteamID() .. 'dadmin.gag')

    if not (suppress) then
        da.amsg('# ungagged #.')
            :Insert(pl)
            :Insert(targ)
            :Send()
    end
end)