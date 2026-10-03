local QIG = CreateFrame("Frame")
local DB
local requirements = {}
local activeQuests = {}
local itemQuestIndex = {}
local bagQuestItems = {}
local bagQuestItemNames = {}
local bagQuestStarts = {}
local updateQueued = false

-- QuestieDB numeric fields default to 0 when no value is stored.
-- Lua treats 0 as truthy, so every entity/quest/item ID coming from
-- QuestieDB must be normalized before it is used as an ID.
local function validID(value)
    if type(value) == "number" and value > 0 then
        return value
    end
    return nil
end

local function msg(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99QuestItemLeftovers:|r " .. tostring(text))
end

local function safeCall(func, ...)
    if type(func) ~= "function" then
        return nil
    end
    local ok, a, b, c, d = pcall(func, ...)
    if not ok then
        return nil
    end
    return a, b, c, d
end

local function getItemCount(itemID)
    if C_Item and C_Item.GetItemCount then
        local count = safeCall(C_Item.GetItemCount, itemID, false, false, false)
        if type(count) == "number" then
            return count
        end
    end
    if GetItemCount then
        local count = safeCall(GetItemCount, itemID, false)
        if type(count) == "number" then
            return count
        end
    end
    return 0
end


local function getItemName(itemID)
    if C_Item and C_Item.GetItemNameByID then
        local name = safeCall(C_Item.GetItemNameByID, itemID)
        if type(name) == "string" and name ~= "" then return name end
    end
    if GetItemInfo then
        local name = safeCall(GetItemInfo, itemID)
        if type(name) == "string" and name ~= "" then return name end
    end
    return nil
end

local function normalizeMatchText(text)
    if type(text) ~= "string" then return "" end
    text = string.lower(text)
    -- Normalize common typographic apostrophes used by localized/UI text.
    text = string.gsub(text, "’", "'")
    text = string.gsub(text, "‘", "'")
    return text
end

local function normalizedCount(count)
    if type(count) ~= "number" or count < 1 then return 1 end
    return count
end

local function objectiveNameCandidate(text)
    local s = normalizeMatchText(text)
    if s == "" then return "" end

    -- If the objective text is a hyperlink, use its bracketed display name.
    local bracketed = string.match(s, "%[([^%]]+)%]")
    if bracketed then
        s = normalizeMatchText(bracketed)
    end

    -- Strip a trailing progress suffix such as "3/10", "0/10", or "10/10",
    -- optionally preceded by a colon or whitespace.
    s = string.gsub(s, "%s*%d+%s*/%s*%d+%s*$", "")
    s = string.gsub(s, "%s*[:：]%s*$", "")

    -- Strip common collection verbs from the beginning.
    s = string.gsub(s, "^collect%s+", "")
    s = string.gsub(s, "^gather%s+", "")
    s = string.gsub(s, "^obtain%s+", "")
    s = string.gsub(s, "^bring%s+", "")
    s = string.gsub(s, "^recover%s+", "")
    s = string.gsub(s, "^deliver%s+", "")
    s = string.gsub(s, "^salvage%s+", "")

    return string.gsub(string.gsub(s, "^%s+", ""), "%s+$", "")
end

local function isQuestCompleted(questID)
    questID = validID(questID)
    if not questID then return false end
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return safeCall(C_QuestLog.IsQuestFlaggedCompleted, questID) == true
    end
    return false
end

local function questName(questID, fallback)
    if fallback and fallback ~= "" then
        return fallback
    end
    questID = validID(questID)
    if not questID then
        return "Unknown quest"
    end
    if DB and DB.Quest and DB.Quest.name then
        local name = DB.Quest.name(questID)
        if name and name ~= "" then return name end
    end
    return "Quest " .. questID
end


local function addIndexedQuestUse(itemID, questID, kind, count)
    itemID = validID(itemID)
    questID = validID(questID)
    if not itemID or not questID then return end

    local bucket = itemQuestIndex[itemID]
    if not bucket then
        bucket = {}
        itemQuestIndex[itemID] = bucket
    end

    -- De-duplicate the same quest/kind pair.
    for _, use in ipairs(bucket) do
        if use.questID == questID and use.kind == kind then
            if type(count) == "number" and count > 0 then
                use.count = count
            end
            return
        end
    end

    bucket[#bucket + 1] = {
        questID = questID,
        kind = kind,
        count = count,
    }
end

local function buildItemQuestIndex()
    wipe(itemQuestIndex)

    if not DB or not DB.Quest or type(DB.Quest.GetAllIds) ~= "function" then
        return
    end

    local questIDs = DB.Quest.GetAllIds()
    if type(questIDs) ~= "table" then return end

    for _, questID in ipairs(questIDs) do
        questID = validID(questID)
        if questID then
            local objectives = DB.Quest.objectives and DB.Quest.objectives(questID)
            local itemObjectives = objectives and objectives[3]
            for _, objective in ipairs(itemObjectives or {}) do
                addIndexedQuestUse(objective[1], questID, "objective", objective[3])
            end

            local requiredSourceItems = DB.Quest.requiredSourceItems and DB.Quest.requiredSourceItems(questID)
            for _, itemID in ipairs(requiredSourceItems or {}) do
                addIndexedQuestUse(itemID, questID, "requiredSource", 1)
            end

            local sourceItemID = DB.Quest.sourceItemId and validID(DB.Quest.sourceItemId(questID))
            if sourceItemID then
                addIndexedQuestUse(sourceItemID, questID, "source", 1)
            end
        end
    end

end

local function collectRelatedQuestIDs(itemID)
    local ids, seen = {}, {}
    local function add(qid)
        qid = validID(qid)
        if qid and not seen[qid] then
            seen[qid] = true
            ids[#ids + 1] = qid
        end
    end

    local indexed = itemQuestIndex[itemID]
    for _, use in ipairs(indexed or {}) do add(use.questID) end

    for qid in pairs(bagQuestStarts[itemID] or {}) do add(qid) end

    if DB and DB.Item then
        local related = DB.Item.relatedQuests and DB.Item.relatedQuests(itemID)
        for _, qid in ipairs(related or {}) do add(qid) end
        local startQuest = DB.Item.startQuest and DB.Item.startQuest(itemID)
        add(startQuest)
    end

    table.sort(ids)
    return ids
end

local function objectiveKind(kind)
    return kind == "objective"
end

local function parseItemIDFromLink(link)
    if type(link) ~= "string" then return nil end
    return validID(tonumber(string.match(link, "item:(%d+)")))
end

local function rebuildBagQuestItemCache()
    wipe(bagQuestItems)
    wipe(bagQuestItemNames)
    wipe(bagQuestStarts)
    if not C_Container or not C_Container.GetContainerNumSlots then return end

    local bagMax = _G.NUM_BAG_SLOTS or 4
    for bag = 0, bagMax do
        local slots = C_Container.GetContainerNumSlots(bag) or 0
        for slot = 1, slots do
            local info = C_Container.GetContainerItemInfo and C_Container.GetContainerItemInfo(bag, slot)
            local itemID = info and validID(info.itemID)
            if itemID and C_Container.GetContainerItemQuestInfo then
                local qinfo = C_Container.GetContainerItemQuestInfo(bag, slot)
                if qinfo and qinfo.isQuestItem then
                    bagQuestItems[itemID] = true
                    bagQuestItemNames[itemID] = getItemName(itemID)
                end
                local starts = qinfo and validID(qinfo.questID)
                if starts then
                    local startsBucket = bagQuestStarts[itemID]
                    if not startsBucket then
                        startsBucket = {}
                        bagQuestStarts[itemID] = startsBucket
                    end
                    startsBucket[starts] = true
                end
            end
        end
    end
end

local function addRequirement(itemID, count, questID, title, kind)
    itemID = validID(itemID)
    questID = validID(questID)
    if not itemID or not questID then return end

    local entry = requirements[itemID]
    if not entry then
        entry = { required = 0, quests = {} }
        requirements[itemID] = entry
    end

    if objectiveKind(kind) then
        entry.required = entry.required + normalizedCount(count)
    end

    entry.quests[#entry.quests + 1] = {
        id = questID,
        name = title,
        count = normalizedCount(count),
        kind = kind,
    }
end

local function rebuildQuestCache()
    wipe(requirements)
    wipe(activeQuests)

    if not DB or not DB.Quest or not C_QuestLog then
        return
    end

    -- Collect the actual quest items currently in the bags before scanning the
    -- quest log. This lets us match new Forever quests that are not in QuestieDB
    -- and whose required-item hyperlink is temporarily unavailable.
    rebuildBagQuestItemCache()

    local numEntries = safeCall(C_QuestLog.GetNumQuestLogEntries) or 0
    for index = 1, numEntries do
        local info = safeCall(C_QuestLog.GetInfo, index)
        if info and not info.isHeader and info.questID then
            local questID = validID(info.questID)
            if questID then
                activeQuests[questID] = true
                local title = questName(questID, info.title)

                -- Aggregate QuestieDB item objectives per item so that two separate
                -- objectives for the same item in one quest are summed correctly.
                local dbCounts = {}
                local objectives = DB.Quest.objectives and DB.Quest.objectives(questID)
                local itemObjectives = objectives and objectives[3]
                if itemObjectives then
                    for _, objective in ipairs(itemObjectives) do
                        local oItemID = validID(objective[1])
                        if oItemID then
                            dbCounts[oItemID] = (dbCounts[oItemID] or 0) + normalizedCount(objective[3])
                        end
                    end
                end

                -- Forever has quests that are not present in QuestieDB yet. For quests
                -- currently in the player's log, ask Blizzard for each required item link.
                -- The required-item index counts only item objectives, not all objectives.
                local liveCounts = {}
                if C_QuestLog.GetQuestObjectives and GetQuestLogItemLink then
                    local liveObjectives = safeCall(C_QuestLog.GetQuestObjectives, questID)
                    local requiredIndex = 0
                    for _, objective in ipairs(liveObjectives or {}) do
                        if objective.type == "item" then
                            requiredIndex = requiredIndex + 1
                            local numRequired = normalizedCount(objective.numRequired)
                            local link = safeCall(GetQuestLogItemLink, "required", requiredIndex, questID)
                            local liveItemID = parseItemIDFromLink(link)
                            if liveItemID then
                                liveCounts[liveItemID] = (liveCounts[liveItemID] or 0) + numRequired
                            else
                                -- Forever can expose the live objective while
                                -- GetQuestLogItemLink still returns nil (for example
                                -- uncached/new quest items). Fall back to matching the
                                -- objective text against quest-item names actually in
                                -- the player's bags. This is intentionally only used
                                -- for active item objectives.
                                local candidate = objectiveNameCandidate(objective.text)
                                if candidate ~= "" then
                                    for bagItemID in pairs(bagQuestItems) do
                                        local bagName = bagQuestItemNames[bagItemID]
                                        if normalizeMatchText(bagName) == candidate then
                                            liveCounts[bagItemID] = (liveCounts[bagItemID] or 0) + numRequired
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                -- Merge the two sources. Blizzard's live data is authoritative for an
                -- active quest, so let it override QuestieDB; fall back to QuestieDB
                -- only when the live link was unavailable.
                local merged = {}
                for itemID, count in pairs(dbCounts) do merged[itemID] = count end
                for itemID, count in pairs(liveCounts) do
                    merged[itemID] = count
                end

                for itemID, count in pairs(merged) do
                    addRequirement(itemID, count, questID, title, "objective")
                end

                -- sourceItemId is an item supplied for an active quest. It is not always a
                -- collect objective, so keep it as a conservative support-item warning.
                local sourceItemID = DB.Quest.sourceItemId and validID(DB.Quest.sourceItemId(questID))
                if sourceItemID then
                    addRequirement(sourceItemID, 1, questID, title, "source")
                end

                local requiredSourceItems = DB.Quest.requiredSourceItems and DB.Quest.requiredSourceItems(questID)
                for _, itemID in ipairs(requiredSourceItems or {}) do
                    addRequirement(itemID, 1, questID, title, "requiredSource")
                end
            end
        end
    end
end

local function scheduleRebuild()
    if updateQueued then return end
    updateQueued = true
    C_Timer.After(0.15, function()
        updateQueued = false
        rebuildQuestCache()
    end)
end

local function questIDsToEntries(ids)
    local entries = {}
    local seenNames = {}
    for _, questID in ipairs(ids or {}) do
        questID = validID(questID)
        if questID then
            local name = questName(questID)
            local key = string.lower(name or ("quest " .. questID))
            if not seenNames[key] then
                seenNames[key] = true
                entries[#entries + 1] = {
                    id = questID,
                    name = name,
                }
            end
        end
    end
    return entries
end

local function itemQuestContext(itemID)
    local requirement = requirements[itemID]
    if requirement then
        local count = getItemCount(itemID)
        if requirement.required > 0 then
            local excess = count - requirement.required
            if excess > 0 then
                return {
                    code = "EXCESS",
                    count = count,
                    required = requirement.required,
                    excess = excess,
                    quests = requirement.quests,
                }
            end
            return {
                code = "KEEP",
                count = count,
                required = requirement.required,
                missing = math.max(0, requirement.required - count),
                quests = requirement.quests,
            }
        end

        return {
            code = "ACTIVE_SUPPORT",
            count = count,
            quests = requirement.quests,
        }
    end

    if not DB or not DB.Item then return nil end

    local startQuest = DB.Item.startQuest and validID(DB.Item.startQuest(itemID))
    if startQuest and not isQuestCompleted(startQuest) and not activeQuests[startQuest] then
        return {
            code = "STARTS_QUEST",
            questID = startQuest,
            questName = questName(startQuest),
        }
    end

    -- QuestieDB's item-side relatedQuests field is not exhaustive.  Merge it with
    -- a reverse index built from every quest's item objectives/source requirements.
    local related = collectRelatedQuestIDs(itemID)
    if related and #related > 0 then
        local unfinished = {}
        local completed = {}
        for _, questID in ipairs(related) do
            if activeQuests[questID] then
                -- An active quest relationship that was not captured as a concrete
                -- requirement is still worth keeping conservatively.
                unfinished[#unfinished + 1] = questID
            elseif isQuestCompleted(questID) then
                completed[#completed + 1] = questID
            else
                unfinished[#unfinished + 1] = questID
            end
        end

        if #unfinished > 0 then
            return {
                code = "POSSIBLE_FUTURE",
                quests = questIDsToEntries(unfinished),
                completed = questIDsToEntries(completed),
            }
        end

        return {
            code = "LIKELY_SAFE",
            related = questIDsToEntries(completed),
        }
    end

    if bagQuestItems[itemID] then
        return { code = "UNKNOWN_QUEST_ITEM" }
    end

    return nil
end

local function addQuestLines(tooltip, quests, objectiveOnly)
    if not quests then return end
    local shown = 0
    local seenNames = {}
    for _, q in ipairs(quests) do
        if not objectiveOnly or objectiveKind(q.kind) then
            local name = q.name or questName(q.id)
            local key = string.lower(name or "")
            if not seenNames[key] then
                seenNames[key] = true
                local suffix = ""
                if objectiveKind(q.kind) and q.count then
                    suffix = " (needs " .. q.count .. ")"
                end
                tooltip:AddLine("  Quest: " .. name .. suffix, 0.75, 0.75, 0.75)
                shown = shown + 1
                if shown >= 5 then break end
            end
        end
    end
end

local function addTooltipStatus(tooltip, itemID)
    if not itemID then return end
    local status = itemQuestContext(itemID)
    if not status then return end

    tooltip:AddLine(" ")

    if status.code == "KEEP" then
        tooltip:AddLine("QuestItemLeftovers: KEEP", 0.25, 1.0, 0.25)
        tooltip:AddLine(("Across bags: %d / %d required"):format(status.count, status.required), 1, 1, 1)
        if status.missing and status.missing > 0 then
            tooltip:AddLine(("Still need %d more."):format(status.missing), 1.0, 0.82, 0.2)
        else
            tooltip:AddLine("Exact amount needed; do not discard any.", 1.0, 0.82, 0.2)
        end
        addQuestLines(tooltip, status.quests, true)

    elseif status.code == "EXCESS" then
        tooltip:AddLine("QuestItemLeftovers: EXCESS AVAILABLE", 0.25, 1.0, 0.25)
        tooltip:AddLine(("Across bags: %d owned, %d required"):format(status.count, status.required), 1, 1, 1)
        tooltip:AddLine(("Up to %d can be discarded."):format(status.excess), 0.25, 1.0, 0.25)
        addQuestLines(tooltip, status.quests, true)

    elseif status.code == "ACTIVE_SUPPORT" then
        tooltip:AddLine("QuestItemLeftovers: KEEP FOR NOW", 1.0, 0.82, 0.2)
        tooltip:AddLine("QuestieDB marks this as a source item for an active quest.", 0.8, 0.8, 0.8, true)
        addQuestLines(tooltip, status.quests, false)

    elseif status.code == "STARTS_QUEST" then
        tooltip:AddLine("QuestItemLeftovers: KEEP", 0.25, 1.0, 0.25)
        tooltip:AddLine("Starts an unfinished quest:", 1.0, 0.82, 0.2)
        tooltip:AddLine("  " .. status.questName, 0.75, 0.75, 0.75)

    elseif status.code == "POSSIBLE_FUTURE" then
        tooltip:AddLine("QuestItemLeftovers: POSSIBLE QUEST USE", 1.0, 0.82, 0.2)
        tooltip:AddLine("Not needed by an active quest, but QuestieDB links it", 0.8, 0.8, 0.8)
        tooltip:AddLine("to unfinished quest(s). Don't auto-delete it.", 0.8, 0.8, 0.8)
        addQuestLines(tooltip, status.quests, false)

    elseif status.code == "UNKNOWN_QUEST_ITEM" then
        tooltip:AddLine("QuestItemLeftovers: QUEST USE UNKNOWN", 1.0, 0.82, 0.2)
        tooltip:AddLine("WoW marks this as a quest item, but its quest is not", 0.8, 0.8, 0.8)
        tooltip:AddLine("in the available quest database or your active quest log.", 0.8, 0.8, 0.8)
        tooltip:AddLine("Keep it unless you know the quest is finished.", 1.0, 0.82, 0.2)

    elseif status.code == "LIKELY_SAFE" then
        tooltip:AddLine("QuestItemLeftovers: LIKELY SAFE TO DELETE", 0.4, 0.85, 1.0)
        tooltip:AddLine("No unfinished quest needs this item.", 0.8, 0.8, 0.8)
        if status.related and #status.related > 0 then
            tooltip:AddLine("Related |cff00ff00completed|r quest(s):", 0.8, 0.8, 0.8)
            addQuestLines(tooltip, status.related, false)
        end
    end
end

local function hookTooltips()
    if TooltipDataProcessor and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Item then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
            local itemID = data and data.id
            if not itemID and data and data.hyperlink then
                itemID = tonumber(string.match(data.hyperlink, "item:(%d+)"))
            end
            addTooltipStatus(tooltip, itemID)
        end)
        return
    end

    -- Fallback for clients retaining the classic tooltip callback.
    if GameTooltip and GameTooltip.HookScript then
        GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
            local _, link = tooltip:GetItem()
            local itemID = link and tonumber(string.match(link, "item:(%d+)"))
            addTooltipStatus(tooltip, itemID)
        end)
    end
end

local function initialize()
    DB = _G.LibQuestieDB
    if not DB then
        msg("QuestieDB is not loaded. Enable QuestieDB and reload the UI.")
        return false
    end

    if DB.RequireContract then
        -- Contract 1 is the public named-getter API used by this addon.
        local ok, err = DB.RequireContract(1)
        if not ok then
            msg(err or "QuestieDB API is incompatible.")
            return false
        end
    end

    buildItemQuestIndex()
    rebuildQuestCache()
    hookTooltips()
    msg("loaded. Hover quest-related items, or use /qil scan.")
    return true
end

local function scanBags()
    if not DB or not DB.Item then
        msg("QuestieDB is not loaded. Enable QuestieDB and reload the UI.")
        return
    end

    local seen = {}
    local bagMax = _G.NUM_BAG_SLOTS or 4
    local found = 0

    for bag = 0, bagMax do
        local slots = C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerNumSlots(bag) or 0
        for slot = 1, slots do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            local itemID = info and validID(info.itemID)
            if itemID and not seen[itemID] then
                seen[itemID] = true
                local status = itemQuestContext(itemID)
                if status then
                    found = found + 1
                    local name = (DB.Item.name and DB.Item.name(itemID)) or (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(itemID)) or ("item:" .. itemID)
                    if status.code == "KEEP" then
                        msg(("KEEP %s — %d/%d, need %d more — %s"):format(name, status.count, status.required, status.missing or 0, status.quests[1] and status.quests[1].name or "active quest"))
                    elseif status.code == "EXCESS" then
                        msg(("EXCESS %s — %d owned, %d required; %d discardable — %s"):format(name, status.count, status.required, status.excess, status.quests[1] and status.quests[1].name or "active quest"))
                    elseif status.code == "STARTS_QUEST" then
                        msg(("KEEP %s — starts %s"):format(name, status.questName))
                    elseif status.code == "POSSIBLE_FUTURE" then
                        msg(("CHECK %s — linked to unfinished quest: %s"):format(name, status.quests[1] and status.quests[1].name or "unknown quest"))
                    elseif status.code == "ACTIVE_SUPPORT" then
                        msg(("KEEP %s — active quest source item — %s"):format(name, status.quests[1] and status.quests[1].name or "active quest"))
                    elseif status.code == "LIKELY_SAFE" then
                        msg(("LIKELY SAFE TO DELETE %s — no unfinished quest needs this item"):format(name))
                    elseif status.code == "UNKNOWN_QUEST_ITEM" then
                        msg(("UNKNOWN %s — WoW marks it as a quest item, but no quest mapping is available"):format(name))
                    end
                end
            end
        end
    end

    if found == 0 then
        msg("No quest-related bag items found by QuestieDB.")
    end
end

SLASH_QUESTITEMLEFTOVERS1 = "/qil"
SLASH_QUESTITEMLEFTOVERS2 = "/questitemleftovers"
SlashCmdList.QUESTITEMLEFTOVERS = function(input)
    input = string.lower((input or ""):match("^%s*(.-)%s*$"))
    if input == "scan" or input == "bags" then
        rebuildQuestCache()
        scanBags()
    elseif input == "refresh" then
        buildItemQuestIndex()
        rebuildQuestCache()
        msg("quest database index and active quest cache refreshed.")
    else
        msg("commands: /qil scan, /qil refresh")
    end
end

QIG:RegisterEvent("PLAYER_LOGIN")
QIG:RegisterEvent("QUEST_ACCEPTED")
QIG:RegisterEvent("QUEST_REMOVED")
QIG:RegisterEvent("QUEST_TURNED_IN")
QIG:RegisterEvent("QUEST_LOG_UPDATE")
QIG:RegisterEvent("BAG_UPDATE_DELAYED")

QIG:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        initialize()
    elseif DB then
        scheduleRebuild()
    end
end)
