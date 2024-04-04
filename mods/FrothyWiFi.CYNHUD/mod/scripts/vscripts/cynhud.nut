global function CynHud_Init

#if CLIENT
void function CynHud_Init() {
	thread CynHud_DoMessage()
}

var hudMessage = null
string mapName = ""
string convarSetting = GetConVarString("ch_hud_message")

void function CynHud_ConfigureRui(rui hudMessageRui) {
  	RuiSetInt(hudMessageRui, "maxLines", 1)
  	RuiSetInt(hudMessageRui, "lineNum", 1)
  	RuiSetFloat2(hudMessageRui, "msgPos", <0.825, 0.92, 0.0>)
  	RuiSetString(hudMessageRui, "msgText", convarSetting)
  	RuiSetFloat(hudMessageRui, "msgFontSize", 25.0)
  	RuiSetFloat(hudMessageRui, "msgAlpha", 0.5)
  	RuiSetFloat(hudMessageRui, "thicken", 0.0)
 	RuiSetFloat3(hudMessageRui, "msgColor", <1.0, 1.0, 1.0>)	
}

void function CynHud_DoMessage() {
	WaitFrame()

	mapName = GetMapName()
  	hudMessage = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)

	CynHud_ConfigureRui(hudMessage)
	
	while (mapName == GetMapName()) {
		WaitFrame()
		if (GetConVarString("ch_hud_message") != convarSetting) {
			RuiDestroy(hudMessage)
			CynHud_DoMessage()
		}
	}
	RuiDestroy(hudMessage)
}
#endif