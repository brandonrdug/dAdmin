da.commands:Command 'mute'
:Callback(function(cmd, pl, args, suppress)
    local targ = args[1]
    local time = args[2] and args[2] * 60

    if targ:IsMuted() then
        da.sendmsg(pl, targ, ' is already muted!')
        return
    end

    targ:SetMuted(true)

    if (time) then
        timer.Create(pl:SteamID() .. 'dadmin.mute', time, 1, function()
            if not IsValid(targ) then return end
            targ:SetMuted(false)
            da.sendmsg(targ, 'You\'re no longer muted.')
        end)
    end

    if not (suppress) then
        if (time) then
            da.amsg('# muted # for #.')
                :Insert(pl)
                :Insert(targ)
                :Insert(string.NiceTime(time))
                :Send()
        else
            da.amsg('# muted #.')
                :Insert(pl)
                :Insert(targ)
                :Send()
        end
    end
end)

da.commands:Command 'unmute'
:Callback(function(cmd, pl, args, suppress)
    local targ = args[1]

    if not targ:IsMuted() then
        da.sendmsg(pl, targ, ' isn\'t muted!')
        return
    end

    targ:SetMuted(false)
    timer.Remove(pl:SteamID() .. 'dadmin.mute')

    if not (suppress) then
        da.amsg('# unmuted #.')
            :Insert(pl)
            :Insert(targ)
            :Send()
    end
end)