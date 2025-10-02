--[[
    Меню настроек для EmoteWheel - версия 2.0.0 с локализацией
]]

function EmoteWheel:CreateOptionsFrame()
    -- Создаем фрейм настроек
    self.optionsFrame = CreateFrame("Frame", "EmoteWheelOptions", InterfaceOptionsFramePanelContainer)
    self.optionsFrame.name = EW_L("ADDON_NAME")
    self.optionsFrame:SetSize(1, 1) -- Важно для работы скролла
	
    -- Создаем ScrollFrame
    local scrollFrame = CreateFrame("ScrollFrame", "EmoteWheelScrollFrame", self.optionsFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -10)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)
    
    -- Создаем child frame для содержимого
    local scrollChild = CreateFrame("Frame", "EmoteWheelScrollChild")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth() - 40)
    scrollChild:SetHeight(1) -- Высота будет регулироваться по содержимому
    
    -- Автоматически рассчитываем высоту содержимого
    local function UpdateScrollChildHeight()
        local height = 1
        local lastElement = instructionText -- или самый нижний элемент
        
        if lastElement then
            local _, _, _, bottom = lastElement:GetBoundsRect()
            height = math.abs(bottom) + 10
        end
        
        scrollChild:SetHeight(math.max(height, scrollFrame:GetHeight()))
    end
    
    -- Заголовок	
    local title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(EW_L("SETTINGS_TITLE"))
	
    -- Чекбокс включения аддона
    local enableCheckbox = CreateFrame("CheckButton", "EmoteWheelEnableCheckbox", scrollChild, "OptionsCheckButtonTemplate")
    enableCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    enableCheckbox:SetChecked(EmoteWheelDB.enabled)
    
    local enableText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    enableText:SetPoint("LEFT", enableCheckbox, "RIGHT", 5, 0)
    enableText:SetText(EW_L("SETTINGS_ENABLE"))
    
    enableCheckbox:SetScript("OnClick", function(self)
        EmoteWheelDB.enabled = self:GetChecked()
        if EmoteWheelDB.enabled then
            EmoteWheel:Print(EW_L("ADDON_ENABLED"))
        else
            EmoteWheel:Print(EW_L("ADDON_DISABLED"))
        end
    end)
    
    -- Выбор группы эмоций
    local groupText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    groupText:SetPoint("TOPLEFT", enableCheckbox, "BOTTOMLEFT", 0, -15)
    groupText:SetText(EW_L("SETTINGS_CURRENT_GROUP"))
    
    local groupDropdown = CreateFrame("Frame", "EmoteWheelGroupDropdown", scrollChild, "UIDropDownMenuTemplate")
    groupDropdown:SetPoint("TOPLEFT", groupText, "BOTTOMLEFT", 0, -10)
    groupDropdown:SetWidth(150)
    
    -- Функция для обновления текста выпадающего списка
    local function UpdateDropdownText()
        local groupIndex = EmoteWheelDB.currentGroup or 1
        local groupData = EmoteWheelData.groups[groupIndex]
        local text = groupData and groupData.name or (EW_L("GROUP_MAIN") .. " " .. groupIndex)
        UIDropDownMenu_SetText(groupDropdown, text)
    end
    
    -- Инициализация выпадающего списка
    UIDropDownMenu_Initialize(groupDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        for i = 1, (EmoteWheelConfig.maxGroups or 4) do
            local groupData = EmoteWheelData.groups[i]
            info.text = groupData and groupData.name or (EW_L("GROUP_MAIN") .. " " .. i)
            info.value = i
            info.func = function(button)
                EmoteWheelDB.currentGroup = button.value
                UpdateDropdownText()
                if EmoteWheel.Wheel and EmoteWheel.Wheel.SetGroup then
                    EmoteWheel.Wheel:SetGroup(button.value)
                end
                EmoteWheel:Print(EW_L("SETTINGS_CURRENT_GROUP") .. " " .. info.text)
            end
            info.checked = (i == EmoteWheelDB.currentGroup)
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    -- Устанавливаем начальный текст
    UpdateDropdownText()
	
	-- Настройка размера шрифта эмоций
	local fontSizeText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	fontSizeText:SetPoint("TOPLEFT", groupDropdown, "BOTTOMLEFT", 0, -15)
	fontSizeText:SetText(EW_L("SETTINGS_FONT_SIZE"))

	local fontSizeSlider = CreateFrame("Slider", "EmoteWheelFontSizeSlider", scrollChild, "OptionsSliderTemplate")
	fontSizeSlider:SetPoint("TOPLEFT", fontSizeText, "BOTTOMLEFT", 0, -15)
	fontSizeSlider:SetWidth(180)
	fontSizeSlider:SetHeight(15)
	fontSizeSlider:SetMinMaxValues(6, 30)
	fontSizeSlider:SetValueStep(1)
	fontSizeSlider:SetValue(EmoteWheelConfig.fonts.emoteButtons.size or 12)
	fontSizeSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value)
		EmoteWheelConfig.fonts.emoteButtons.size = value
		_G[self:GetName().."Text"]:SetText(EW_L("SETTINGS_FONT_SIZE") .. ": " .. value)
		-- Обновляем колесо если оно открыто
		if EmoteWheel.Wheel and EmoteWheel.Wheel.frame and EmoteWheel.Wheel.frame:IsVisible() then
			EmoteWheel.Wheel:SelectGroup(EmoteWheelDB.currentGroup or 1)
		end
	end)

	_G[fontSizeSlider:GetName().."Low"]:SetText("6")
	_G[fontSizeSlider:GetName().."High"]:SetText("30")
	_G[fontSizeSlider:GetName().."Text"]:SetText(EW_L("SETTINGS_FONT_SIZE") .. ": " .. (EmoteWheelConfig.fonts.emoteButtons.size or 12))	
    
    -- Чекбокс показа текста эмоций
    local textCheckbox = CreateFrame("CheckButton", "EmoteWheelTextCheckbox", scrollChild, "OptionsCheckButtonTemplate")
    textCheckbox:SetPoint("TOPLEFT", fontSizeSlider, "BOTTOMLEFT", 0, -15)
    textCheckbox:SetChecked(EmoteWheelDB.showText)
    
    local textText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    textText:SetPoint("TOPLEFT", textCheckbox, "RIGHT", 5, 5)
    textText:SetText(EW_L("SETTINGS_SHOW_TEXT"))
    
    textCheckbox:SetScript("OnClick", function(self)
        EmoteWheelDB.showText = self:GetChecked()
        EmoteWheel:Print(EW_L("SETTINGS_SHOW_TEXT") .. " " .. (EmoteWheelDB.showText and EW_L("ADDON_ENABLED") or EW_L("ADDON_DISABLED")))
    end)
	
    -- Чекбокс включения горячей клавиши
    local hotkeyCheckbox = CreateFrame("CheckButton", "EmoteWheelHotkeyCheckbox", scrollChild, "OptionsCheckButtonTemplate")
    hotkeyCheckbox:SetPoint("TOPLEFT", textCheckbox, "BOTTOMLEFT", 0, -15)
    hotkeyCheckbox:SetChecked(EmoteWheelDB.enableHotkey)

    local hotkeyText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    hotkeyText:SetPoint("LEFT", hotkeyCheckbox, "RIGHT", 5, 0)
    hotkeyText:SetText(EW_L("SETTINGS_ENABLE_HOTKEY"))

    hotkeyCheckbox:SetScript("OnClick", function(self)
        EmoteWheelDB.enableHotkey = self:GetChecked()
        EmoteWheel:Print(EW_L("SETTINGS_ENABLE_HOTKEY") .. " " .. (EmoteWheelDB.enableHotkey and EW_L("ADDON_ENABLED") or EW_L("ADDON_DISABLED")))
        -- Перерегистрируем обработчик
        EmoteWheel:RegisterMouseHandler()
    end)	
	
    -- Выбор клавиши для вызова
    local triggerText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    triggerText:SetPoint("TOPLEFT", hotkeyCheckbox, "BOTTOMLEFT", 0, -15)
    triggerText:SetText(EW_L("SETTINGS_TRIGGER_KEY"))
    
    local triggerDropdown = CreateFrame("Frame", "EmoteWheelTriggerDropdown", scrollChild, "UIDropDownMenuTemplate")
    triggerDropdown:SetPoint("TOPLEFT", triggerText, "BOTTOMLEFT", 0, -10)
    triggerDropdown:SetWidth(120)
    
    UIDropDownMenu_Initialize(triggerDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        local triggers = {
            {text = EW_L("TRIGGER_SHIFT"), value = "SHIFT"},
            {text = EW_L("TRIGGER_CTRL"), value = "CTRL"},
            {text = EW_L("TRIGGER_ALT"), value = "ALT"},
            {text = EW_L("TRIGGER_NONE"), value = "NONE"}
        }
        
        for i, trigger in ipairs(triggers) do
            info.text = trigger.text
            info.value = trigger.value
            info.func = function(button)
                EmoteWheelDB.triggerKey = button.value
                UIDropDownMenu_SetText(triggerDropdown, trigger.text)
                EmoteWheel:Print(EW_L("SETTINGS_TRIGGER_KEY") .. " " .. trigger.text)
            end
            info.checked = (trigger.value == EmoteWheelDB.triggerKey)
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    -- Устанавливаем начальный текст
    local currentTrigger = EmoteWheelDB.triggerKey or "SHIFT"
    local triggerTextMap = {
        SHIFT = EW_L("TRIGGER_SHIFT"), 
        CTRL = EW_L("TRIGGER_CTRL"), 
        ALT = EW_L("TRIGGER_ALT"), 
        NONE = EW_L("TRIGGER_NONE")
    }
    UIDropDownMenu_SetText(triggerDropdown, triggerTextMap[currentTrigger])	
    
    -- Кнопка просмотра лога
    local logButton = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    logButton:SetPoint("TOPLEFT", triggerDropdown, "BOTTOMLEFT", 0, -15)
    logButton:SetSize(120, 25)
    logButton:SetText(EW_L("BUTTON_VIEW_LOG"))
    logButton:SetScript("OnClick", function()
        self:ToggleLogFrame()
    end)
    
    -- Кнопка тестирования колеса
    local testButton = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    testButton:SetPoint("LEFT", logButton, "RIGHT", 10, 0)
    testButton:SetSize(120, 25)
    testButton:SetText(EW_L("BUTTON_TEST_WHEEL"))
    testButton:SetScript("OnClick", function()
        if EmoteWheel.Wheel and EmoteWheel.Wheel.Show then
            EmoteWheel.Wheel:Show()
        else
            EmoteWheel:Print("Колесо еще не инициализировано")
        end
    end)
    
    -- Кнопка сброса настроек
    local resetButton = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    resetButton:SetPoint("TOPLEFT", logButton, "BOTTOMLEFT", 0, -10)
    resetButton:SetSize(120, 25)
    resetButton:SetText(EW_L("BUTTON_RESET"))
	resetButton:SetScript("OnClick", function()
		EmoteWheelDB = {
			enabled = true,
			currentGroup = 1,
			showText = true,
			closeOnClick = true,
			triggerKey = "SHIFT",
			buttonSize = 50,
			emoteButtonSize = 35,
			showBackground = true,
			enableColors = true,
			hoverGroupSwitch = false,
			showIcons = true,
			enableHotkey = false,
			log = {}
		}
		ReloadUI()
	end)
    
    -- Инструкция по использованию
    local instructionText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    instructionText:SetPoint("TOPLEFT", resetButton, "BOTTOMLEFT", 0, -20)
    instructionText:SetText(EW_L("INSTRUCTION"))
    instructionText:SetTextColor(0.8, 0.8, 0.8)
    
    -- Создаем фрейм лога
    self:CreateLogFrame()
	
	-- Слайдер размера кнопок групп
	local buttonSizeText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	buttonSizeText:SetPoint("TOPLEFT", instructionText, "BOTTOMLEFT", 0, -15)
	buttonSizeText:SetText(EW_L("SETTINGS_BUTTON_SIZE"))

	local buttonSizeSlider = CreateFrame("Slider", "EmoteWheelButtonSizeSlider", scrollChild, "OptionsSliderTemplate")
	buttonSizeSlider:SetPoint("TOPLEFT", buttonSizeText, "BOTTOMLEFT", 0, -10)
	buttonSizeSlider:SetWidth(180)
	buttonSizeSlider:SetMinMaxValues(30, 80)
	buttonSizeSlider:SetValueStep(1)
	buttonSizeSlider:SetValue(EmoteWheelDB.buttonSize or 50)
	buttonSizeSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value)
		EmoteWheelDB.buttonSize = value
		_G[self:GetName().."Text"]:SetText(EW_L("SETTINGS_BUTTON_SIZE") .. ": " .. value)
		-- Обновляем колесо
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateButtonSizes then
			EmoteWheel.Wheel:UpdateButtonSizes()
		end
	end)
	
	_G[buttonSizeSlider:GetName().."Low"]:SetText("30")
	_G[buttonSizeSlider:GetName().."High"]:SetText("80")
	_G[buttonSizeSlider:GetName().."Text"]:SetText(EW_L("SETTINGS_BUTTON_SIZE") .. ": " .. (EmoteWheelDB.buttonSize or 50))
	
	-- Слайдер размера кнопок эмоций
	local emoteButtonSizeText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	emoteButtonSizeText:SetPoint("TOPLEFT", buttonSizeSlider, "BOTTOMLEFT", 0, -15)
	emoteButtonSizeText:SetText(EW_L("SETTINGS_EMOTE_SIZE"))

	local emoteButtonSizeSlider = CreateFrame("Slider", "EmoteWheelEmoteButtonSizeSlider", scrollChild, "OptionsSliderTemplate")
	emoteButtonSizeSlider:SetPoint("TOPLEFT", emoteButtonSizeText, "BOTTOMLEFT", 0, -10)
	emoteButtonSizeSlider:SetWidth(180)
	emoteButtonSizeSlider:SetMinMaxValues(20, 60)
	emoteButtonSizeSlider:SetValueStep(1)
	emoteButtonSizeSlider:SetValue(EmoteWheelDB.emoteButtonSize or 35)
	emoteButtonSizeSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value)
		EmoteWheelDB.emoteButtonSize = value
		_G[self:GetName().."Text"]:SetText(EW_L("SETTINGS_EMOTE_SIZE") .. ": " .. value)
		-- Обновляем колесо
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateButtonSizes then
			EmoteWheel.Wheel:UpdateButtonSizes()
		end
	end)
	
	_G[emoteButtonSizeSlider:GetName().."Low"]:SetText("20")
	_G[emoteButtonSizeSlider:GetName().."High"]:SetText("60")
	_G[emoteButtonSizeSlider:GetName().."Text"]:SetText(EW_L("SETTINGS_EMOTE_SIZE") .. ": " .. (EmoteWheelDB.emoteButtonSize or 35))	
	
	-- Чекбокс фона колеса
	local bgCheckbox = CreateFrame("CheckButton", "EmoteWheelBgCheckbox", scrollChild, "OptionsCheckButtonTemplate")
	bgCheckbox:SetPoint("TOPLEFT", emoteButtonSizeSlider, "BOTTOMLEFT", 0, -15)
	bgCheckbox:SetChecked(EmoteWheelDB.showBackground)

	local bgText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	bgText:SetPoint("LEFT", bgCheckbox, "RIGHT", 5, 0)
	bgText:SetText(EW_L("SETTINGS_SHOW_BG"))

	bgCheckbox:SetScript("OnClick", function(self)
		EmoteWheelDB.showBackground = self:GetChecked()
		-- Обновляем отображение фона
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateBackground then
			EmoteWheel.Wheel:UpdateBackground()
		end
	end)	
	
	-- Чекбокс цветового оформления
	local colorsCheckbox = CreateFrame("CheckButton", "EmoteWheelColorsCheckbox", scrollChild, "OptionsCheckButtonTemplate")
	colorsCheckbox:SetPoint("TOPLEFT", bgCheckbox, "BOTTOMLEFT", 0, -15)
	colorsCheckbox:SetChecked(EmoteWheelDB.enableColors)

	local colorsText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	colorsText:SetPoint("LEFT", colorsCheckbox, "RIGHT", 5, 0)
	colorsText:SetText(EW_L("SETTINGS_ENABLE_COLORS"))

	colorsCheckbox:SetScript("OnClick", function(self)
		EmoteWheelDB.enableColors = self:GetChecked()
		-- Обновляем все визуальные элементы
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateColors then
			EmoteWheel.Wheel:UpdateColors()
		end
	end)	
	
	-- Чекбокс смены группы по наведению
	local hoverCheckbox = CreateFrame("CheckButton", "EmoteWheelHoverCheckbox", scrollChild, "OptionsCheckButtonTemplate")
	hoverCheckbox:SetPoint("TOPLEFT", colorsCheckbox, "BOTTOMLEFT", 0, -15)
	hoverCheckbox:SetChecked(EmoteWheelDB.hoverGroupSwitch)

	local hoverText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	hoverText:SetPoint("LEFT", hoverCheckbox, "RIGHT", 5, 0)
	hoverText:SetText(EW_L("SETTINGS_HOVER_SWITCH"))

	hoverCheckbox:SetScript("OnClick", function(self)
		EmoteWheelDB.hoverGroupSwitch = self:GetChecked()
		EmoteWheel:Print(EW_L("SETTINGS_HOVER_SWITCH") .. " " .. (EmoteWheelDB.hoverGroupSwitch and EW_L("ADDON_ENABLED") or EW_L("ADDON_DISABLED")))
	end)	
	
	-- Чекбокс показа иконок групп
	local iconsCheckbox = CreateFrame("CheckButton", "EmoteWheelIconsCheckbox", scrollChild, "OptionsCheckButtonTemplate")
	iconsCheckbox:SetPoint("TOPLEFT", hoverCheckbox, "BOTTOMLEFT", 0, -15)
	iconsCheckbox:SetChecked(EmoteWheelDB.showIcons)

	local iconsText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	iconsText:SetPoint("LEFT", iconsCheckbox, "RIGHT", 5, 0)
	iconsText:SetText(EW_L("SETTINGS_SHOW_ICONS"))

	iconsCheckbox:SetScript("OnClick", function(self)
		EmoteWheelDB.showIcons = self:GetChecked()
		-- Обновляем отображение кнопок групп
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateGroupIcons then
			EmoteWheel.Wheel:UpdateGroupIcons()
		end
	end)
	
	-- НОВОЕ: Выбор иконок для групп
	local groupIconsText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	groupIconsText:SetPoint("TOPLEFT", iconsCheckbox, "BOTTOMLEFT", 0, -15)
	groupIconsText:SetText("Выбор иконок для групп:")
	
	-- Создаем кнопки выбора иконок для каждой группы
	self.groupIconButtons = {}
	for i = 1, (EmoteWheelConfig.maxGroups or 4) do
		local groupIconButton = CreateFrame("Button", "EmoteWheelGroupIconBtn"..i, scrollChild, "UIPanelButtonTemplate")
		groupIconButton:SetSize(80, 25)
		groupIconButton:SetPoint("TOPLEFT", groupIconsText, "BOTTOMLEFT", (i-1)*85, -10)
		groupIconButton:SetText("Группа "..i)
		groupIconButton.groupIndex = i
		
		groupIconButton:SetScript("OnClick", function(self)
			self:SelectGroupIcon()
		end)
		
		self.groupIconButtons[i] = groupIconButton
	end
	   
    -- Вызываем после создания всех элементов
    UpdateScrollChildHeight()	
	
    InterfaceOptions_AddCategory(self.optionsFrame)	
	
end

-- НОВАЯ ФУНКЦИЯ: Выбор иконки для группы
function EmoteWheel:SelectGroupIcon(groupIndex)
    -- Создаем выпадающее меню для выбора иконки
    local dropdown = CreateFrame("Frame", "EmoteWheelIconSelectDropdown", UIParent, "UIDropDownMenuTemplate")
    
    UIDropDownMenu_Initialize(dropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        -- Добавляем категории иконок
        for categoryName, icons in pairs(EmoteWheelIconCategories) do
            info.text = categoryName
            info.hasArrow = true
            info.value = categoryName
            info.notCheckable = true
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    
    -- Показываем меню у курсора
    ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
end

-- Фрейм лога (обновлен с локализацией)
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
    title:SetText(EW_L("LOG_TITLE"))
    
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
    closeButton:SetText(CLOSE)
    closeButton:SetScript("OnClick", function()
        self.logFrame:Hide()
    end)
    
    -- Кнопка очистки лога
    local clearButton = CreateFrame("Button", nil, self.logFrame, "UIPanelButtonTemplate")
    clearButton:SetPoint("BOTTOM", 0, 45)
    clearButton:SetSize(100, 25)
    clearButton:SetText(EW_L("LOG_CLEAR"))
    clearButton:SetScript("OnClick", function()
        EmoteWheelDB.log = {}
        self:UpdateLogDisplay()
    end)
end

function EmoteWheel:UpdateLogDisplay()
    if not self.logContent then return end
    
    local logText = EW_L("LOG_TITLE") .. ":\n\n"
    if EmoteWheelDB.log and #EmoteWheelDB.log > 0 then
        for i, entry in ipairs(EmoteWheelDB.log) do
            logText = logText .. entry .. "\n"
        end
    else
        logText = logText .. EW_L("LOG_EMPTY")
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