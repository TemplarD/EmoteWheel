--[[
    Меню настроек для EmoteWheel - исправленная версия
]]

function EmoteWheel:CreateOptionsFrame()
    -- Создаем фрейм настроек
    self.optionsFrame = CreateFrame("Frame", "EmoteWheelOptions", InterfaceOptionsFramePanelContainer)
    self.optionsFrame.name = "Emote Wheel"
    InterfaceOptions_AddCategory(self.optionsFrame)
    
    -- Заголовок
    local title = self.optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Emote Wheel - Настройки")
    
    -- Чекбокс включения аддона
    local enableCheckbox = CreateFrame("CheckButton", "EmoteWheelEnableCheckbox", self.optionsFrame, "OptionsCheckButtonTemplate")
    enableCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    enableCheckbox:SetChecked(EmoteWheelDB.enabled)
    
    local enableText = self.optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    enableText:SetPoint("LEFT", enableCheckbox, "RIGHT", 5, 0)
    enableText:SetText("Включить аддон")
    
    enableCheckbox:SetScript("OnClick", function(self)
        EmoteWheelDB.enabled = self:GetChecked()
        if EmoteWheelDB.enabled then
            EmoteWheel:Print("Аддон включен")
        else
            EmoteWheel:Print("Аддон выключен")
        end
    end)
    
    -- Выбор группы эмоций (ИСПРАВЛЕННЫЙ выпадающий список)
    local groupText = self.optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    groupText:SetPoint("TOPLEFT", enableCheckbox, "BOTTOMLEFT", 0, -15)
    groupText:SetText("Текущая группа эмоций:")
    
    local groupDropdown = CreateFrame("Frame", "EmoteWheelGroupDropdown", self.optionsFrame, "UIDropDownMenuTemplate")
    groupDropdown:SetPoint("TOPLEFT", groupText, "BOTTOMLEFT", 0, -10)
    groupDropdown:SetWidth(150)
    
    -- Функция для обновления текста выпадающего списка
    local function UpdateDropdownText()
        local groupIndex = EmoteWheelDB.currentGroup or 1
        local groupData = EmoteWheelData.groups[groupIndex]
        local text = groupData and groupData.name or ("Группа " .. groupIndex)
        UIDropDownMenu_SetText(groupDropdown, text)
    end
    
    -- Инициализация выпадающего списка
    UIDropDownMenu_Initialize(groupDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        for i = 1, (EmoteWheelConfig.maxGroups or 4) do
            local groupData = EmoteWheelData.groups[i]
            info.text = groupData and groupData.name or ("Группа " .. i)
            info.value = i
            info.func = function(button)
                EmoteWheelDB.currentGroup = button.value
                UpdateDropdownText()
                if EmoteWheel.Wheel and EmoteWheel.Wheel.SetGroup then
                    EmoteWheel.Wheel:SetGroup(button.value)
                end
                EmoteWheel:Print("Выбрана группа: " .. info.text)
            end
            info.checked = (i == EmoteWheelDB.currentGroup)
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    -- Устанавливаем начальный текст
    UpdateDropdownText()
	
	-- Настройка размера шрифта эмоций
	local fontSizeText = self.optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	fontSizeText:SetPoint("TOPLEFT", groupDropdown, "BOTTOMLEFT", 0, -5)
	fontSizeText:SetText("Размер шрифта эмоций:")

	local fontSizeSlider = CreateFrame("Slider", "EmoteWheelFontSizeSlider", self.optionsFrame, "OptionsSliderTemplate")
	fontSizeSlider:SetPoint("TOPLEFT", fontSizeText, "BOTTOMLEFT", 0, -15)
	fontSizeSlider:SetWidth(180)
	fontSizeSlider:SetHeight(15)
	fontSizeSlider:SetMinMaxValues(6, 30)
	fontSizeSlider:SetValueStep(1)
	fontSizeSlider:SetValue(EmoteWheelConfig.fonts.emoteButtons.size or 12)
	fontSizeSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value)
		EmoteWheelConfig.fonts.emoteButtons.size = value
		_G[self:GetName().."Text"]:SetText("Размер: " .. value)
		-- Обновляем колесо если оно открыто
		if EmoteWheel.Wheel and EmoteWheel.Wheel.frame and EmoteWheel.Wheel.frame:IsVisible() then
			EmoteWheel.Wheel:SelectGroup(EmoteWheelDB.currentGroup or 1)
		end
	end)

	_G[fontSizeSlider:GetName().."Low"]:SetText("6")
	_G[fontSizeSlider:GetName().."High"]:SetText("30")
	_G[fontSizeSlider:GetName().."Text"]:SetText("Размер: " .. (EmoteWheelConfig.fonts.emoteButtons.size or 12))	
    
    -- Чекбокс показа текста эмоций
    local textCheckbox = CreateFrame("CheckButton", "EmoteWheelTextCheckbox", self.optionsFrame, "OptionsCheckButtonTemplate")
    textCheckbox:SetPoint("TOPLEFT", fontSizeSlider, "BOTTOMLEFT", 0, -15)
    textCheckbox:SetChecked(EmoteWheelDB.showText)
    
    local textText = self.optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    textText:SetPoint("TOPLEFT", textCheckbox, "RIGHT", 5, 5)
    textText:SetText("Показывать названия эмоций")
    
    textCheckbox:SetScript("OnClick", function(self)
        EmoteWheelDB.showText = self:GetChecked()
        EmoteWheel:Print("Названия эмоций " .. (EmoteWheelDB.showText and "включены" or "выключены"))
    end)
	
    -- Выбор клавиши для вызова (НОВАЯ НАСТРОЙКА)
    local triggerText = self.optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    triggerText:SetPoint("TOPLEFT", textText, "BOTTOMLEFT", 0, -15)
    triggerText:SetText("Клавиша для вызова:")
    
    local triggerDropdown = CreateFrame("Frame", "EmoteWheelTriggerDropdown", self.optionsFrame, "UIDropDownMenuTemplate")
    triggerDropdown:SetPoint("TOPLEFT", triggerText, "BOTTOMLEFT", 0, -10)
    triggerDropdown:SetWidth(120)
    
    UIDropDownMenu_Initialize(triggerDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        local triggers = {
            {text = "Shift + ПКМ", value = "SHIFT"},
            {text = "Ctrl + ПКМ", value = "CTRL"},
            {text = "Alt + ПКМ", value = "ALT"},
            {text = "Только ПКМ", value = "NONE"}
        }
        
        for i, trigger in ipairs(triggers) do
            info.text = trigger.text
            info.value = trigger.value
            info.func = function(button)
                EmoteWheelDB.triggerKey = button.value
                UIDropDownMenu_SetText(triggerDropdown, trigger.text)
                EmoteWheel:Print("Клавиша вызова изменена на: " .. trigger.text)
            end
            info.checked = (trigger.value == EmoteWheelDB.triggerKey)
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    -- Устанавливаем начальный текст
    local currentTrigger = EmoteWheelDB.triggerKey or "SHIFT"
    local triggerTextMap = {SHIFT = "Shift + ПКМ", CTRL = "Ctrl + ПКМ", ALT = "Alt + ПКМ", NONE = "Только ПКМ"}
    UIDropDownMenu_SetText(triggerDropdown, triggerTextMap[currentTrigger])	
    
    -- Кнопка просмотра лога
    local logButton = CreateFrame("Button", nil, self.optionsFrame, "UIPanelButtonTemplate")
    logButton:SetPoint("TOPLEFT", triggerDropdown, "BOTTOMLEFT", 0, -15)
    logButton:SetSize(120, 25)
    logButton:SetText("Просмотр лога")
    logButton:SetScript("OnClick", function()
        self:ToggleLogFrame()
    end)
    
    -- Кнопка тестирования колеса
    local testButton = CreateFrame("Button", nil, self.optionsFrame, "UIPanelButtonTemplate")
    testButton:SetPoint("LEFT", logButton, "RIGHT", 10, 0)
    testButton:SetSize(120, 25)
    testButton:SetText("Тест колеса")
    testButton:SetScript("OnClick", function()
        if EmoteWheel.Wheel and EmoteWheel.Wheel.Show then
            EmoteWheel.Wheel:Show()
        else
            EmoteWheel:Print("Колесо еще не инициализировано")
        end
    end)
    
    -- Кнопка сброса настроек
    local resetButton = CreateFrame("Button", nil, self.optionsFrame, "UIPanelButtonTemplate")
    resetButton:SetPoint("TOPLEFT", logButton, "BOTTOMLEFT", 0, -10)
    resetButton:SetSize(120, 25)
    resetButton:SetText("Сбросить настройки")
    resetButton:SetScript("OnClick", function()
        EmoteWheelDB = {
            enabled = true,
            currentGroup = 1,
            showText = true,
            log = {}
        }
        ReloadUI() -- Перезагрузка интерфейса
    end)
    
    -- Инструкция по использованию
    local instructionText = self.optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    instructionText:SetPoint("TOPLEFT", resetButton, "BOTTOMLEFT", 0, -20)
    instructionText:SetText("Использование: Shift+ПКМ для открытия колеса эмоций")
    instructionText:SetTextColor(0.8, 0.8, 0.8)
    
    -- Создаем фрейм лога
    self:CreateLogFrame()
	
end

-- Фрейм лога (оставляем без изменений)
function EmoteWheel:CreateLogFrame()
    self.logFrame = CreateFrame("Frame", "EmoteWheelLogFrame", UIParent)
    self.logFrame:SetSize(400, 300)
    self.logFrame:SetPoint("CENTER")
    self.logFrame:SetFrameStrata("DIALOG")
    self.logFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, 
        tileSize = 32, 
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    self.logFrame:Hide()
    self.logFrame:SetMovable(true)
    self.logFrame:EnableMouse(true)
    self.logFrame:RegisterForDrag("LeftButton")
    self.logFrame:SetScript("OnDragStart", self.logFrame.StartMoving)
    self.logFrame:SetScript("OnDragStop", self.logFrame.StopMovingOrSizing)
    
    -- Заголовок лога
    local title = self.logFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Лог EmoteWheel")
    
    -- Текст лога
    self.logContent = self.logFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    self.logContent:SetPoint("TOPLEFT", 20, -40)
    self.logContent:SetPoint("BOTTOMRIGHT", -20, 40)
    self.logContent:SetJustifyH("LEFT")
    self.logContent:SetJustifyV("TOP")
    
    -- Кнопка закрытия
    local closeButton = CreateFrame("Button", nil, self.logFrame, "UIPanelButtonTemplate")
    closeButton:SetPoint("BOTTOM", 0, 15)
    closeButton:SetSize(100, 25)
    closeButton:SetText("Закрыть")
    closeButton:SetScript("OnClick", function()
        self.logFrame:Hide()
    end)
    
    -- Кнопка очистки лога
    local clearButton = CreateFrame("Button", nil, self.logFrame, "UIPanelButtonTemplate")
    clearButton:SetPoint("BOTTOM", 0, 45)
    clearButton:SetSize(100, 25)
    clearButton:SetText("Очистить лог")
    clearButton:SetScript("OnClick", function()
        EmoteWheelDB.log = {}
        self:UpdateLogDisplay()
    end)
end

function EmoteWheel:UpdateLogDisplay()
    if not self.logContent then return end
    
    local logText = "Лог действий EmoteWheel:\n\n"
    if EmoteWheelDB.log and #EmoteWheelDB.log > 0 then
        for i, entry in ipairs(EmoteWheelDB.log) do
            logText = logText .. entry .. "\n"
        end
    else
        logText = logText .. "Лог пуст"
    end
    
    self.logContent:SetText(logText)
end

function EmoteWheel:ToggleLogFrame()
    if self.logFrame:IsVisible() then
        self.logFrame:Hide()
    else
        self:UpdateLogDisplay()
        self.logFrame:Show()
    end
end