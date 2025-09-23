--[[
    Упрощенное колесо эмоций - базовая рабочая версия
]]

EmoteWheel.Wheel = {}

function EmoteWheel.Wheel:Initialize()
    self:CreateFrame()
    self.currentGroup = EmoteWheelDB.currentGroup or 1
    self:Hide()
    EmoteWheel:Print("Колесо эмоций инициализировано. Shift+ПКМ для вызова.")
end

function EmoteWheel.Wheel:CreateFrame()
    self.frame = CreateFrame("Frame", "EmoteWheelFrame", UIParent)
    self.frame:SetSize(300, 300)
    self.frame:SetPoint("CENTER")
    self.frame:SetFrameStrata("DIALOG")
    self.frame:SetClampedToScreen(true)
    self.frame:Hide()
    
    -- Фон колеса (простой черный прямоугольник с закруглениями)
    self.background = self.frame:CreateTexture(nil, "BACKGROUND")
    self.background:SetAllPoints(true)
    self.background:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    self.background:SetVertexColor(0, 0, 0, 0.9)
    
    -- Заголовок
    self.title = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.title:SetPoint("TOP", 0, -10)
    self.title:SetText("Emote Wheel - Группа 1")
    
    -- Создаем кнопки групп (простой вариант - горизонтальный ряд)
    self:CreateGroupButtons()
    
    -- Создаем кнопки эмоций
    self:CreateEmoteButtons()
end

function EmoteWheel.Wheel:CreateGroupButtons()
    self.groupButtons = {}
    local startX = -120
    local spacing = 40
    
    for i = 1, (EmoteWheelConfig.maxGroups or 4) do
        local button = CreateFrame("Button", "EmoteWheelGroupBtn"..i, self.frame)
        button:SetSize(30, 30)
        button:SetPoint("TOP", startX + (i-1) * spacing, -40)
        button.groupIndex = i
        
        -- Цветной фон
        local bg = button:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(true)
        bg:SetTexture("Interface\\Buttons\\WHITE8X8")
        local color = EmoteWheelConfig.groupColors[i] or {1, 1, 1}
        bg:SetVertexColor(color[1], color[2], color[3], 0.8)
        button.bg = bg
        
        -- Номер группы
        local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        text:SetText(i)
        
        button:SetScript("OnClick", function()
            self:SelectGroup(i)
        end)
        
        button:SetScript("OnEnter", function()
            bg:SetAlpha(1.0)
            local groupName = EmoteWheelData.groups[i] and EmoteWheelData.groups[i].name or "Группа "..i
            GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
            GameTooltip:SetText(groupName)
            GameTooltip:Show()
        end)
        
        button:SetScript("OnLeave", function()
            bg:SetAlpha(0.8)
            GameTooltip:Hide()
        end)
        
        self.groupButtons[i] = button
    end
end

function EmoteWheel.Wheel:CreateEmoteButtons()
    self.emoteButtons = {}
    -- Кнопки эмоций будут создаваться динамически
end

function EmoteWheel.Wheel:UpdateEmoteButtons()
    -- Удаляем старые кнопки
    for i, btn in ipairs(self.emoteButtons or {}) do
        btn:Hide()
    end
    
    self.emoteButtons = {}
    
    local groupData = EmoteWheelData.groups[self.currentGroup]
    if not groupData or not groupData.emotes then return end
    
    local emotes = groupData.emotes
    local startY = -80
    local spacing = 25
    
    for i, emote in ipairs(emotes) do
        local button = CreateFrame("Button", nil, self.frame)
        button:SetSize(150, 20)
        button:SetPoint("TOP", 0, startY - (i-1) * spacing)
        button.emoteData = emote
        
        -- Фон кнопки
        local bg = button:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(true)
        bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
        bg:SetVertexColor(0.1, 0.1, 0.1, 0.7)
        
        -- Текст эмоции
        local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        text:SetText(emote.name)
        text:SetTextColor(1, 1, 1)
        
        button:SetScript("OnClick", function()
            self:ExecuteEmote(emote.command, emote.name)
        end)
        
        button:SetScript("OnEnter", function()
            bg:SetVertexColor(0.3, 0.3, 0.3, 0.9)
            text:SetTextColor(1, 0.8, 0)
        end)
        
        button:SetScript("OnLeave", function()
            bg:SetVertexColor(0.1, 0.1, 0.1, 0.7)
            text:SetTextColor(1, 1, 1)
        end)
        
        self.emoteButtons[i] = button
    end
end

function EmoteWheel.Wheel:SelectGroup(groupIndex)
    self.currentGroup = groupIndex
    EmoteWheelDB.currentGroup = groupIndex
    
    -- Обновляем заголовок
    local groupName = EmoteWheelData.groups[groupIndex] and EmoteWheelData.groups[groupIndex].name or "Группа "..groupIndex
    self.title:SetText("Emote Wheel - " .. groupName)
    
    -- Обновляем кнопки эмоций
    self:UpdateEmoteButtons()
    
    -- Подсвечиваем выбранную группу
    for i, btn in ipairs(self.groupButtons) do
        if i == groupIndex then
            btn.bg:SetVertexColor(1, 1, 1, 1.0) -- Белый для выбранной
        else
            local color = EmoteWheelConfig.groupColors[i] or {1, 1, 1}
            btn.bg:SetVertexColor(color[1], color[2], color[3], 0.6) -- Полупрозрачный для остальных
        end
    end
    
    EmoteWheel:Print("Выбрана группа: " .. groupName)
end

function EmoteWheel.Wheel:ExecuteEmote(command, name)
    if command and command ~= "" then
        -- Выполняем эмоцию
        DoEmote(command)
        
        EmoteWheel:AddToLog("Эмоция: " .. name)
        self:Hide()
    else
        EmoteWheel:Print("Ошибка: команда эмоции не найдена")
    end
end

function EmoteWheel.Wheel:Show()
    if not EmoteWheelDB.enabled then 
        EmoteWheel:Print("Аддон выключен в настройках")
        return 
    end
    
    -- Позиционируем у курсора
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    self.frame:ClearAllPoints()
    self.frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
    
    -- Обновляем отображение для текущей группы
    self:SelectGroup(self.currentGroup)
    
    self.frame:Show()
end

function EmoteWheel.Wheel:Hide()
    self.frame:Hide()
end

function EmoteWheel.Wheel:SetGroup(groupIndex)
    self:SelectGroup(groupIndex)
end