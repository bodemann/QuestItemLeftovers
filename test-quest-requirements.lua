-- Run with: lua test-quest-requirements.lua
local frame, tooltipCallback, objective, itemLink, owned, dbIcon, messages
local questCount = 1
function CreateFrame()
    frame = { RegisterEvent = function() end, SetScript = function(self, _, fn) self.onEvent = fn end }
    return frame
end
function wipe(t) for k in pairs(t) do t[k] = nil end end
function GetLocale() return "enUS" end
DEFAULT_CHAT_FRAME = { AddMessage = function(_, text) messages[#messages + 1] = text end }
SlashCmdList = {}
C_Timer = { After = function(_, fn) fn() end }
C_Item = { GetItemCount = function() return owned end, GetItemNameByID = function() return "Vessel of Tainted Blood" end }
C_Container = {
    GetContainerNumSlots = function(bag) return bag == 0 and 1 or 0 end,
    GetContainerItemInfo = function() return { itemID = 19071 } end,
    GetContainerItemQuestInfo = function() return { isQuestItem = true } end,
}
C_QuestLog = {
    GetNumQuestLogEntries = function() return questCount end,
    GetInfo = function(index) return { questID = index == 1 and 7850 or 7851, title = "Dark Vessels" } end,
    GetQuestObjectives = function(id) return id == 7850 and objective or {} end,
}
function GetQuestLogItemLink() return itemLink end
LibQuestieDB = {
    Quest = {
        GetAllIds = function() return { 7850, 7851 } end,
        objectives = function() return { [3] = { { 19071, nil, dbIcon } } } end,
    },
    Item = {},
}
Enum = { TooltipDataType = { Item = 1 } }
TooltipDataProcessor = { AddTooltipPostCall = function(_, fn) tooltipCallback = fn end }
local ns = {}
assert(loadfile("Localization.lua"))("QuestItemLeftovers", ns)
assert(loadfile("QuestItemLeftovers.lua"))("QuestItemLeftovers", ns)
messages = {}
frame.onEvent(frame, "PLAYER_LOGIN")

local function check(expected, forbidden)
    SlashCmdList.QUESTITEMLEFTOVERS("refresh")
    local lines = {}
    local tip = { AddLine = function(_, line) lines[#lines + 1] = line end }
    tooltipCallback(tip, { id = 19071 })
    local text = table.concat(lines, "\n")
    assert(text:find(expected, 1, true), text)
    if forbidden then assert(not text:find(forbidden, 1, true), text) end
    messages = {}
    SlashCmdList.QUESTITEMLEFTOVERS("scan")
    local scan = table.concat(messages, "\n")
    if forbidden then assert(not scan:find(forbidden, 1, true), scan) end
end

owned, dbIcon, itemLink = 5, 0, "item:19071"
objective = { { type = "item", text = "Vessel of Tainted Blood: 5/10", numRequired = 10 } }
check("5 / 10 required", "EXCESS")
objective = { { type = "item", text = "Vessel of Tainted Blood: 5/10" } }
check("5 / 10 required", "EXCESS")
itemLink = nil
objective = { { type = "item", text = "5/10 Vessel of Tainted Blood" } }
check("5 / 10 required", "EXCESS")
objective = {}
check("required quantity is unknown", "EXCESS")
dbIcon = 12345
check("required quantity is unknown", "EXCESS")
itemLink = "item:19071"
objective = { { type = "item", text = "Vessel of Tainted Blood", numRequired = 10 } }
owned = 12
check("Up to 2 can be discarded.")
questCount = 2
check("required quantity is unknown", "EXCESS")
print("quest requirement regression tests passed")
