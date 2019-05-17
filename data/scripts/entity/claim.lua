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
    entity.factionIndex = faction.index
    entity:addScriptOnce("minefounder.lua")
    entity:addScriptOnce("sellobject.lua")
    -- hook for other scripts
    beforeEndingTheScript(ok, msg, entity)
    terminate()
end

-- Allow other scripts to hook in.
-- Has all local variables as arguments ('callingPlayer' is an implicit "global").
function beforeEndingTheScript(ok, msg, entity)
    -- Dummy function to be overwritten by other mods.
end
