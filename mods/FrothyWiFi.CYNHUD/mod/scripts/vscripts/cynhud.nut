global function CynHud_Init;

#if CLIENT
var rui = null;
string mapName = "";
string message = "";
string messagePos = "";
bool shouldReload = false;
bool hasShownWelcomeTextAlready = false;

ClClient_MessageStruct function CynHud_CommandFilter(ClClient_MessageStruct message) {
	if (message.message == "$ch.help") {
		message.shouldBlock = true;
		Chat_GameWriteLine("\x1b[33m--== CYNHUD commands ==--\x1b[0m");
		Chat_GameWriteLine("All CYNHUD commands \x1b[112mmust\x1b[0m be prefaced with \x1b[33m\"$ch.\"\x1b[0m.");
		Chat_GameWriteLine("\x1b[33m$ch.help\x1b[0m - Show available commands.");
		Chat_GameWriteLine("\x1b[33m$ch.reload\x1b[0m - Reload the HUD message manually.")
		Chat_GameWriteLine("\x1b[33m$ch.uid\x1b[0m - Show your user ID. CYNHUD also uses this to greet you.");
	} else if (message.message == "$ch.reload") {
		message.shouldBlock = true;
		shouldReload = true;
	} else if (message.message == "$ch.uid") {
		message.shouldBlock = true;
		CynHud_WriteChatMessage("You are Pilot \x1b[111m" + NSGetLocalPlayerUID() + "\x1b[0m.");
	}
	return message;
}

void function CynHud_ConfigureRui() {
  	RuiSetInt(rui, "maxLines", 1);
  	RuiSetInt(rui, "lineNum", 1);
	if (messagePos == "Bottom") {
  		RuiSetFloat2(rui, "msgPos", <0.825, 0.92, 0.0>);
	} else if (messagePos == "Middle") {
  		RuiSetFloat2(rui, "msgPos", <0.825, 0.46, 0.0>);
	} else if (messagePos == "Top") {
		RuiSetFloat2(rui, "msgPos", <0.825, 0.0, 0.0>);
	} else {
		RuiSetFloat2(rui, "msgPos", <0.825, 0.46, 0.0>);
	}
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
	messagePos = GetConVarString("ch_hud_message_pos");

	WaitFrame();
	
	CynHud_ConfigureRui();
	
	while (mapName == GetMapName()) {
		WaitFrame();
		if (!hasShownWelcomeTextAlready && mapName != "mp_lobby") {
			CynHud_WriteChatMessage("Welcome back, \x1b[111m" + NSGetLocalPlayerUID() + "\x1b[0m. Run $ch.help for a list of commands.");
			hasShownWelcomeTextAlready = true;
		}
		if (shouldReload) {
			shouldReload = false;
			RuiDestroy(rui);
			CynHud_WriteChatMessage("Manual reload request recieved; reloading HUD message.");
			CynHud_DoMessage();
		}
		if (GetConVarString("ch_hud_message") != message) {
			RuiDestroy(rui);
			CynHud_WriteChatMessage("Message changed; reloading HUD message.");
			CynHud_DoMessage();
		}
		if (GetConVarString("ch_hud_message_pos") != messagePos) {
			RuiDestroy(rui);
			CynHud_WriteChatMessage("Message position changed; reloading HUD message.");
			CynHud_DoMessage();
		}
	}
	RuiDestroy(rui);
	hasShownWelcomeTextAlready = false;
}

void function CynHud_WriteChatMessage(string message) {
	Chat_GameWriteLine("\x1b[33mCYNHUD:\x1b[0m " + message);
}

void function CynHud_Init() {
	AddCallback_OnReceivedSayTextMessage(CynHud_CommandFilter);
	thread CynHud_DoMessage();
}
#endif