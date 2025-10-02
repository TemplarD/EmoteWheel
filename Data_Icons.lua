--[[
    База данных иконок для WoW 3.3.5a
    Версия: 2.0.0
]]

EmoteWheelIcons = {
    -- Основные иконки интерфейса
    ["Ability_Druid_ChallangingRoar"] = "Interface\\Icons\\Ability_Druid_ChallangingRoar",
    ["Ability_Warrior_BattleShout"] = "Interface\\Icons\\Ability_Warrior_BattleShout",
    ["Spell_Holy_BorrowedTime"] = "Interface\\Icons\\Spell_Holy_BorrowedTime",
    ["Ability_Creature_Cursed_03"] = "Interface\\Icons\\Ability_Creature_Cursed_03",
    ["Ability_Rogue_Disguise"] = "Interface\\Icons\\Ability_Rogue_Disguise",
    ["Ability_Hunter_Pet_Bear"] = "Interface\\Icons\\Ability_Hunter_Pet_Bear",
    ["INV_Misc_QuestionMark"] = "Interface\\Icons\\INV_Misc_QuestionMark",
    ["Spell_Shadow_SoulGem"] = "Interface\\Icons\\Spell_Shadow_SoulGem",
    
    -- Эмоции и действия
    ["Ability_CheapShot"] = "Interface\\Icons\\Ability_CheapShot",
    ["Ability_Druid_Cower"] = "Interface\\Icons\\Ability_Druid_Cower",
    ["Ability_Druid_TigerRoar"] = "Interface\\Icons\\Ability_Druid_TigerRoar",
    ["Ability_GolemThunderClap"] = "Interface\\Icons\\Ability_GolemThunderClap",
    ["Ability_Hunter_BeastCall"] = "Interface\\Icons\\Ability_Hunter_BeastCall",
    ["Ability_Racial_BearForm"] = "Interface\\Icons\\Ability_Racial_BearForm",
    ["Ability_Racial_ShadowMeld"] = "Interface\\Icons\\Ability_Racial_ShadowMeld",
    ["Ability_Rogue_Sprint"] = "Interface\\Icons\\Ability_Rogue_Sprint",
    ["Ability_Warrior_Charge"] = "Interface\\Icons\\Ability_Warrior_Charge",
    ["Ability_Warrior_ShieldBash"] = "Interface\\Icons\\Ability_Warrior_ShieldBash",
    
    -- Заклинания
    ["Spell_Holy_Resurrection"] = "Interface\\Icons\\Spell_Holy_Resurrection",
    ["Spell_Nature_Teleportation"] = "Interface\\Icons\\Spell_Nature_Teleportation",
    ["Spell_Shadow_DeathScream"] = "Interface\\Icons\\Spell_Shadow_DeathScream",
    ["Spell_Shadow_Metamorphosis"] = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
    ["Spell_Shadow_RagingScream"] = "Interface\\Icons\\Spell_Shadow_RagingScream",
    ["Spell_Shadow_SoothingKiss"] = "Interface\\Icons\\Spell_Shadow_SoothingKiss",
    
    -- Предметы и прочее
    ["INV_Ammo_Arrow_01"] = "Interface\\Icons\\INV_Ammo_Arrow_01",
    ["INV_Drink_01"] = "Interface\\Icons\\INV_Drink_01",
    ["INV_Drink_05"] = "Interface\\Icons\\INV_Drink_05",
    ["INV_Drink_10"] = "Interface\\Icons\\INV_Drink_10",
    ["INV_Misc_Bag_07"] = "Interface\\Icons\\INV_Misc_Bag_07",
    ["INV_Misc_Bone_01"] = "Interface\\Icons\\INV_Misc_Bone_01",
    ["INV_Misc_Book_01"] = "Interface\\Icons\\INV_Misc_Book_01",
    ["INV_Misc_Flower_01"] = "Interface\\Icons\\INV_Misc_Flower_01",
    ["INV_Misc_Food_15"] = "Interface\\Icons\\INV_Misc_Food_15",
    ["INV_Misc_Gem_Pearl_03"] = "Interface\\Icons\\INV_Misc_Gem_Pearl_03",
    ["INV_Misc_Head_Human_01"] = "Interface\\Icons\\INV_Misc_Head_Human_01",
    ["INV_Misc_Horn_01"] = "Interface\\Icons\\INV_Misc_Horn_01",
    ["INV_Misc_Organ_01"] = "Interface\\Icons\\INV_Misc_Organ_01",
    ["INV_Misc_Orb_01"] = "Interface\\Icons\\INV_Misc_Orb_01",
    ["INV_Weapon_Bow_07"] = "Interface\\Icons\\INV_Weapon_Bow_07",
    
    -- Значки профессий
    ["Trade_Alchemy"] = "Interface\\Icons\\Trade_Alchemy",
    ["Trade_BlackSmithing"] = "Interface\\Icons\\Trade_BlackSmithing",
    ["Trade_BrewPoison"] = "Interface\\Icons\\Trade_BrewPoison",
    ["Trade_Engineering"] = "Interface\\Icons\\Trade_Engineering",
    ["Trade_Fishing"] = "Interface\\Icons\\Trade_Fishing",
    ["Trade_Herbalism"] = "Interface\\Icons\\Trade_Herbalism",
    ["Trade_Mining"] = "Interface\\Icons\\Trade_Mining",
    ["Trade_Tailoring"] = "Interface\\Icons\\Trade_Tailoring",
    
    -- Жестикуляция
    ["Ability_Kick"] = "Interface\\Icons\\Ability_Kick",
    ["Ability_Point"] = "Interface\\Icons\\Ability_Point",
    ["Ability_Smash"] = "Interface\\Icons\\Ability_Smash",
    ["Ability_Whirlwind"] = "Interface\\Icons\\Ability_Whirlwind",
    
    -- Разное
    ["Spell_Nature_EarthBind"] = "Interface\\Icons\\Spell_Nature_EarthBind",
    ["Spell_Nature_ForceOfNature"] = "Interface\\Icons\\Spell_Nature_ForceOfNature",
    ["Spell_Nature_StormReach"] = "Interface\\Icons\\Spell_Nature_StormReach",
    ["Spell_Nature_ThunderClap"] = "Interface\\Icons\\Spell_Nature_ThunderClap"
}

-- Группы иконок для удобного выбора в настройках
EmoteWheelIconCategories = {
    ["Основные"] = {
        "Ability_Druid_ChallangingRoar",
        "Ability_Warrior_BattleShout", 
        "Spell_Holy_BorrowedTime",
        "Ability_Creature_Cursed_03",
        "Ability_Rogue_Disguise",
        "Ability_Hunter_Pet_Bear",
        "INV_Misc_QuestionMark",
        "Spell_Shadow_SoulGem"
    },
    ["Эмоции"] = {
        "Ability_CheapShot",
        "Ability_Druid_Cower",
        "Ability_Druid_TigerRoar",
        "Ability_GolemThunderClap",
        "Ability_Hunter_BeastCall",
        "Ability_Racial_BearForm",
        "Ability_Racial_ShadowMeld",
        "Ability_Rogue_Sprint"
    },
    ["Действия"] = {
        "Ability_Warrior_Charge",
        "Ability_Warrior_ShieldBash",
        "INV_Drink_01",
        "INV_Misc_Food_15",
        "INV_Misc_Book_01",
        "Trade_Fishing",
        "Ability_Kick",
        "Ability_Point"
    },
    ["Магия"] = {
        "Spell_Holy_Resurrection",
        "Spell_Nature_Teleportation", 
        "Spell_Shadow_DeathScream",
        "Spell_Shadow_Metamorphosis",
        "Spell_Nature_EarthBind",
        "Spell_Nature_ForceOfNature",
        "Spell_Nature_StormReach",
        "Spell_Nature_ThunderClap"
    }
}

-- Функция для получения иконки по имени
function EmoteWheelIcons:GetIconPath(iconName)
    return self[iconName] or "Interface\\Icons\\INV_Misc_QuestionMark"
end

-- Функция для получения списка всех иконок
function EmoteWheelIcons:GetAllIcons()
    local icons = {}
    for name, path in pairs(self) do
        if type(path) == "string" then
            table.insert(icons, {name = name, path = path})
        end
    end
    table.sort(icons, function(a, b) return a.name < b.name end)
    return icons
end

-- Функция для поиска иконок по ключевому слову
function EmoteWheelIcons:SearchIcons(searchTerm)
    local results = {}
    searchTerm = searchTerm:lower()
    
    for name, path in pairs(self) do
        if type(path) == "string" and name:lower():find(searchTerm, 1, true) then
            table.insert(results, {name = name, path = path})
        end
    end
    
    table.sort(results, function(a, b) return a.name < b.name end)
    return results
end