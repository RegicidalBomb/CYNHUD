// TODO: Fix the message position logic
global function CynHud_Init;

#if CLIENT
void function CynHud_Init() {
	thread CynHud_DoMessage();
}

var rui = null;
string mapName = "";
string message = "";
// string messagePos = "";

void function CynHud_ConfigureRui() {
  	RuiSetInt(rui, "maxLines", 1);
  	RuiSetInt(rui, "lineNum", 1);
	// if (messagePos == "Bottom-right") {
  	// 	RuiSetFloat2(rui, "msgPos", <0.825, 0.92, 0.0>);
	// } else if (messagePos == "Middle-right") {
  	// 	RuiSetFloat2(rui, "msgPos", <0.825, 0.46, 0.0>);
	// } else if (messagePos == "Top-right") {
	// 	RuiSetFloat2(rui, "msgPos", <0.825, -0.92, 0.0>);
	// }
	RuiSetFloat2(rui, "msgPos", <0.825, 0.92, 0.0>);
  	RuiSetString(rui, "msgText", message);
  	RuiSetFloat(rui, "msgFontSize", 25.0);
  	RuiSetFloat(rui, "msgAlpha", 0.5);
  	RuiSetFloat(rui, "thicken", 0.0);
 	RuiSetFloat3(rui, "msgColor", <1.0, 1.0, 1.0>);
}

void function CynHud_DoMessage() {
	WaitFrame();

	mapName = GetMapName();
  	rui = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0);
	message = GetConVarString("ch_hud_message");
	// messagePos = GetConVarString("ch_hud_message_pos");

	CynHud_ConfigureRui();
	
	while (mapName == GetMapName()) {
		WaitFrame();
		if (GetConVarString("ch_hud_message") != message) {
			RuiDestroy(rui);
			CynHud_DoMessage();
		}
		// if (GetConVarString("ch_hud_message_pos") != messagePos) {
		// 	RuiDestroy(rui);
		// 	CynHud_DoMessage();
		// }
	}
	RuiDestroy(rui);
}
#endif