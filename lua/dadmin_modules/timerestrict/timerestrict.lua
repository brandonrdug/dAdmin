hook("playerCanChangeTeam", "da.timerestrict", function(pPly, iTeam, bForce)
    local tJob = RPExtraTeams[iTeam]

    if (tJob.timeRequired) and not (bForce) then
        if (pPly:GetTime() < tJob.timeRequired) then
            return false, "You need " .. string.NiceTime(tJob.timeRequired) .. " to become this job."
        end
    end
end)