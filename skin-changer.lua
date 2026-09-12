-- New Game Client Skin Changer
-- SkinRegistry + WeaponClient hook. Yalnizca yerel gorunumu degistirir.

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function findModule(name, preferredRoot)
    if preferredRoot then
        local preferred = preferredRoot:FindFirstChild(name, true)
        if preferred and preferred:IsA("ModuleScript") then
            return preferred
        end
    end
    for _, inst in ipairs(game:GetDescendants()) do
        if inst:IsA("ModuleScript") and inst.Name == name then
            return inst
        end
    end
    return nil
end

local skinRegistryModule = findModule("SkinRegistry", ReplicatedStorage)
local weaponClientModule = findModule("WeaponClient", LocalPlayer:WaitForChild("PlayerScripts"))
local cosmeticApplierModule = findModule("CosmeticApplier", ReplicatedStorage)
local weaponModule = findModule("Weapon", LocalPlayer:WaitForChild("PlayerScripts"))
local weaponGlovesModule = findModule("WeaponGloves", LocalPlayer:WaitForChild("PlayerScripts"))
local weaponRegistryModule = findModule("WeaponRegistry", ReplicatedStorage)

assert(skinRegistryModule, "SkinRegistry ModuleScript bulunamadi")
assert(weaponClientModule, "WeaponClient ModuleScript bulunamadi")
assert(cosmeticApplierModule, "CosmeticApplier ModuleScript bulunamadi")
assert(weaponModule, "Weapon ModuleScript bulunamadi")
assert(weaponGlovesModule, "WeaponGloves ModuleScript bulunamadi")
assert(weaponRegistryModule, "WeaponRegistry ModuleScript bulunamadi")

local function tableHasFunctions(value, names)
    if type(value) ~= "table" then
        return false
    end
    for _, name in ipairs(names) do
        if type(rawget(value, name)) ~= "function" then
            return false
        end
    end
    return true
end

local function findLoadedTable(names)
    if type(getgc) ~= "function" then
        return nil
    end
    local ok, objects = pcall(getgc, true)
    if not ok or type(objects) ~= "table" then
        return nil
    end
    for _, object in ipairs(objects) do
        if tableHasFunctions(object, names) then
            return object
        end
    end
    return nil
end

local function loadModuleTable(module, identifyingMethods)
    local ok, value = pcall(require, module)
    if ok and tableHasFunctions(value, identifyingMethods) then
        return value
    end
    local loaded = findLoadedTable(identifyingMethods)
    assert(loaded, module.Name .. " runtime tablosu bulunamadi: " .. tostring(value))
    return loaded
end

local SkinRegistry = loadModuleTable(
    skinRegistryModule,
    { "get", "getSkinsForWeapon", "getWeaponsWithSkins" }
)
local WeaponClient = loadModuleTable(
    weaponClientModule,
    { "getWeaponCosmetic", "initializeRoundWeapons", "equipFromSlot" }
)
local CosmeticApplier = loadModuleTable(
    cosmeticApplierModule,
    { "applyWeaponCosmetic", "applySurfaceAppearances", "applyTextureOverlays" }
)
local WeaponClass = loadModuleTable(
    weaponModule,
    { "new", "applyCosmetic", "generateModel" }
)
local WeaponGloves = loadModuleTable(
    weaponGlovesModule,
    { "apply" }
)
local WeaponRegistry = loadModuleTable(
    weaponRegistryModule,
    { "getWeaponData", "getWeaponsForSlot", "getSlotTypes" }
)

assert(type(SkinRegistry) == "table", "SkinRegistry yuklenemedi")
assert(type(WeaponClient) == "table", "WeaponClient yuklenemedi")

_G.__NGForcedSkins = _G.__NGForcedSkins or {}
local forcedSkins = _G.__NGForcedSkins
local forcedGlove = _G.__NGForcedGlove

local function findAssetUtil()
    local candidates = {}
    local function addFunctionUpvalues(fn)
        if type(fn) ~= "function" then
            return
        end
        local getter = debug and debug.getupvalues or getupvalues
        if type(getter) ~= "function" then
            return
        end
        local ok, upvalues = pcall(getter, fn)
        if ok and type(upvalues) == "table" then
            for _, value in pairs(upvalues) do
                table.insert(candidates, value)
            end
        end
    end

    -- Once gercek canli weapon nesnesinin generateModel upvalue'ina bak.
    if type(getgc) == "function" then
        local ok, objects = pcall(getgc, true)
        if ok and type(objects) == "table" then
            for _, object in ipairs(objects) do
                if type(object) == "table" and rawget(object, "Name") and rawget(object, "ViewModel") then
                    local mt = getmetatable(object)
                    local class = mt and rawget(mt, "__index")
                    if type(class) == "table" and type(rawget(class, "generateModel")) == "function" then
                        addFunctionUpvalues(rawget(class, "generateModel"))
                        break
                    end
                end
            end
        end
    end

    addFunctionUpvalues(WeaponClass.generateModel)
    if type(getgc) == "function" then
        local ok, objects = pcall(getgc, true)
        if ok and type(objects) == "table" then
            for _, value in ipairs(objects) do
                if type(value) == "table" and type(rawget(value, "get")) == "function" then
                    table.insert(candidates, value)
                end
            end
        end
    end
    for _, candidate in ipairs(candidates) do
        if type(candidate) == "table" and type(rawget(candidate, "get")) == "function" then
            local ok, model = pcall(candidate.get, candidate, "ViewModels/Knife")
            if ok and typeof(model) == "Instance" and model:IsA("Model") then
                return candidate
            end
        end
    end
    return nil
end

local AssetUtil = findAssetUtil()
assert(AssetUtil, "Aktif AssetUtil tablosu bulunamadi")

if _G.__NGAssetUtilTable and type(_G.__NGAssetUtilRawGet) == "function" then
    pcall(function()
        _G.__NGAssetUtilTable.get = _G.__NGAssetUtilRawGet
    end)
end
local rawAssetGet = AssetUtil.get
_G.__NGAssetUtilTable = AssetUtil
_G.__NGAssetUtilRawGet = rawAssetGet

AssetUtil.get = function(self, path, ...)
    if path == "ViewModels/Knife" then
        local forced = forcedSkins.Knife
        if forced and forced.MeleeModel and forced.MeleeModel ~= "Knife" then
            local replacement = rawAssetGet(self, "ViewModels/" .. forced.MeleeModel, ...)
            if replacement then
                print("[NG SkinChanger] Knife model ->", forced.MeleeModel)
                return replacement
            end
        end
    end
    return rawAssetGet(self, path, ...)
end

-- Reinject durumunda onceki wrapper'i soy.
if type(_G.__NGGetWeaponCosmeticRaw) == "function" then
    WeaponClient.getWeaponCosmetic = _G.__NGGetWeaponCosmeticRaw
end

local rawGetWeaponCosmetic = WeaponClient.getWeaponCosmetic
_G.__NGGetWeaponCosmeticRaw = rawGetWeaponCosmetic

WeaponClient.getWeaponCosmetic = function(self, weaponName, settings)
    local forced = forcedSkins[weaponName]
    if forced then
        local skinData = SkinRegistry:get(forced.CosmeticId)
        if skinData then
            print("[NG SkinChanger] Hook:", weaponName, "->", forced.CosmeticId, forced.Variant or "Default")
            return skinData, forced.Variant
        end
    end
    return rawGetWeaponCosmetic(self, weaponName, settings)
end

local function getCosmeticApplyName(weapon, forced, skinData)
    if skinData and type(skinData.AppliesTo) == "string" and skinData.AppliesTo ~= "" then
        return skinData.AppliesTo
    end
    if forced and type(forced.MeleeModel) == "string" and forced.MeleeModel ~= "" then
        return forced.MeleeModel
    end
    local model = weapon and weapon.ViewModel and weapon.ViewModel.Model
    if typeof(model) == "Instance" and model.Name ~= "" and model.Name ~= "ViewModel" then
        return model.Name
    end
    return weapon and weapon.Name or nil
end

local function applyForcedToWeapon(weapon)
    if not weapon or not weapon.Name or not weapon.ViewModel or not weapon.ViewModel.Model then
        return false
    end
    local forced = forcedSkins[weapon.Name]
    local skinData = forced and SkinRegistry:get(forced.CosmeticId) or nil
    local variant = forced and forced.Variant or nil
    local applyName = getCosmeticApplyName(weapon, forced, skinData)

    weapon.Cosmetic = skinData
    weapon.SkinData = skinData
    weapon.Variant = variant
    -- Melee model (Bayonet/Karambit/...) skin assetleri AppliesTo adina bagli.
    -- weapon.Name "Knife" kalirsa blade SurfaceAppearance eski kalir, sadece sap boyanir.
    CosmeticApplier:applyWeaponCosmetic(applyName, weapon.ViewModel.Model, skinData, variant)
    print(
        "[NG SkinChanger] Direct overlay:",
        weapon.Name,
        "as",
        applyName,
        skinData and skinData.CosmeticId or "Default",
        variant or "Default"
    )
    return true
end

-- Oyun kendi cosmetic'ini tekrar bastiginda bizim secimi en son yeniden uygula.
if type(_G.__NGWeaponApplyCosmeticRaw) == "function" then
    WeaponClass.applyCosmetic = _G.__NGWeaponApplyCosmeticRaw
end
local rawWeaponApplyCosmetic = WeaponClass.applyCosmetic
_G.__NGWeaponApplyCosmeticRaw = rawWeaponApplyCosmetic

WeaponClass.applyCosmetic = function(self, ...)
    local results = table.pack(rawWeaponApplyCosmetic(self, ...))
    if forcedSkins[self.Name] then
        applyForcedToWeapon(self)
    end
    return table.unpack(results, 1, results.n)
end

local function getGuiParent()
    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and typeof(parent) == "Instance" then
            return parent
        end
    end
    local coreGui = game:GetService("CoreGui")
    if coreGui then
        return coreGui
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local oldGui = getGuiParent():FindFirstChild("NGSkinChanger")
if oldGui then
    oldGui:Destroy()
end

local function create(class, props)
    local object = Instance.new(class)
    for key, value in pairs(props) do
        object[key] = value
    end
    return object
end

local BG = Color3.fromRGB(6, 6, 7)
local PANEL = Color3.fromRGB(12, 12, 14)
local SURFACE = Color3.fromRGB(16, 16, 18)
local ROW = Color3.fromRGB(18, 18, 20)
local ROW_ACTIVE = Color3.fromRGB(28, 28, 32)
local ACCENT = Color3.fromRGB(235, 235, 240)
local BORDER = Color3.fromRGB(38, 38, 42)
local TEXT = Color3.fromRGB(232, 232, 236)
local MUTED = Color3.fromRGB(120, 120, 128)
local selectedCategory = "Rifles"
local selectedWeapon = nil
local rebuildWeapons
local rebuildSkins

local screen = create("ScreenGui", {
    Name = "NGSkinChanger",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = getGuiParent(),
})

local CURSOR_BIND_NAME = "NGSkinChangerCursor"
local savedMouseBehavior = UserInputService.MouseBehavior
local savedMouseIconEnabled = UserInputService.MouseIconEnabled

pcall(function()
    RunService:UnbindFromRenderStep(CURSOR_BIND_NAME)
end)

local function setMenuVisible(visible)
    screen.Enabled = visible
    pcall(function()
        RunService:UnbindFromRenderStep(CURSOR_BIND_NAME)
    end)

    if visible then
        savedMouseBehavior = UserInputService.MouseBehavior
        savedMouseIconEnabled = UserInputService.MouseIconEnabled
        RunService:BindToRenderStep(CURSOR_BIND_NAME, Enum.RenderPriority.Last.Value, function()
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        end)
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    else
        UserInputService.MouseBehavior = savedMouseBehavior
        UserInputService.MouseIconEnabled = savedMouseIconEnabled
    end
end

local main = create("Frame", {
    Name = "Main",
    Parent = screen,
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    Size = UDim2.fromOffset(640, 460),
    Position = UDim2.new(0.5, -320, 0.5, -230),
    Active = true,
})
create("UICorner", { Parent = main, CornerRadius = UDim.new(0, 12) })
create("UIStroke", {
    Parent = main,
    Color = BORDER,
    Thickness = 1,
    Transparency = 0.15,
})

local top = create("Frame", {
    Parent = main,
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 46),
})
create("UICorner", { Parent = top, CornerRadius = UDim.new(0, 12) })
create("Frame", {
    Parent = top,
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 1, -12),
    Size = UDim2.new(1, 0, 0, 12),
})
create("Frame", {
    Parent = top,
    BackgroundColor3 = BORDER,
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
})

create("TextLabel", {
    Parent = top,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(18, 0),
    Size = UDim2.new(1, -70, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "DIZYHUB",
    TextColor3 = TEXT,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local close = create("TextButton", {
    Parent = top,
    BackgroundColor3 = SURFACE,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -42, 0.5, -14),
    Size = UDim2.fromOffset(28, 28),
    Font = Enum.Font.GothamBold,
    Text = "×",
    TextColor3 = MUTED,
    TextSize = 18,
    AutoButtonColor = true,
})
create("UICorner", { Parent = close, CornerRadius = UDim.new(0, 7) })
create("UIStroke", {
    Parent = close,
    Color = BORDER,
    Thickness = 1,
    Transparency = 0.35,
})
close.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

local function styleSearchBox(box)
    create("UICorner", { Parent = box, CornerRadius = UDim.new(0, 8) })
    create("UIStroke", {
        Parent = box,
        Color = BORDER,
        Thickness = 1,
        Transparency = 0.4,
    })
    create("UIPadding", {
        Parent = box,
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    })
end

local weaponSearch = create("TextBox", {
    Parent = main,
    BackgroundColor3 = SURFACE,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(14, 58),
    Size = UDim2.fromOffset(295, 34),
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    PlaceholderText = "Search weapon...",
    PlaceholderColor3 = MUTED,
    Text = "",
    TextColor3 = TEXT,
    TextSize = 13,
})
styleSearchBox(weaponSearch)

local skinSearch = create("TextBox", {
    Parent = main,
    BackgroundColor3 = SURFACE,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(321, 58),
    Size = UDim2.fromOffset(305, 34),
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    PlaceholderText = "Search skin...",
    PlaceholderColor3 = MUTED,
    Text = "",
    TextColor3 = TEXT,
    TextSize = 13,
})
styleSearchBox(skinSearch)

local categoryBar = create("Frame", {
    Parent = main,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 100),
    Size = UDim2.fromOffset(612, 30),
})
create("UIListLayout", {
    Parent = categoryBar,
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
})

local categoryButtons = {}
local function refreshCategoryButtons()
    for name, button in pairs(categoryButtons) do
        local active = name == selectedCategory
        local stroke = button:FindFirstChildOfClass("UIStroke")
        button.BackgroundColor3 = active and ROW_ACTIVE or SURFACE
        button.TextColor3 = active and ACCENT or MUTED
        if stroke then
            stroke.Color = active and Color3.fromRGB(70, 70, 78) or BORDER
            stroke.Transparency = active and 0.1 or 0.4
        end
    end
end

for order, name in ipairs({ "Rifles", "Pistols", "Knives", "Gloves" }) do
    local button = create("TextButton", {
        Parent = categoryBar,
        BackgroundColor3 = SURFACE,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(147, 30),
        LayoutOrder = order,
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = MUTED,
        TextSize = 12,
        AutoButtonColor = false,
    })
    create("UICorner", { Parent = button, CornerRadius = UDim.new(0, 8) })
    create("UIStroke", {
        Parent = button,
        Color = BORDER,
        Thickness = 1,
        Transparency = 0.4,
    })
    categoryButtons[name] = button
    button.MouseButton1Click:Connect(function()
        selectedCategory = name
        selectedWeapon = nil
        weaponSearch.Text = ""
        skinSearch.Text = ""
        refreshCategoryButtons()
        if rebuildWeapons then
            rebuildWeapons()
        end
        if rebuildSkins then
            rebuildSkins()
        end
    end)
end
refreshCategoryButtons()

local function styleList(list)
    create("UICorner", { Parent = list, CornerRadius = UDim.new(0, 10) })
    create("UIStroke", {
        Parent = list,
        Color = BORDER,
        Thickness = 1,
        Transparency = 0.45,
    })
    create("UIListLayout", {
        Parent = list,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    create("UIPadding", {
        Parent = list,
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
    })
end

local weaponsList = create("ScrollingFrame", {
    Parent = main,
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(14, 140),
    Size = UDim2.fromOffset(295, 270),
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = Color3.fromRGB(80, 80, 88),
})
styleList(weaponsList)

local skinsList = create("ScrollingFrame", {
    Parent = main,
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(321, 140),
    Size = UDim2.fromOffset(305, 270),
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = Color3.fromRGB(80, 80, 88),
})
styleList(skinsList)

local status = create("TextLabel", {
    Parent = main,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(18, 420),
    Size = UDim2.new(1, -36, 0, 28),
    Font = Enum.Font.Gotham,
    Text = "Select a weapon and skin  •  RightShift to toggle",
    TextColor3 = MUTED,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local function clearRows(frame)
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function row(parent, text, callback, active)
    local button = create("TextButton", {
        Parent = parent,
        BackgroundColor3 = active and ROW_ACTIVE or ROW,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 32),
        Font = Enum.Font.Gotham,
        Text = "  " .. text,
        TextColor3 = active and ACCENT or TEXT,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
    })
    create("UICorner", { Parent = button, CornerRadius = UDim.new(0, 7) })
    create("UIStroke", {
        Parent = button,
        Color = active and Color3.fromRGB(70, 70, 78) or Color3.fromRGB(28, 28, 32),
        Thickness = 1,
        Transparency = active and 0.15 or 0.55,
    })
    button.MouseEnter:Connect(function()
        if not active then
            button.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        end
    end)
    button.MouseLeave:Connect(function()
        if not active then
            button.BackgroundColor3 = ROW
        end
    end)
    button.MouseButton1Click:Connect(callback)
    return button
end

local weapons = {}
local seenWeapons = {}
local weaponCategories = {}
for _, skinData in pairs(SkinRegistry) do
    if type(skinData) == "table"
        and type(skinData.AppliesTo) == "string"
        and not seenWeapons[skinData.AppliesTo] then
        seenWeapons[skinData.AppliesTo] = true
        table.insert(weapons, skinData.AppliesTo)
    end
    if type(skinData) == "table" and type(skinData.AppliesTo) == "string" then
        local category = skinData.Category
        if category == "Melee" then
            weaponCategories[skinData.AppliesTo] = "Knives"
        elseif category == "Gloves" then
            weaponCategories[skinData.AppliesTo] = "Gloves"
        elseif category == "Skin" and not weaponCategories[skinData.AppliesTo] then
            local weaponData = WeaponRegistry:getWeaponData(skinData.AppliesTo)
            weaponCategories[skinData.AppliesTo] =
                weaponData and weaponData.SlotType == "Secondary" and "Pistols" or "Rifles"
        end
    end
end
table.sort(weapons)

local function getLiveWeaponKey(weaponName, skinData)
    if skinData and skinData.Category == "Melee" then
        return "Knife"
    end
    if weaponName then
        for _, candidate in ipairs(SkinRegistry:getSkinsForWeapon(weaponName)) do
            if candidate.Category == "Melee" then
                return "Knife"
            end
        end
    end
    return weaponName
end

local function getSelectedForced()
    local liveKey = getLiveWeaponKey(selectedWeapon)
    return liveKey and forcedSkins[liveKey] or nil
end

local function findLiveWeaponObjects(weaponName)
    local found = {}
    local seen = {}

    local function add(weapon)
        if type(weapon) ~= "table"
            or seen[weapon]
            or (weaponName and rawget(weapon, "Name") ~= weaponName) then
            return
        end
        local viewModel = rawget(weapon, "ViewModel")
        local model = type(viewModel) == "table" and rawget(viewModel, "Model") or nil
        if typeof(model) == "Instance" and model.Parent then
            seen[weapon] = true
            table.insert(found, weapon)
        end
    end

    if type(WeaponClient.Inventory) == "table" then
        for _, weapon in pairs(WeaponClient.Inventory) do
            add(weapon)
        end
    end
    add(WeaponClient.CurrentWeapon)

    if type(getgc) == "function" then
        local ok, objects = pcall(getgc, true)
        if ok and type(objects) == "table" then
            for _, object in ipairs(objects) do
                add(object)
            end
        end
    end

    return found
end

local function refreshGloveVisual()
    local matched = 0
    local applied = false
    local gloveData = forcedGlove and {
        CosmeticId = forcedGlove.CosmeticId,
        Variant = forcedGlove.Variant,
    } or nil

    for _, weapon in ipairs(findLiveWeaponObjects(nil)) do
        matched += 1
        local ok, err = pcall(function()
            WeaponGloves:apply(
                forcedGlove and forcedGlove.GloveType or nil,
                weapon.ViewModel,
                gloveData
            )
        end)
        if ok then
            applied = true
        else
            warn("[NG SkinChanger] Gloves apply error:", err)
        end
    end

    print("[NG SkinChanger] Gloves refresh: matched=", matched, "applied=", applied)
    return applied, matched
end

local function findActiveWeaponClient()
    local best = WeaponClient
    local bestScore = -1

    local function inspect(candidate)
        if type(candidate) ~= "table"
            or type(rawget(candidate, "initializeRoundWeapons")) ~= "function"
            or type(rawget(candidate, "equipFromSlot")) ~= "function"
            or type(rawget(candidate, "Inventory")) ~= "table" then
            return
        end
        local score = rawget(candidate, "CurrentWeapon") and 100 or 0
        for _, weapon in pairs(rawget(candidate, "Inventory")) do
            if type(weapon) == "table" and rawget(weapon, "ViewModel") then
                score += 10
            end
        end
        if score > bestScore then
            best = candidate
            bestScore = score
        end
    end

    inspect(WeaponClient)
    if type(getgc) == "function" then
        local ok, objects = pcall(getgc, true)
        if ok and type(objects) == "table" then
            for _, object in ipairs(objects) do
                inspect(object)
            end
        end
    end
    return best
end

local function refreshWeaponVisual(weaponName)
    local changed = false
    local matched = 0
    local forced = forcedSkins[weaponName]
    local meleeModel = forced and forced.MeleeModel

    if weaponName == "Knife" and meleeModel and meleeModel ~= "Knife" then
        local needsModelSwap = true
        for _, weapon in ipairs(findLiveWeaponObjects("Knife")) do
            local model = weapon.ViewModel and weapon.ViewModel.Model
            if model and model.Name == meleeModel then
                needsModelSwap = false
                break
            end
        end
        if needsModelSwap then
            local activeClient = findActiveWeaponClient()
            local previousSlot = activeClient.CurrentSlot
            local ok, err = pcall(function()
                activeClient:initializeRoundWeapons(true)
            end)
            if not ok then
                warn("[NG SkinChanger] Melee model rebuild error:", err)
            elseif previousSlot and type(activeClient.equipFromSlot) == "function" then
                task.defer(function()
                    pcall(function()
                        activeClient:equipFromSlot(previousSlot)
                    end)
                end)
            end
            task.delay(0.2, function()
                refreshWeaponVisual("Knife")
            end)
            changed = ok
        end
    end

    for _, weapon in ipairs(findLiveWeaponObjects(weaponName)) do
        matched += 1
        local ok, applied = pcall(applyForcedToWeapon, weapon)
        if ok and applied then
            changed = true
        elseif not ok then
            warn("[NG SkinChanger] Direct overlay error:", applied)
        end
    end

    print("[NG SkinChanger] Refresh:", weaponName, "matched=", matched, "applied=", changed)
    return changed, matched
end

local function applyChoice(skinData, variant)
    if not selectedWeapon then
        return
    end

    if selectedCategory == "Gloves" then
        if skinData then
            forcedGlove = {
                CosmeticId = skinData.CosmeticId,
                Variant = variant,
                GloveType = skinData.AppliesTo,
            }
            _G.__NGForcedGlove = forcedGlove
            local label = skinData.DisplayName or skinData.CosmeticId
            if variant then
                label ..= " [" .. tostring(variant) .. "]"
            end
            status.Text = selectedWeapon .. " → " .. label
        else
            forcedGlove = nil
            _G.__NGForcedGlove = nil
            status.Text = selectedWeapon .. " → Default gloves"
        end
        local changed, matched = refreshGloveVisual()
        if matched == 0 then
            status.Text ..= " • equip a weapon"
        elseif changed then
            status.Text ..= " • applied"
        end
        rebuildSkins()
        return
    end

    local liveWeaponKey = getLiveWeaponKey(selectedWeapon, skinData)
    if not skinData then
        forcedSkins[liveWeaponKey] = nil
        status.Text = selectedWeapon .. " → Default"
    else
        forcedSkins[liveWeaponKey] = {
            CosmeticId = skinData.CosmeticId,
            Variant = variant,
            MeleeModel = skinData.Category == "Melee" and skinData.AppliesTo or nil,
        }
        local label = skinData.DisplayName or skinData.CosmeticId
        if variant then
            label ..= " [" .. tostring(variant) .. "]"
        end
        status.Text = selectedWeapon .. " → " .. label
    end

    local changed, matched = refreshWeaponVisual(liveWeaponKey)
    if matched == 0 then
        status.Text ..= " • equip " .. tostring(liveWeaponKey)
    elseif changed then
        status.Text ..= " • applied"
    end
    rebuildSkins()
end

rebuildSkins = function()
    clearRows(skinsList)
    if not selectedWeapon then
        return
    end

    local query = string.lower(skinSearch.Text)
    local forced = selectedCategory == "Gloves" and forcedGlove or getSelectedForced()
    row(skinsList, "Default / Remove override", function()
        applyChoice(nil, nil)
    end, forced == nil)

    local skins = SkinRegistry:getSkinsForWeapon(selectedWeapon)
    for _, skinData in ipairs(skins) do
        local baseLabel = skinData.DisplayName or skinData.CosmeticId or "Unknown"
        local rarity = skinData.Rarity and (" • " .. tostring(skinData.Rarity)) or ""

        if type(skinData.Variants) == "table" and next(skinData.Variants) then
            local variants = {}
            for variantName in pairs(skinData.Variants) do
                table.insert(variants, variantName)
            end
            table.sort(variants)
            for _, variantName in ipairs(variants) do
                local label = baseLabel .. " [" .. variantName .. "]" .. rarity
                if query == "" or string.find(string.lower(label), query, 1, true) then
                    local isActive = forced
                        and forced.CosmeticId == skinData.CosmeticId
                        and forced.Variant == variantName
                    row(skinsList, label, function()
                        applyChoice(skinData, variantName)
                    end, isActive)
                end
            end
        else
            local label = baseLabel .. rarity
            if query == "" or string.find(string.lower(label), query, 1, true) then
                local isActive = forced
                    and forced.CosmeticId == skinData.CosmeticId
                    and forced.Variant == nil
                row(skinsList, label, function()
                    applyChoice(skinData, nil)
                end, isActive)
            end
        end
    end
end

rebuildWeapons = function()
    clearRows(weaponsList)
    local query = string.lower(weaponSearch.Text)
    local visibleWeapons = {}
    for _, weaponName in ipairs(weapons) do
        if weaponCategories[weaponName] == selectedCategory
            and (query == "" or string.find(string.lower(weaponName), query, 1, true)) then
            table.insert(visibleWeapons, weaponName)
        end
    end
    if not selectedWeapon or weaponCategories[selectedWeapon] ~= selectedCategory then
        selectedWeapon = visibleWeapons[1]
    end
    for _, weaponName in ipairs(visibleWeapons) do
            row(weaponsList, weaponName, function()
                selectedWeapon = weaponName
                skinSearch.Text = ""
                rebuildWeapons()
                rebuildSkins()
            end, selectedWeapon == weaponName)
    end
end

weaponSearch:GetPropertyChangedSignal("Text"):Connect(rebuildWeapons)
skinSearch:GetPropertyChangedSignal("Text"):Connect(rebuildSkins)

local function reapplyAllForced(reason)
    for weaponName in pairs(forcedSkins) do
        local changed, matched = refreshWeaponVisual(weaponName)
        if matched > 0 then
            print("[NG SkinChanger] Auto reapply:", reason, weaponName, changed)
        end
    end
    if forcedGlove then
        local changed, matched = refreshGloveVisual()
        if matched > 0 then
            print("[NG SkinChanger] Auto reapply gloves:", reason, changed)
        end
    end
end

local respawnGeneration = 0
local function scheduleRespawnReapply(reason)
    respawnGeneration += 1
    local generation = respawnGeneration
    task.spawn(function()
        -- Oyun yeni silah/viewmodel'leri farkli zamanlarda kurabildigi icin kisa sure retry.
        for attempt = 1, 20 do
            if generation ~= respawnGeneration then
                return
            end
            task.wait(attempt == 1 and 0.25 or 0.5)
            reapplyAllForced(reason .. "#" .. attempt)
        end
    end)
end

if _G.__NGCharacterAddedConn then
    pcall(function()
        _G.__NGCharacterAddedConn:Disconnect()
    end)
end
_G.__NGCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function()
    scheduleRespawnReapply("CharacterAdded")
end)

if _G.__NGViewModelAddedConn then
    pcall(function()
        _G.__NGViewModelAddedConn:Disconnect()
    end)
    _G.__NGViewModelAddedConn = nil
end

task.spawn(function()
    local gameLogic = workspace:WaitForChild("GameLogic", 15)
    local viewModels = gameLogic and gameLogic:WaitForChild("ViewModels", 15)
    if viewModels then
        _G.__NGViewModelAddedConn = viewModels.ChildAdded:Connect(function()
            task.delay(0.15, function()
                reapplyAllForced("ViewModelAdded")
            end)
        end)
    end
end)

local dragging = false
local dragStart = Vector2.zero
local startPosition = main.Position

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        setMenuVisible(not screen.Enabled)
    end
end)

rebuildWeapons()
rebuildSkins()
setMenuVisible(true)

_G.NGSkinChanger = {
    forced = forcedSkins,
    apply = function(weaponName, cosmeticId, variant)
        selectedWeapon = weaponName
        applyChoice(SkinRegistry:get(cosmeticId), variant)
    end,
    clear = function(weaponName)
        selectedWeapon = weaponName
        applyChoice(nil, nil)
    end,
    refresh = refreshWeaponVisual,
}

print("[NG SkinChanger] Hazir. RightShift ile menu ac/kapat.")
