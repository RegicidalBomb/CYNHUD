global function CynHud_AddModSettings

#if UI
void function CynHud_AddModSettings() {
    AddModTitle("CYNHUD")
    AddModCategory("Configuration")
    AddConVarSetting("ch_hud_message", "HUD Message")
}
#endif