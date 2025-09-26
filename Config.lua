EmoteWheelConfig = {
    -- Радиусы для кругового меню
    groupRingRadius = 100,     -- Радиус для групп
    emoteRingRadius = 130,     -- Радиус для эмоций
    
    -- Размеры элементов
    groupButtonSize = 40,      -- Размер кнопок групп
    emoteButtonWidth = 130,    -- Ширина кнопок эмоций
    emoteButtonHeight = 28,    -- Высота кнопок эмоций
    
    -- Количество групп
    maxGroups = 8,
    
    -- Цвета групп
    groupColors = {
        {1.0, 0.2, 0.2},    -- Красный - Основные
        {0.2, 1.0, 0.2},    -- Зеленый - Боевые  
        {0.2, 0.4, 1.0},    -- Синий - Социальные
        {1.0, 1.0, 0.2},    -- Желтый - Реакции
        {1.0, 0.2, 1.0},    -- Пурпурный - Звуки
        {0.2, 1.0, 1.0},    -- Голубой - Действия
        {1.0, 0.6, 0.2},    -- Оранжевый - Разное
        {0.6, 0.2, 0.8}     -- Фиолетовый - Специальные
    },
    
    -- Настройки прозрачности
    backgroundAlpha = 0.9,
    groupAlpha = 0.8,
    emoteAlpha = 0.7,
	
    -- НАСТРОЙКИ ШРИФТОВ (НОВОЕ)
    fonts = {
        groupTitle = {
            font = "Fonts\\FRIZQT__.TTF",
            size = 26,
            outline = "NORMAL" -- NORMAL, THICK, OUTLINE, MONOCHROME
        },
        emoteButtons = {
            font = "Fonts\\ARIALN.TTF", 
            size = 20,
            outline = "NORMAL"
        },
        groupButtons = {
            font = "Fonts\\FRIZQT__.TTF",
            size = 16,
            outline = "OUTLINE"
        }
    },
	
    -- НОВЫЕ РЕЖИМЫ РАБОТЫ
    interactionMode = "CLICK", -- CLICK, HOVER, TREE
    enableHoverPreview = true,
	
    -- Иконки для групп
    groupIcons = {
        "Interface\\Icons\\Ability_Druid_ChallangingRoar",    -- 1. Основные
        "Interface\\Icons\\Ability_Warrior_BattleShout",      -- 2. Боевые
        "Interface\\Icons\\Spell_Holy_BorrowedTime",          -- 3. Социальные
        "Interface\\Icons\\Ability_Creature_Cursed_03",       -- 4. Реакции
        "Interface\\Icons\\Ability_Rogue_Disguise",           -- 5. Звуки
        "Interface\\Icons\\Ability_Hunter_Pet_Bear",          -- 6. Действия
        "Interface\\Icons\\INV_Misc_QuestionMark",            -- 7. Разное
        "Interface\\Icons\\Spell_Shadow_SoulGem"              -- 8. Специальные
    }
}