global function CynHud_Init

#if CLIENT
void function CynHud_Init() {
	thread CynHud_DoMessage()
}

var hudMessage = null
string mapName = ""

void function CynHud_DoMessage() {
	WaitFrame()

	mapName = GetMapName()
  	hudMessage = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)

  	RuiSetInt(hudMessage, "maxLines", 1)
  	RuiSetInt(hudMessage, "lineNum", 1)
  	RuiSetFloat2(hudMessage, "msgPos", <0.825, 0.92, 0.0>)
  	RuiSetString(hudMessage, "msgText", GetConVarString("ch_hud_message"))
  	RuiSetFloat(hudMessage, "msgFontSize", 25.0)
  	RuiSetFloat(hudMessage, "msgAlpha", 0.5)
  	RuiSetFloat(hudMessage, "thicken", 0.0)
 	RuiSetFloat3(hudMessage, "msgColor", <1.0, 1.0, 1.0>)
	
	while (mapName == GetMapName()) {
		WaitFrame()
	}
	RuiDestroy(hudMessage)
}
#endif