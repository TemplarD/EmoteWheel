--[[
    Основной файл аддона EmoteWheel
    Версия: 1.1.0
]]

-- Глобальная таблица аддона
EmoteWheel = {}
EmoteWheel.VERSION = "1.1.0"

-- База данных для сохранения настроек
EmoteWheelDB = EmoteWheelDB or {
    enabled = true,
    currentGroup = 1,
    showText = true,
    closeOnClick = true,
    triggerKey = "SHIFT", -- SHIFT, CTRL, ALT, NONE
    buttonSize = 50,           -- Размер кнопок групп
    emoteButtonSize = 35,      -- Размер кнопок эмоций
    showBackground = true, -- Добавьте
    enableColors = true, -- Добавьте
    hoverGroupSwitch = false, -- Добавьте
    log = {}
}

-- Функция инициализации аддона
function EmoteWheel:OnInitialize()
    self:Print("EmoteWheel v" .. self.VERSION .. " загружен. Используйте /ew для настроек.")
    
    -- Сначала создаем настройки
    self:CreateOptionsFrame()
    
    -- Затем инициализируем колесо
    if self.Wheel and self.Wheel.Initialize then
        self.Wheel:Initialize()
    end
    
    -- Регистрируем slash команды
    SLASH_EMOTEWHEEL1 = "/emotewheel"
    SLASH_EMOTEWHEEL2 = "/ew"
    SlashCmdList["EMOTEWHEEL"] = function(msg)
        self:HandleSlashCommand(msg)
    end
    
    -- Регистрируем обработчик мыши
    self:RegisterMouseHandler()
end

-- Обработка slash команд
function EmoteWheel:HandleSlashCommand(msg)
    msg = msg:lower()
    
    if msg == "config" or msg == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    elseif msg == "toggle" then
        EmoteWheelDB.enabled = not EmoteWheelDB.enabled
        self:Print("Аддон " .. (EmoteWheelDB.enabled and "включен" or "выключен"))
    elseif msg == "show" or msg == "menu" then
        if self.Wheel and self.Wheel.Show then
            self.Wheel:Show()
        else
            self:Print("Колесо не доступно")
        end
    elseif msg == "version" then
        self:Print("Версия: " .. self.VERSION)
    else
        self:Print("Доступные команды:")
        self:Print("/ew config - Открыть настройки")
        self:Print("/ew show - Показать колесо эмоций")
        self:Print("/ew toggle - Включить/выключить аддон")
        self:Print("/ew version - Показать версию")
    end
end

-- Регистрация обработчика мыши
function EmoteWheel:RegisterMouseHandler()
    WorldFrame:HookScript("OnMouseDown", function(_, button)
        if button == "RightButton" and EmoteWheel:ShouldShowWheel() then
            if EmoteWheel.Wheel and EmoteWheel.Wheel.Show then
                EmoteWheel.Wheel:Show()
                return true -- Блокируем стандартное меню
            end
        end
    end)
end

function EmoteWheel:ShouldShowWheel()
    if not EmoteWheelDB.enabled then return false end
    if not EmoteWheelDB.enableHotkey then return false end -- НОВОЕ: проверка включения горячей клавиши	
    
    local triggerKey = EmoteWheelDB.triggerKey or "SHIFT"
    
    if triggerKey == "SHIFT" then
        return IsShiftKeyDown()
    elseif triggerKey == "CTRL" then
        return IsControlKeyDown()
    elseif triggerKey == "ALT" then
        return IsAltKeyDown()
    elseif triggerKey == "NONE" then
        return true
    end
    
    return false
end

-- Функция для вывода сообщений в чат
function EmoteWheel:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00EmoteWheel:|r " .. msg)
end

-- Функция добавления записи в лог
function EmoteWheel:AddToLog(action)
    EmoteWheelDB.log = EmoteWheelDB.log or {}
    table.insert(EmoteWheelDB.log, 1, date("%H:%M:%S") .. " - " .. action)
    
    -- Ограничиваем лог 20 записями
    while #EmoteWheelDB.log > 20 do
        table.remove(EmoteWheelDB.log, 21)
    end
end

-- Регистрируем события
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "EmoteWheel" then
        EmoteWheel:OnInitialize()
    end
end)