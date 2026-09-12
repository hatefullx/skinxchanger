-- DIZYHUB protected build
(function()
repeat task.wait() until game:IsLoaded()

local Players = game:GetService(string.char(80,108,97,121,101,114,115))
local UserInputService = game:GetService(string.char(85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101))
local ReplicatedStorage = game:GetService(string.char(82,101,112,108,105,99,97,116,101,100,83,116,111,114,97,103,101))
local RunService = game:GetService(string.char(82,117,110,83,101,114,118,105,99,101))
local LocalPlayer = Players.LocalPlayer

local function findModule(name, preferredRoot)
if preferredRoot then
local preferred = preferredRoot:FindFirstChild(name, true)
if preferred and preferred:IsA(string.char(77,111,100,117,108,101,83,99,114,105,112,116)) then
return preferred
end
end
for _, inst in ipairs(game:GetDescendants()) do
if inst:IsA(string.char(77,111,100,117,108,101,83,99,114,105,112,116)) and inst.Name == name then
return inst
end
end
return nil
end

local skinRegistryModule = findModule(string.char(83,107,105,110,82,101,103,105,115,116,114,121), ReplicatedStorage)
local weaponClientModule = findModule(string.char(87,101,97,112,111,110,67,108,105,101,110,116), LocalPlayer:WaitForChild(string.char(80,108,97,121,101,114,83,99,114,105,112,116,115)))
local cosmeticApplierModule = findModule(string.char(67,111,115,109,101,116,105,99,65,112,112,108,105,101,114), ReplicatedStorage)
local weaponModule = findModule(string.char(87,101,97,112,111,110), LocalPlayer:WaitForChild(string.char(80,108,97,121,101,114,83,99,114,105,112,116,115)))
local weaponGlovesModule = findModule(string.char(87,101,97,112,111,110,71,108,111,118,101,115), LocalPlayer:WaitForChild(string.char(80,108,97,121,101,114,83,99,114,105,112,116,115)))
local weaponRegistryModule = findModule(string.char(87,101,97,112,111,110,82,101,103,105,115,116,114,121), ReplicatedStorage)

assert(skinRegistryModule, string.char(83,107,105,110,82,101,103,105,115,116,114,121,32,77,111,100,117,108,101,83,99,114,105,112,116,32,98,117,108,117,110,97,109,97,100,105))
assert(weaponClientModule, string.char(87,101,97,112,111,110,67,108,105,101,110,116,32,77,111,100,117,108,101,83,99,114,105,112,116,32,98,117,108,117,110,97,109,97,100,105))
assert(cosmeticApplierModule, string.char(67,111,115,109,101,116,105,99,65,112,112,108,105,101,114,32,77,111,100,117,108,101,83,99,114,105,112,116,32,98,117,108,117,110,97,109,97,100,105))
assert(weaponModule, string.char(87,101,97,112,111,110,32,77,111,100,117,108,101,83,99,114,105,112,116,32,98,117,108,117,110,97,109,97,100,105))
assert(weaponGlovesModule, string.char(87,101,97,112,111,110,71,108,111,118,101,115,32,77,111,100,117,108,101,83,99,114,105,112,116,32,98,117,108,117,110,97,109,97,100,105))
assert(weaponRegistryModule, string.char(87,101,97,112,111,110,82,101,103,105,115,116,114,121,32,77,111,100,117,108,101,83,99,114,105,112,116,32,98,117,108,117,110,97,109,97,100,105))

local function tableHasFunctions(value, names)
if type(value) ~= string.char(116,97,98,108,101) then
return false
end
for _, name in ipairs(names) do
if type(rawget(value, name)) ~= string.char(102,117,110,99,116,105,111,110) then
return false
end
end
return true
end

local function findLoadedTable(names)
if type(getgc) ~= string.char(102,117,110,99,116,105,111,110) then
return nil
end
local ok, objects = pcall(getgc, true)
if not ok or type(objects) ~= string.char(116,97,98,108,101) then
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
assert(loaded, module.Name .. string.char(32,114,117,110,116,105,109,101,32,116,97,98,108,111,115,117,32,98,117,108,117,110,97,109,97,100,105,58,32) .. tostring(value))
return loaded
end

local SkinRegistry = loadModuleTable(
skinRegistryModule,
{ string.char(103,101,116), string.char(103,101,116,83,107,105,110,115,70,111,114,87,101,97,112,111,110), string.char(103,101,116,87,101,97,112,111,110,115,87,105,116,104,83,107,105,110,115) }
)
local WeaponClient = loadModuleTable(
weaponClientModule,
{ string.char(103,101,116,87,101,97,112,111,110,67,111,115,109,101,116,105,99), string.char(105,110,105,116,105,97,108,105,122,101,82,111,117,110,100,87,101,97,112,111,110,115), string.char(101,113,117,105,112,70,114,111,109,83,108,111,116) }
)
local CosmeticApplier = loadModuleTable(
cosmeticApplierModule,
{ string.char(97,112,112,108,121,87,101,97,112,111,110,67,111,115,109,101,116,105,99), string.char(97,112,112,108,121,83,117,114,102,97,99,101,65,112,112,101,97,114,97,110,99,101,115), string.char(97,112,112,108,121,84,101,120,116,117,114,101,79,118,101,114,108,97,121,115) }
)
local WeaponClass = loadModuleTable(
weaponModule,
{ string.char(110,101,119), string.char(97,112,112,108,121,67,111,115,109,101,116,105,99), string.char(103,101,110,101,114,97,116,101,77,111,100,101,108) }
)
local WeaponGloves = loadModuleTable(
weaponGlovesModule,
{ string.char(97,112,112,108,121) }
)
local WeaponRegistry = loadModuleTable(
weaponRegistryModule,
{ string.char(103,101,116,87,101,97,112,111,110,68,97,116,97), string.char(103,101,116,87,101,97,112,111,110,115,70,111,114,83,108,111,116), string.char(103,101,116,83,108,111,116,84,121,112,101,115) }
)

assert(type(SkinRegistry) == string.char(116,97,98,108,101), string.char(83,107,105,110,82,101,103,105,115,116,114,121,32,121,117,107,108,101,110,101,109,101,100,105))
assert(type(WeaponClient) == string.char(116,97,98,108,101), string.char(87,101,97,112,111,110,67,108,105,101,110,116,32,121,117,107,108,101,110,101,109,101,100,105))

_G.__NGForcedSkins = _G.__NGForcedSkins or {}
local forcedSkins = _G.__NGForcedSkins
local forcedGlove = _G.__NGForcedGlove

local function findAssetUtil()
local candidates = {}
local function addFunctionUpvalues(fn)
if type(fn) ~= string.char(102,117,110,99,116,105,111,110) then
return
end
local getter = debug and debug.getupvalues or getupvalues
if type(getter) ~= string.char(102,117,110,99,116,105,111,110) then
return
end
local ok, upvalues = pcall(getter, fn)
if ok and type(upvalues) == string.char(116,97,98,108,101) then
for _, value in pairs(upvalues) do
table.insert(candidates, value)
end
end
end


if type(getgc) == string.char(102,117,110,99,116,105,111,110) then
local ok, objects = pcall(getgc, true)
if ok and type(objects) == string.char(116,97,98,108,101) then
for _, object in ipairs(objects) do
if type(object) == string.char(116,97,98,108,101) and rawget(object, string.char(78,97,109,101)) and rawget(object, string.char(86,105,101,119,77,111,100,101,108)) then
local mt = getmetatable(object)
local class = mt and rawget(mt, string.char(95,95,105,110,100,101,120))
if type(class) == string.char(116,97,98,108,101) and type(rawget(class, string.char(103,101,110,101,114,97,116,101,77,111,100,101,108))) == string.char(102,117,110,99,116,105,111,110) then
addFunctionUpvalues(rawget(class, string.char(103,101,110,101,114,97,116,101,77,111,100,101,108)))
break
end
end
end
end
end

addFunctionUpvalues(WeaponClass.generateModel)
if type(getgc) == string.char(102,117,110,99,116,105,111,110) then
local ok, objects = pcall(getgc, true)
if ok and type(objects) == string.char(116,97,98,108,101) then
for _, value in ipairs(objects) do
if type(value) == string.char(116,97,98,108,101) and type(rawget(value, string.char(103,101,116))) == string.char(102,117,110,99,116,105,111,110) then
table.insert(candidates, value)
end
end
end
end
for _, candidate in ipairs(candidates) do
if type(candidate) == string.char(116,97,98,108,101) and type(rawget(candidate, string.char(103,101,116))) == string.char(102,117,110,99,116,105,111,110) then
local ok, model = pcall(candidate.get, candidate, string.char(86,105,101,119,77,111,100,101,108,115,47,75,110,105,102,101))
if ok and typeof(model) == string.char(73,110,115,116,97,110,99,101) and model:IsA(string.char(77,111,100,101,108)) then
return candidate
end
end
end
return nil
end

local AssetUtil = findAssetUtil()
assert(AssetUtil, string.char(65,107,116,105,102,32,65,115,115,101,116,85,116,105,108,32,116,97,98,108,111,115,117,32,98,117,108,117,110,97,109,97,100,105))

if _G.__NGAssetUtilTable and type(_G.__NGAssetUtilRawGet) == string.char(102,117,110,99,116,105,111,110) then
pcall(function()
_G.__NGAssetUtilTable.get = _G.__NGAssetUtilRawGet
end)
end
local rawAssetGet = AssetUtil.get
_G.__NGAssetUtilTable = AssetUtil
_G.__NGAssetUtilRawGet = rawAssetGet

AssetUtil.get = function(self, path, ...)
if path == string.char(86,105,101,119,77,111,100,101,108,115,47,75,110,105,102,101) then
local forced = forcedSkins.Knife
if forced and forced.MeleeModel and forced.MeleeModel ~= string.char(75,110,105,102,101) then
local replacement = rawAssetGet(self, string.char(86,105,101,119,77,111,100,101,108,115,47) .. forced.MeleeModel, ...)
if replacement then
print(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,75,110,105,102,101,32,109,111,100,101,108,32,45,62), forced.MeleeModel)
return replacement
end
end
end
return rawAssetGet(self, path, ...)
end


if type(_G.__NGGetWeaponCosmeticRaw) == string.char(102,117,110,99,116,105,111,110) then
WeaponClient.getWeaponCosmetic = _G.__NGGetWeaponCosmeticRaw
end

local rawGetWeaponCosmetic = WeaponClient.getWeaponCosmetic
_G.__NGGetWeaponCosmeticRaw = rawGetWeaponCosmetic

WeaponClient.getWeaponCosmetic = function(self, weaponName, settings)
local forced = forcedSkins[weaponName]
if forced then
local skinData = SkinRegistry:get(forced.CosmeticId)
if skinData then
print(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,72,111,111,107,58), weaponName, string.char(45,62), forced.CosmeticId, forced.Variant or string.char(68,101,102,97,117,108,116))
return skinData, forced.Variant
end
end
return rawGetWeaponCosmetic(self, weaponName, settings)
end

local function getCosmeticApplyName(weapon, forced, skinData)
if skinData and type(skinData.AppliesTo) == string.char(115,116,114,105,110,103) and skinData.AppliesTo ~= "" then
return skinData.AppliesTo
end
if forced and type(forced.MeleeModel) == string.char(115,116,114,105,110,103) and forced.MeleeModel ~= "" then
return forced.MeleeModel
end
local model = weapon and weapon.ViewModel and weapon.ViewModel.Model
if typeof(model) == string.char(73,110,115,116,97,110,99,101) and model.Name ~= "" and model.Name ~= string.char(86,105,101,119,77,111,100,101,108) then
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


CosmeticApplier:applyWeaponCosmetic(applyName, weapon.ViewModel.Model, skinData, variant)
print(
string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,68,105,114,101,99,116,32,111,118,101,114,108,97,121,58),
weapon.Name,
string.char(97,115),
applyName,
skinData and skinData.CosmeticId or string.char(68,101,102,97,117,108,116),
variant or string.char(68,101,102,97,117,108,116)
)
return true
end


if type(_G.__NGWeaponApplyCosmeticRaw) == string.char(102,117,110,99,116,105,111,110) then
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
if type(gethui) == string.char(102,117,110,99,116,105,111,110) then
local ok, parent = pcall(gethui)
if ok and typeof(parent) == string.char(73,110,115,116,97,110,99,101) then
return parent
end
end
local coreGui = game:GetService(string.char(67,111,114,101,71,117,105))
if coreGui then
return coreGui
end
return LocalPlayer:WaitForChild(string.char(80,108,97,121,101,114,71,117,105))
end

local oldGui = getGuiParent():FindFirstChild(string.char(78,71,83,107,105,110,67,104,97,110,103,101,114))
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
local selectedCategory = string.char(82,105,102,108,101,115)
local selectedWeapon = nil
local rebuildWeapons
local rebuildSkins

local screen = create(string.char(83,99,114,101,101,110,71,117,105), {
Name = string.char(78,71,83,107,105,110,67,104,97,110,103,101,114),
ResetOnSpawn = false,
IgnoreGuiInset = true,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
Parent = getGuiParent(),
})

local CURSOR_BIND_NAME = string.char(78,71,83,107,105,110,67,104,97,110,103,101,114,67,117,114,115,111,114)
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

local main = create(string.char(70,114,97,109,101), {
Name = string.char(77,97,105,110),
Parent = screen,
BackgroundColor3 = BG,
BorderSizePixel = 0,
Size = UDim2.fromOffset(640, 460),
Position = UDim2.new(0.5, -320, 0.5, -230),
Active = true,
})
create(string.char(85,73,67,111,114,110,101,114), { Parent = main, CornerRadius = UDim.new(0, 12) })
create(string.char(85,73,83,116,114,111,107,101), {
Parent = main,
Color = BORDER,
Thickness = 1,
Transparency = 0.15,
})

local top = create(string.char(70,114,97,109,101), {
Parent = main,
BackgroundColor3 = PANEL,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 46),
})
create(string.char(85,73,67,111,114,110,101,114), { Parent = top, CornerRadius = UDim.new(0, 12) })
create(string.char(70,114,97,109,101), {
Parent = top,
BackgroundColor3 = PANEL,
BorderSizePixel = 0,
Position = UDim2.new(0, 0, 1, -12),
Size = UDim2.new(1, 0, 0, 12),
})
create(string.char(70,114,97,109,101), {
Parent = top,
BackgroundColor3 = BORDER,
BackgroundTransparency = 0.55,
BorderSizePixel = 0,
Position = UDim2.new(0, 0, 1, -1),
Size = UDim2.new(1, 0, 0, 1),
})

create(string.char(84,101,120,116,76,97,98,101,108), {
Parent = top,
BackgroundTransparency = 1,
Position = UDim2.fromOffset(18, 0),
Size = UDim2.new(1, -70, 1, 0),
Font = Enum.Font.GothamBold,
Text = string.char(68,73,90,89,72,85,66),
TextColor3 = TEXT,
TextSize = 15,
TextXAlignment = Enum.TextXAlignment.Left,
})

local close = create(string.char(84,101,120,116,66,117,116,116,111,110), {
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
create(string.char(85,73,67,111,114,110,101,114), { Parent = close, CornerRadius = UDim.new(0, 7) })
create(string.char(85,73,83,116,114,111,107,101), {
Parent = close,
Color = BORDER,
Thickness = 1,
Transparency = 0.35,
})
close.MouseButton1Click:Connect(function()
setMenuVisible(false)
end)

local function styleSearchBox(box)
create(string.char(85,73,67,111,114,110,101,114), { Parent = box, CornerRadius = UDim.new(0, 8) })
create(string.char(85,73,83,116,114,111,107,101), {
Parent = box,
Color = BORDER,
Thickness = 1,
Transparency = 0.4,
})
create(string.char(85,73,80,97,100,100,105,110,103), {
Parent = box,
PaddingLeft = UDim.new(0, 12),
PaddingRight = UDim.new(0, 12),
})
end

local weaponSearch = create(string.char(84,101,120,116,66,111,120), {
Parent = main,
BackgroundColor3 = SURFACE,
BorderSizePixel = 0,
Position = UDim2.fromOffset(14, 58),
Size = UDim2.fromOffset(295, 34),
ClearTextOnFocus = false,
Font = Enum.Font.Gotham,
PlaceholderText = string.char(83,101,97,114,99,104,32,119,101,97,112,111,110,46,46,46),
PlaceholderColor3 = MUTED,
Text = "",
TextColor3 = TEXT,
TextSize = 13,
})
styleSearchBox(weaponSearch)

local skinSearch = create(string.char(84,101,120,116,66,111,120), {
Parent = main,
BackgroundColor3 = SURFACE,
BorderSizePixel = 0,
Position = UDim2.fromOffset(321, 58),
Size = UDim2.fromOffset(305, 34),
ClearTextOnFocus = false,
Font = Enum.Font.Gotham,
PlaceholderText = string.char(83,101,97,114,99,104,32,115,107,105,110,46,46,46),
PlaceholderColor3 = MUTED,
Text = "",
TextColor3 = TEXT,
TextSize = 13,
})
styleSearchBox(skinSearch)

local categoryBar = create(string.char(70,114,97,109,101), {
Parent = main,
BackgroundTransparency = 1,
Position = UDim2.fromOffset(14, 100),
Size = UDim2.fromOffset(612, 30),
})
create(string.char(85,73,76,105,115,116,76,97,121,111,117,116), {
Parent = categoryBar,
FillDirection = Enum.FillDirection.Horizontal,
Padding = UDim.new(0, 8),
SortOrder = Enum.SortOrder.LayoutOrder,
})

local categoryButtons = {}
local function refreshCategoryButtons()
for name, button in pairs(categoryButtons) do
local active = name == selectedCategory
local stroke = button:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
button.BackgroundColor3 = active and ROW_ACTIVE or SURFACE
button.TextColor3 = active and ACCENT or MUTED
if stroke then
stroke.Color = active and Color3.fromRGB(70, 70, 78) or BORDER
stroke.Transparency = active and 0.1 or 0.4
end
end
end

for order, name in ipairs({ string.char(82,105,102,108,101,115), string.char(80,105,115,116,111,108,115), string.char(75,110,105,118,101,115), string.char(71,108,111,118,101,115) }) do
local button = create(string.char(84,101,120,116,66,117,116,116,111,110), {
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
create(string.char(85,73,67,111,114,110,101,114), { Parent = button, CornerRadius = UDim.new(0, 8) })
create(string.char(85,73,83,116,114,111,107,101), {
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
create(string.char(85,73,67,111,114,110,101,114), { Parent = list, CornerRadius = UDim.new(0, 10) })
create(string.char(85,73,83,116,114,111,107,101), {
Parent = list,
Color = BORDER,
Thickness = 1,
Transparency = 0.45,
})
create(string.char(85,73,76,105,115,116,76,97,121,111,117,116), {
Parent = list,
Padding = UDim.new(0, 4),
SortOrder = Enum.SortOrder.LayoutOrder,
})
create(string.char(85,73,80,97,100,100,105,110,103), {
Parent = list,
PaddingTop = UDim.new(0, 8),
PaddingLeft = UDim.new(0, 8),
PaddingRight = UDim.new(0, 8),
PaddingBottom = UDim.new(0, 8),
})
end

local weaponsList = create(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101), {
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

local skinsList = create(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101), {
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

local status = create(string.char(84,101,120,116,76,97,98,101,108), {
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
if child:IsA(string.char(84,101,120,116,66,117,116,116,111,110)) then
child:Destroy()
end
end
end

local function row(parent, text, callback, active)
local button = create(string.char(84,101,120,116,66,117,116,116,111,110), {
Parent = parent,
BackgroundColor3 = active and ROW_ACTIVE or ROW,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 32),
Font = Enum.Font.Gotham,
Text = string.char(32,32) .. text,
TextColor3 = active and ACCENT or TEXT,
TextSize = 12,
TextXAlignment = Enum.TextXAlignment.Left,
AutoButtonColor = false,
})
create(string.char(85,73,67,111,114,110,101,114), { Parent = button, CornerRadius = UDim.new(0, 7) })
create(string.char(85,73,83,116,114,111,107,101), {
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
if type(skinData) == string.char(116,97,98,108,101)
and type(skinData.AppliesTo) == string.char(115,116,114,105,110,103)
and not seenWeapons[skinData.AppliesTo] then
seenWeapons[skinData.AppliesTo] = true
table.insert(weapons, skinData.AppliesTo)
end
if type(skinData) == string.char(116,97,98,108,101) and type(skinData.AppliesTo) == string.char(115,116,114,105,110,103) then
local category = skinData.Category
if category == string.char(77,101,108,101,101) then
weaponCategories[skinData.AppliesTo] = string.char(75,110,105,118,101,115)
elseif category == string.char(71,108,111,118,101,115) then
weaponCategories[skinData.AppliesTo] = string.char(71,108,111,118,101,115)
elseif category == string.char(83,107,105,110) and not weaponCategories[skinData.AppliesTo] then
local weaponData = WeaponRegistry:getWeaponData(skinData.AppliesTo)
weaponCategories[skinData.AppliesTo] =
weaponData and weaponData.SlotType == string.char(83,101,99,111,110,100,97,114,121) and string.char(80,105,115,116,111,108,115) or string.char(82,105,102,108,101,115)
end
end
end
table.sort(weapons)

local function getLiveWeaponKey(weaponName, skinData)
if skinData and skinData.Category == string.char(77,101,108,101,101) then
return string.char(75,110,105,102,101)
end
if weaponName then
for _, candidate in ipairs(SkinRegistry:getSkinsForWeapon(weaponName)) do
if candidate.Category == string.char(77,101,108,101,101) then
return string.char(75,110,105,102,101)
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
if type(weapon) ~= string.char(116,97,98,108,101)
or seen[weapon]
or (weaponName and rawget(weapon, string.char(78,97,109,101)) ~= weaponName) then
return
end
local viewModel = rawget(weapon, string.char(86,105,101,119,77,111,100,101,108))
local model = type(viewModel) == string.char(116,97,98,108,101) and rawget(viewModel, string.char(77,111,100,101,108)) or nil
if typeof(model) == string.char(73,110,115,116,97,110,99,101) and model.Parent then
seen[weapon] = true
table.insert(found, weapon)
end
end

if type(WeaponClient.Inventory) == string.char(116,97,98,108,101) then
for _, weapon in pairs(WeaponClient.Inventory) do
add(weapon)
end
end
add(WeaponClient.CurrentWeapon)

if type(getgc) == string.char(102,117,110,99,116,105,111,110) then
local ok, objects = pcall(getgc, true)
if ok and type(objects) == string.char(116,97,98,108,101) then
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
warn(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,71,108,111,118,101,115,32,97,112,112,108,121,32,101,114,114,111,114,58), err)
end
end

print(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,71,108,111,118,101,115,32,114,101,102,114,101,115,104,58,32,109,97,116,99,104,101,100,61), matched, string.char(97,112,112,108,105,101,100,61), applied)
return applied, matched
end

local function findActiveWeaponClient()
local best = WeaponClient
local bestScore = -1

local function inspect(candidate)
if type(candidate) ~= string.char(116,97,98,108,101)
or type(rawget(candidate, string.char(105,110,105,116,105,97,108,105,122,101,82,111,117,110,100,87,101,97,112,111,110,115))) ~= string.char(102,117,110,99,116,105,111,110)
or type(rawget(candidate, string.char(101,113,117,105,112,70,114,111,109,83,108,111,116))) ~= string.char(102,117,110,99,116,105,111,110)
or type(rawget(candidate, string.char(73,110,118,101,110,116,111,114,121))) ~= string.char(116,97,98,108,101) then
return
end
local score = rawget(candidate, string.char(67,117,114,114,101,110,116,87,101,97,112,111,110)) and 100 or 0
for _, weapon in pairs(rawget(candidate, string.char(73,110,118,101,110,116,111,114,121))) do
if type(weapon) == string.char(116,97,98,108,101) and rawget(weapon, string.char(86,105,101,119,77,111,100,101,108)) then
score += 10
end
end
if score > bestScore then
best = candidate
bestScore = score
end
end

inspect(WeaponClient)
if type(getgc) == string.char(102,117,110,99,116,105,111,110) then
local ok, objects = pcall(getgc, true)
if ok and type(objects) == string.char(116,97,98,108,101) then
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

if weaponName == string.char(75,110,105,102,101) and meleeModel and meleeModel ~= string.char(75,110,105,102,101) then
local needsModelSwap = true
for _, weapon in ipairs(findLiveWeaponObjects(string.char(75,110,105,102,101))) do
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
warn(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,77,101,108,101,101,32,109,111,100,101,108,32,114,101,98,117,105,108,100,32,101,114,114,111,114,58), err)
elseif previousSlot and type(activeClient.equipFromSlot) == string.char(102,117,110,99,116,105,111,110) then
task.defer(function()
pcall(function()
activeClient:equipFromSlot(previousSlot)
end)
end)
end
task.delay(0.2, function()
refreshWeaponVisual(string.char(75,110,105,102,101))
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
warn(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,68,105,114,101,99,116,32,111,118,101,114,108,97,121,32,101,114,114,111,114,58), applied)
end
end

print(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,82,101,102,114,101,115,104,58), weaponName, string.char(109,97,116,99,104,101,100,61), matched, string.char(97,112,112,108,105,101,100,61), changed)
return changed, matched
end

local function applyChoice(skinData, variant)
if not selectedWeapon then
return
end

if selectedCategory == string.char(71,108,111,118,101,115) then
if skinData then
forcedGlove = {
CosmeticId = skinData.CosmeticId,
Variant = variant,
GloveType = skinData.AppliesTo,
}
_G.__NGForcedGlove = forcedGlove
local label = skinData.DisplayName or skinData.CosmeticId
if variant then
label ..= string.char(32,91) .. tostring(variant) .. string.char(93)
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
MeleeModel = skinData.Category == string.char(77,101,108,101,101) and skinData.AppliesTo or nil,
}
local label = skinData.DisplayName or skinData.CosmeticId
if variant then
label ..= string.char(32,91) .. tostring(variant) .. string.char(93)
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
local forced = selectedCategory == string.char(71,108,111,118,101,115) and forcedGlove or getSelectedForced()
row(skinsList, string.char(68,101,102,97,117,108,116,32,47,32,82,101,109,111,118,101,32,111,118,101,114,114,105,100,101), function()
applyChoice(nil, nil)
end, forced == nil)

local skins = SkinRegistry:getSkinsForWeapon(selectedWeapon)
for _, skinData in ipairs(skins) do
local baseLabel = skinData.DisplayName or skinData.CosmeticId or string.char(85,110,107,110,111,119,110)
local rarity = skinData.Rarity and (" • " .. tostring(skinData.Rarity)) or ""

if type(skinData.Variants) == string.char(116,97,98,108,101) and next(skinData.Variants) then
local variants = {}
for variantName in pairs(skinData.Variants) do
table.insert(variants, variantName)
end
table.sort(variants)
for _, variantName in ipairs(variants) do
local label = baseLabel .. string.char(32,91) .. variantName .. string.char(93) .. rarity
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

weaponSearch:GetPropertyChangedSignal(string.char(84,101,120,116)):Connect(rebuildWeapons)
skinSearch:GetPropertyChangedSignal(string.char(84,101,120,116)):Connect(rebuildSkins)

local function reapplyAllForced(reason)
for weaponName in pairs(forcedSkins) do
local changed, matched = refreshWeaponVisual(weaponName)
if matched > 0 then
print(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,65,117,116,111,32,114,101,97,112,112,108,121,58), reason, weaponName, changed)
end
end
if forcedGlove then
local changed, matched = refreshGloveVisual()
if matched > 0 then
print(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,65,117,116,111,32,114,101,97,112,112,108,121,32,103,108,111,118,101,115,58), reason, changed)
end
end
end

local respawnGeneration = 0
local function scheduleRespawnReapply(reason)
respawnGeneration += 1
local generation = respawnGeneration
task.spawn(function()

for attempt = 1, 20 do
if generation ~= respawnGeneration then
return
end
task.wait(attempt == 1 and 0.25 or 0.5)
reapplyAllForced(reason .. string.char(35) .. attempt)
end
end)
end

if _G.__NGCharacterAddedConn then
pcall(function()
_G.__NGCharacterAddedConn:Disconnect()
end)
end
_G.__NGCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function()
scheduleRespawnReapply(string.char(67,104,97,114,97,99,116,101,114,65,100,100,101,100))
end)

if _G.__NGViewModelAddedConn then
pcall(function()
_G.__NGViewModelAddedConn:Disconnect()
end)
_G.__NGViewModelAddedConn = nil
end

task.spawn(function()
local gameLogic = workspace:WaitForChild(string.char(71,97,109,101,76,111,103,105,99), 15)
local viewModels = gameLogic and gameLogic:WaitForChild(string.char(86,105,101,119,77,111,100,101,108,115), 15)
if viewModels then
_G.__NGViewModelAddedConn = viewModels.ChildAdded:Connect(function()
task.delay(0.15, function()
reapplyAllForced(string.char(86,105,101,119,77,111,100,101,108,65,100,100,101,100))
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

print(string.char(91,78,71,32,83,107,105,110,67,104,97,110,103,101,114,93,32,72,97,122,105,114,46,32,82,105,103,104,116,83,104,105,102,116,32,105,108,101,32,109,101,110,117,32,97,99,47,107,97,112,97,116,46))
end)()
