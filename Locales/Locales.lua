--[[
    Система локализации для EmoteWheel
    Версия: 2.0.0
]]

EmoteWheelLocales = {}

-- Текущая локаль (определяется автоматически)
local currentLocale = GetLocale()

-- Загружаем соответствующую локаль
function EmoteWheelLocales:LoadLocale()
    -- Для WoW 3.3.5a используем упрощенную систему загрузки
    local localeData
    
    if currentLocale == "ruRU" then
        localeData = {
            -- Основные строки интерфейса
            ["ADDON_NAME"] = "Колесо Эмоций",
            ["ADDON_LOADED"] = "EmoteWheel v%s загружен. Используйте /ew для настроек.",
            ["ADDON_ENABLED"] = "Аддон включен",
            ["ADDON_DISABLED"] = "Аддон выключен",
            
            -- Команды
            ["CMD_CONFIG"] = "Открыть настройки",
            ["CMD_SHOW"] = "Показать колесо эмоций",
            ["CMD_TOGGLE"] = "Включить/выключить аддон", 
            ["CMD_VERSION"] = "Показать версию",
            
            -- Настройки
            ["SETTINGS_TITLE"] = "Emote Wheel - Настройки",
            ["SETTINGS_ENABLE"] = "Включить аддон",
            ["SETTINGS_CURRENT_GROUP"] = "Текущая группа эмоций:",
            ["SETTINGS_SHOW_TEXT"] = "Показывать названия эмоций",
            ["SETTINGS_ENABLE_HOTKEY"] = "Включить горячую клавишу",
            ["SETTINGS_TRIGGER_KEY"] = "Клавиша для вызова:",
            ["SETTINGS_FONT_SIZE"] = "Размер шрифта эмоций:",
            ["SETTINGS_BUTTON_SIZE"] = "Размер кнопок групп:",
            ["SETTINGS_EMOTE_SIZE"] = "Размер кнопок эмоций:",
            ["SETTINGS_SHOW_BG"] = "Показывать фон колеса",
            ["SETTINGS_ENABLE_COLORS"] = "Включить цветовое оформление",
            ["SETTINGS_HOVER_SWITCH"] = "Смена группы по наведению",
            ["SETTINGS_SHOW_ICONS"] = "Показывать иконки групп",
            
            -- Триггеры клавиш
            ["TRIGGER_SHIFT"] = "Shift + ПКМ",
            ["TRIGGER_CTRL"] = "Ctrl + ПКМ",
            ["TRIGGER_ALT"] = "Alt + ПКМ", 
            ["TRIGGER_NONE"] = "Только ПКМ",
            
            -- Кнопки
            ["BUTTON_VIEW_LOG"] = "Просмотр лога",
            ["BUTTON_TEST_WHEEL"] = "Тест колеса",
            ["BUTTON_RESET"] = "Сбросить настройки",
            
            -- Лог
            ["LOG_TITLE"] = "Лог EmoteWheel",
            ["LOG_CLEAR"] = "Очистить лог",
            ["LOG_EMPTY"] = "Лог пуст",
            
            -- Инструкция
            ["INSTRUCTION"] = "Использование: Shift+ПКМ для открытия колеса эмоций",
            
            -- Группы эмоций
            ["GROUP_MAIN"] = "Основные",
            ["GROUP_COMBAT"] = "Боевые",
            ["GROUP_SOCIAL"] = "Социальные", 
            ["GROUP_REACTIONS"] = "Реакции",
            ["GROUP_SOUNDS"] = "Звуки",
            ["GROUP_ACTIONS"] = "Действия",
            ["GROUP_MISC"] = "Разное",
            ["GROUP_SPECIAL"] = "Специальные"
        }
    else
        -- Английская локаль по умолчанию
        localeData = {
            -- Основные строки интерфейса
            ["ADDON_NAME"] = "Emote Wheel",
            ["ADDON_LOADED"] = "EmoteWheel v%s loaded. Use /ew for settings.",
            ["ADDON_ENABLED"] = "Addon enabled",
            ["ADDON_DISABLED"] = "Addon disabled",
            
            -- Команды
            ["CMD_CONFIG"] = "Open settings",
            ["CMD_SHOW"] = "Show emote wheel",
            ["CMD_TOGGLE"] = "Toggle addon", 
            ["CMD_VERSION"] = "Show version",
            
            -- Настройки
            ["SETTINGS_TITLE"] = "Emote Wheel - Settings",
            ["SETTINGS_ENABLE"] = "Enable addon",
            ["SETTINGS_CURRENT_GROUP"] = "Current emote group:",
            ["SETTINGS_SHOW_TEXT"] = "Show emote names",
            ["SETTINGS_ENABLE_HOTKEY"] = "Enable hotkey",
            ["SETTINGS_TRIGGER_KEY"] = "Trigger key:",
            ["SETTINGS_FONT_SIZE"] = "Emote font size:",
            ["SETTINGS_BUTTON_SIZE"] = "Group button size:",
            ["SETTINGS_EMOTE_SIZE"] = "Emote button size:",
            ["SETTINGS_SHOW_BG"] = "Show wheel background",
            ["SETTINGS_ENABLE_COLORS"] = "Enable color scheme",
            ["SETTINGS_HOVER_SWITCH"] = "Hover group switching",
            ["SETTINGS_SHOW_ICONS"] = "Show group icons",
            
            -- Триггеры клавиш
            ["TRIGGER_SHIFT"] = "Shift + RMB",
            ["TRIGGER_CTRL"] = "Ctrl + RMB",
            ["TRIGGER_ALT"] = "Alt + RMB", 
            ["TRIGGER_NONE"] = "RMB only",
            
            -- Кнопки
            ["BUTTON_VIEW_LOG"] = "View log",
            ["BUTTON_TEST_WHEEL"] = "Test wheel",
            ["BUTTON_RESET"] = "Reset settings",
            
            -- Лог
            ["LOG_TITLE"] = "EmoteWheel Log",
            ["LOG_CLEAR"] = "Clear log",
            ["LOG_EMPTY"] = "Log is empty",
            
            -- Инструкция
            ["INSTRUCTION"] = "Usage: Shift+RMB to open emote wheel",
            
            -- Группы эмоций
            ["GROUP_MAIN"] = "Main",
            ["GROUP_COMBAT"] = "Combat",
            ["GROUP_SOCIAL"] = "Social", 
            ["GROUP_REACTIONS"] = "Reactions",
            ["GROUP_SOUNDS"] = "Sounds",
            ["GROUP_ACTIONS"] = "Actions",
            ["GROUP_MISC"] = "Miscellaneous",
            ["GROUP_SPECIAL"] = "Special"
        }
    end
    
    self[currentLocale] = localeData
    return localeData
end

-- Функция для получения локализованной строки
function EmoteWheelLocales:GetString(key)
    if not self[currentLocale] then
        self:LoadLocale()
    end
    
    local locale = self[currentLocale] or {}
    return locale[key] or key -- Возвращаем ключ, если строка не найдена
end

-- Создаем глобальную функцию для удобства
function EW_L(key)
    return EmoteWheelLocales:GetString(key)
end