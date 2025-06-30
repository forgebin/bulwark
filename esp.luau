-- UltraFastESP ModuleScript
-- Features:
-- - Dynamic Highlight management (max 30 at once)
-- - Team-based coloring
-- - Distance-based prioritization
-- - Highly customizable
-- - Memory efficient

local UltraFastESP = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Default configuration
local config = {
    MaxHighlights = 30,               -- Maximum number of concurrent highlights
    UpdateInterval = 0.1,               -- How often to update highlights (seconds)
    OutlineTransparency = 0.5,          -- Transparency of the outline
    FillTransparency = 0.8,             -- Transparency of the fill
    OutlineColor = Color3.new(1,1,1),   -- Default outline color (white)
    UseTeamColor = true,                -- Whether to use player team colors
    DefaultColor = Color3.new(1,0,0),   -- Default color if not using team colors
    Enabled = true,                     -- Whether ESP is initially enabled
    DistanceCheck = true,               -- Whether to prioritize closer players
    MaxDistance = 1000,                 -- Maximum distance to render ESP (studs)
    HighlightParent = nil,              -- Parent for Highlight instances (nil = character)
}

-- Internal variables
local highlights = {}
local playerCache = {}
local lastUpdate = 0
local heartbeatConnection = nil

-- Local references for optimization
local tableInsert = table.insert
local tableRemove = table.remove
local tableSort = table.sort
local mathHuge = math.huge
local workspaceGetChildren = workspace.GetChildren
local workspaceFindFirstChild = workspace.FindFirstChild
local pairs = pairs
local ipairs = ipairs
local next = next
local wait = task.wait

-- Local math functions for distance calculation
local sqrt = math.sqrt
local function magnitude(a, b)
    return sqrt(a*a + b*b)
end

-- Color cache to avoid creating new Color3 objects
local colorCache = {}
local function getTeamColor(team)
    if not team then return config.DefaultColor end
    local cacheKey = tostring(team.TeamColor)
    if not colorCache[cacheKey] then
        colorCache[cacheKey] = team.TeamColor.Color
    end
    return colorCache[cacheKey]
end

-- Distance calculation between two positions
local function getDistanceSquared(pos1, pos2)
    if not pos1 or not pos2 then return mathHuge end
    local delta = pos1 - pos2
    return magnitude(delta.X, delta.Y)
end

-- Cleanup function for highlights
local function cleanupHighlight(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

-- Highlight creation with pooling
local highlightPool = {}
local function createHighlight()
    if #highlightPool > 0 then
        return tableRemove(highlightPool)
    end
    local highlight = Instance.new("Highlight")
    highlight.OutlineTransparency = config.OutlineTransparency
    highlight.FillTransparency = config.FillTransparency
    highlight.OutlineColor = config.OutlineColor
    return highlight
end

-- Main update function
local function updateESP()
    if not config.Enabled then return end
    
    local localPlayer = Players.LocalPlayer
    if not localPlayer then return end
    
    local localCharacter = localPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    local localPosition = localRoot and localRoot.Position
    
    -- Collect valid players and calculate distances
    local validPlayers = {}
    local validCount = 0
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    validCount = validCount + 1
                    validPlayers[validCount] = {
                        player = player,
                        distance = config.DistanceCheck and getDistanceSquared(localPosition, rootPart.Position) or 0,
                        rootPart = rootPart
                    }
                end
            end
        end
    end
    
    -- Sort by distance if enabled
    if config.DistanceCheck then
        tableSort(validPlayers, function(a, b)
            return a.distance < b.distance
        end)
    end
    
    -- Process highlights
    local activeHighlights = 0
    local processedPlayers = {}
    
    for i = 1, math.min(validCount, config.MaxHighlights) do
        local data = validPlayers[i]
        local player = data.player
        
        -- Skip if beyond max distance
        if config.DistanceCheck and data.distance > (config.MaxDistance * config.MaxDistance) then
            continue
        end
        
        processedPlayers[player] = true
        
        -- Get or create highlight
        if not highlights[player] then
            highlights[player] = createHighlight()
            highlights[player].Adornee = player.Character
            highlights[player].Parent = config.HighlightParent or player.Character
            
            -- Set color
            if config.UseTeamColor then
                highlights[player].FillColor = getTeamColor(player.Team)
            else
                highlights[player].FillColor = config.DefaultColor
            end
        end
        
        activeHighlights = activeHighlights + 1
        
        -- Update highlight position if needed
        if highlights[player].Adornee ~= player.Character then
            highlights[player].Adornee = player.Character
            highlights[player].Parent = config.HighlightParent or player.Character
        end
    end
    
    -- Cleanup unused highlights
    for player, highlight in pairs(highlights) do
        if not processedPlayers[player] then
            highlight.Adornee = nil
            highlight.Parent = nil
            tableInsert(highlightPool, highlight)
            highlights[player] = nil
        end
    end
end

-- Heartbeat connection management
local function manageHeartbeat()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    
    if config.Enabled then
        heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
            lastUpdate = lastUpdate + deltaTime
            if lastUpdate >= config.UpdateInterval then
                lastUpdate = 0
                updateESP()
            end
        end)
    end
end

-- Configuration API
function UltraFastESP.configure(newConfig)
    for key, value in pairs(newConfig) do
        if config[key] ~= nil then
            config[key] = value
        end
    end
    
    -- Apply immediate changes if needed
    if newConfig.Enabled ~= nil then
        manageHeartbeat()
    end
    
    -- Update existing highlights if color settings changed
    if newConfig.UseTeamColor ~= nil or newConfig.DefaultColor ~= nil then
        for player, highlight in pairs(highlights) do
            if config.UseTeamColor then
                highlight.FillColor = getTeamColor(player.Team)
            else
                highlight.FillColor = config.DefaultColor
            end
        end
    end
    
    -- Update transparency settings if changed
    if newConfig.OutlineTransparency ~= nil then
        for _, highlight in pairs(highlights) do
            highlight.OutlineTransparency = config.OutlineTransparency
        end
        for _, highlight in ipairs(highlightPool) do
            highlight.OutlineTransparency = config.OutlineTransparency
        end
    end
    
    if newConfig.FillTransparency ~= nil then
        for _, highlight in pairs(highlights) do
            highlight.FillTransparency = config.FillTransparency
        end
        for _, highlight in ipairs(highlightPool) do
            highlight.FillTransparency = config.FillTransparency
        end
    end
end

-- Initialization
function UltraFastESP.init()
    -- Set up player connections
    Players.PlayerAdded:Connect(function(player)
        playerCache[player] = true
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        playerCache[player] = nil
        cleanupHighlight(player)
    end)
    
    -- Initialize existing players
    for _, player in ipairs(Players:GetPlayers()) do
        playerCache[player] = true
    end
    
    -- Start the ESP system
    manageHeartbeat()
end

-- Toggle function
function UltraFastESP.toggle(state)
    if state ~= nil then
        config.Enabled = state
    else
        config.Enabled = not config.Enabled
    end
    manageHeartbeat()
    return config.Enabled
end

-- Cleanup function
function UltraFastESP.cleanup()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
    end
    
    for player in pairs(highlights) do
        cleanupHighlight(player)
    end
    
    for _, highlight in ipairs(highlightPool) do
        highlight:Destroy()
    end
    
    table.clear(highlights)
    table.clear(highlightPool)
    table.clear(playerCache)
    table.clear(colorCache)
end

return UltraFastESP
