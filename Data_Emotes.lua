--[[
    База данных эмоций для WoW 3.3.5a с правильными командами
]]

EmoteWheelData = {
    groups = {
        [1] = {
            name = "Основные",
            emotes = {
                {command = "cheer", name = "Радоваться"},
                {command = "dance", name = "Танец"},
                {command = "wave", name = "Привет"},
                {command = "bye", name = "Пока"},
                {command = "thank", name = "Благодарность"},
                {command = "bow", name = "Поклон"}
            }
        },
        [2] = {
            name = "Боевые", 
            emotes = {
                {command = "threaten", name = "Угроза"},
                {command = "laugh", name = "Смех"},
                {command = "rude", name = "Насмешка"},
                {command = "victory", name = "Победа"},
                {command = "flex", name = "Мускулы"},
                {command = "roar", name = "Рев"}
            }
        },
        [3] = {
            name = "Социальные",
            emotes = {
                {command = "applaud", name = "Аплодисменты"},
                {command = "hug", name = "Обнять"},
                {command = "kiss", name = "Поцелуй"},
                {command = "salute", name = "Приветствие"},
                {command = "congratulate", name = "Поздравление"},
                {command = "comfort", name = "Утешение"}
            }
        },
        [4] = {
            name = "Реакции",
            emotes = {
                {command = "cry", name = "Плакать"},
                {command = "no", name = "Нет"},
                {command = "nod", name = "Да"},
                {command = "shy", name = "Смущение"},
                {command = "surprised", name = "Удивление"},
                {command = "whistle", name = "Свист"}
            }
        }
        -- Можно добавить больше групп...
    }
}