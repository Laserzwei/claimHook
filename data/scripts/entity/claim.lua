local localGameVersion = GameVersion()

-- Overwrite vanilla claim(), because it terminates itself.
function claim()
    local ok, msg = interactionPossible(callingPlayer)
    if not ok then

        if msg then
            local player = Player(callingPlayer)
            if player then
                player:sendChatMessage("", 1, msg)
            end
        end

        return
    end

    local faction, ship, player = getInteractingFaction(callingPlayer)
    if not faction then return end

    local entity = Entity()
    if entity.factionIndex ~= 0 then
        return false
    end
    -- hook for other scripts
    if beforeEndingTheScript(ok, msg, entity) == false then
        return false
    end
    entity.factionIndex = faction.index
    entity:addScriptOnce("minefounder.lua")
    entity:addScriptOnce("sellobject.lua")
    entity:setValue("valuable_object", nil)
    entity:setValue("map_marker", "Claimed Asteroid"%_T)

    if localGameVersion.major >= 2 then
        local sector = Sector()
        local x, y = sector:getCoordinates()
        player:sendCallback("onAsteroidClaimed", makeCallbackSenderInfo(entity))
    end


    terminate()
end

-- Allow other scripts to hook in.
-- Has all local variables as arguments ('callingPlayer' is an implicit "global").
-- Return false to prevent the Script from sending the Asteroid Claimed Notification and prevent it from self-termination
function beforeEndingTheScript(ok, msg, entity)
    -- Dummy function to be overwritten by other mods.
    return true
end
