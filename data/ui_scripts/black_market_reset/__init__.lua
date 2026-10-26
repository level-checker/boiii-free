if Engine.GetCurrentMap() ~= "core_frontend" or type(game.resetblackmarket) ~= "function" then
  return
end

if game.ismodrawfile("ui/uieditor/menus/BlackMarket.lua") then
  return
end

if __boiiiBlackMarketResetInstalled then
  return
end
__boiiiBlackMarketResetInstalled = true

require("ui.uieditor.menus.BlackMarket")

CoD.OverlayUtility.AddSystemOverlay("ResetBlackMarketConfirmation", {
  menuName = "SystemOverlay_Full",
  title = "RESET BLACK MARKET?",
  description = "Locks every item you've collected again. Cryptokeys are kept.",
  categoryType = CoD.OverlayUtility.OverlayTypes.GenericMessage,
  listDatasource = function()
    DataSources.ResetBlackMarketConfirmationList = DataSourceHelpers.ListSetup(
      "ResetBlackMarketConfirmationList",
      function()
        return {
          {
            models = { displayText = "RESET COLLECTION", disabled = false },
            properties = {
              action = function(_, _, controller, _, menu)
                if game.resetblackmarket(controller) then
                  GoBack(menu, controller)
                  CoD.OverlayUtility.ShowToast(
                    "BlackMarketEquipped",
                    "COLLECTION RESET",
                    "Every item locked",
                    "uie_t7_blackmarket_promo_cryptokeys"
                  )
                else
                  LuaUtils.UI_ShowErrorMessageDialog(
                    controller,
                    "Could not reset the Black Market. Turn on Local Currency in Stats Settings and try again."
                  )
                end
              end,
            },
          },
          {
            models = { displayText = "MENU_CANCEL_CAPS", disabled = false },
            properties = {
              -- Cancel is focused first, so a quick double press doesn't reset
              selectIndex = true,
              action = function(_, _, controller, _, menu)
                GoBack(menu, controller)
              end,
            },
          },
        }
      end,
      true
    )
    return "ResetBlackMarketConfirmationList"
  end,
})

-- A RESET tab after BUY, CONTRACTS and DUPLICATES. The list's items come from a function local to the Black Market
-- menu, so the tab is added after it's built, the same way the engine's list helper adds each item.
local tabs = DataSources.BlackMarketList
local originalPrepare = tabs.prepare
tabs.prepare = function(controller, list, filter)
  originalPrepare(controller, list, filter)
  local items = list[list.customDataSourceHelper]
  if not items then
    return
  end
  local root = ListHelper_GetListHelperModel(list, true)
  local index = #items + 1
  local oldModel = Engine.GetModel(root, index)
  if oldModel then
    Engine.UnsubscribeAndFreeModel(oldModel)
  end
  local model = Engine.CreateModel(root, index)
  ListHelper_CreateModelsFromTable(model, { displayText = "RESET", image = "uie_ui_codpoints_symbol_32x32" })
  table.insert(items, {
    model = model,
    properties = {
      action = function(_, _, actionController, _, menu)
        OpenSystemOverlay(menu, menu, actionController, "ResetBlackMarketConfirmation")
      end,
    },
  })
end
