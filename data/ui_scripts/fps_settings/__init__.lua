local SIZES = {
  { option = "Small", value = 0 },
  { option = "Medium", value = 1 },
  { option = "Large", value = 2 },
}

local COLORS = {
  { option = "Auto", value = 0 },
  { option = "White", value = 1 },
  { option = "Yellow", value = 2 },
  { option = "Green", value = 3 },
  { option = "Orange", value = 4 },
  { option = "Red", value = 5 },
  { option = "Cyan", value = 6 },
}

local SWITCH = {
  { option = "MENU_DISABLED", value = 0 },
  { option = "MENU_ENABLED", value = 1 },
}

BoiiiFpsSettings = {
  {
    dvar = "com_drawFPS_PC",
    name = "Show FPS Counter",
    description = "Display frames per second on screen.",
    options = SWITCH,
  },
  { dvar = "boiii_fpsSize", name = "FPS Size", description = "Size of the FPS counter.", options = SIZES },
  {
    dvar = "boiii_fpsColor",
    name = "FPS Color",
    description = "Color of the FPS counter. Auto is green at 60+ FPS, orange at 30-59 and red below 30.",
    options = COLORS,
  },
  {
    dvar = "boiii_drawPing",
    name = "Show Ping",
    description = "Show your ping next to the FPS counter while connected to a server.",
    options = SWITCH,
  },
  { dvar = "boiii_pingSize", name = "Ping Size", description = "Size of the ping display.", options = SIZES },
  {
    dvar = "boiii_pingColor",
    name = "Ping Color",
    description = "Color of the ping display. Auto is green under 60 ms, orange up to 120 ms and red above.",
    options = COLORS,
  },
}

function BoiiiFpsSettings.CreateDvarSettings(controller, prefix)
  local items = {}
  for _, setting in ipairs(BoiiiFpsSettings) do
    local current = Engine.DvarInt(nil, setting.dvar)
    local options = {}
    for _, option in ipairs(setting.options) do
      table.insert(options, { option = option.option, value = option.value, default = option.value == current })
    end
    table.insert(
      items,
      CoD.OptionsUtility.CreateDvarSettings(
        controller,
        setting.name,
        setting.description,
        prefix .. setting.dvar,
        setting.dvar,
        options,
        nil,
        function(_, optionModel, _, dvarName)
          UpdateInfoModels(optionModel)
          if Engine.DvarInt(nil, dvarName) ~= optionModel.value then
            Engine.SetDvar(dvarName, optionModel.value)
          end
        end
      )
    )
  end
  return items
end
