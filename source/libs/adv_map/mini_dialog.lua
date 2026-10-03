---@alias MiniDialogSpeakerType
---|`SPEAKER_TYPE_HERO`
---|`SPEAKER_TYPE_CREATURE`
SPEAKER_TYPE_HERO = 1
SPEAKER_TYPE_CREATURE = 2

MINI_DIALOG_UNDEFINED_ANSWER = 3

---@class MiniDialogSpeakerModel
---@field type MiniDialogSpeakerType
---@field color string

---@class MiniDialogStep
---@field speakers NumberOrString [] Список возможных персонажей реплики
---@field labels string[] Список вариантов реплики по меткам

---@class MiniDialogModel
---@field path string Основной путь диалога
---@field steps_count number Число реплик
---@field current_step number Текущая реплика
---@field steps MiniDialogStep[] Данные о репликах
---@field speakers_data table<string|number, MiniDialogSpeakerModel> Данные о персонажах
---@field selected_answer number? Выбранный ответ в текущей реплике
---@field label string? Активная метка
---@field priority_speaker string|number|nil? 

---@class _MiniDialog
---@field model MiniDialogModel
---@field Start function(label?: string|nil, priority_speaker: string|number)

---@alias MiniDialog _MiniDialog | DefaultClassBody

---@param model MiniDialogModel
---@return MiniDialog
function MiniDialog(model)
    ---@type MiniDialog
    local _mini_dialog = Class {
        typename = "MiniDialog" 
    }

    _mini_dialog.model = model

    ---@param player PlayerID
    ---@param selected_answer number
    ---@private
    ---@diagnostic disable-next-line
    function _mini_dialog:Callback(player, selected_answer)
        self.model.selected_answer = selected_answer
    end

    ---@private
    ---@diagnostic disable-next-line
    function _mini_dialog:ShowCurrentStep()
        local answers = {"/Text/next.txt", "/Text/back.txt"}
        self.model.selected_answer = MINI_DIALOG_UNDEFINED_ANSWER

        if self.model.current_step == self.model.steps_count then
            answers = {"/Text/finish.txt", "/Text/back.txt"}
        elseif self.model.current_step == 1 then
            answers[2] = nil
        end

        ---@type MiniDialogStep
        local step_data = self.model.steps[self.model.current_step]
        local text_path
        if self.model.label ~= "main" then
            if contains(step_data.labels, self.model.label) then
                text_path = self.model.path.."/"..(self.model.current_step - 1).."_"..self.model.label..".txt"
            else
                text_path = self.model.path.."/"..(self.model.current_step - 1).."_main.txt"
            end
        else
            text_path = self.model.path.."/"..(self.model.current_step - 1).."_main.txt"
        end

        local speaker
        if self.model.priority_speaker then
            speaker = Iterator(step_data.speakers).First(
              function (item)
                  if item == %self.model.priority_speaker then
                      return item
                  end
                  return nil
              end)
        else
            if length(step_data.speakers) == 1 then
                speaker = step_data.speakers[1]
            else
                speaker = Random.FromTable(step_data.speakers)
            end
        end

        ---@type MiniDialogSpeakerModel
        local speaker_data = self.model.speakers_data[speaker]

        local icon 
        local name
        if speaker_data.type == SPEAKER_TYPE_HERO then
            ---@type Hero
            local hero_data = HEROES_DATA[speaker]
            icon = hero_data.icon
            name = hero_data.name
        else
            ---@type Creature
            local creature_data = CREATURES_DATA[speaker]
            icon = creature_data.icon
            name = creature_data.name
        end

        if string.spread(icon)[1] ~= '/' then
            icon = '/'..icon
        end

        local color_info = rtext("<color="..speaker_data.color..">")
        local text = { text_path; color_info = color_info, speaker_name = name }

        ---@diagnostic disable-next-line
        TalkBoxForPlayers(GetPlayerFilter(PLAYER_1), icon.."#xpointer(/Texture)", nil, text, nil, 'Callback', 1, nil, 0, 0, answers[1], answers[2], nil, nil, nil)
        
        while self.model.selected_answer == MINI_DIALOG_UNDEFINED_ANSWER do
            sleep()
        end

        if self.model.selected_answer < 1 then
            return
        else
            if self.model.selected_answer == 1 then
                if self.model.current_step == self.model.steps_count then
                    return
                else
                    self.model.current_step = self.model.current_step + 1
                end
            else
                self.model.current_step = self.model.current_step - 1
            end
        end

        self:ShowCurrentStep()
    end

    ---@param label string|nil
    ---@param priority_speaker string|number|nil
    function _mini_dialog:Start(label, priority_speaker)
        if label then
            self.model.label = label
        end
        self.model.priority_speaker = priority_speaker

        self:ShowCurrentStep()
    end

    return _mini_dialog
end

__end_import()