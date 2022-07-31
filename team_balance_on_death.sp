#include <sourcemod>
#include <tf2>
#include <tf2_stocks>

public Plugin myinfo = {
    name = "Odd Player Insanity",
    author = "hammy3502",
    description = "Automatically swaps a player to the other team if the teams are unbalanced.",
    version = "1.0.0",
    url = "http://example.com"
};

void log(char[] message) {
    char[] res = "[Odd Player Insanity] ";
    StrCat(res, 256, message);
    PrintToServer(res);
}

public void OnPluginStart() {
    HookEvent("player_death", Event_PlayerDeath);
    log("Using Odd Player Insanity! :)");
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) {
    int victim = GetClientOfUserId(event.GetInt("userid"));
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    int assistant = GetClientOfUserId(event.GetInt("assister"));
    TFTeam largerTeam = GetLargerTeam();
    bool shouldChange = (attacker > 0 && attacker != victim) || (assistant > 0 && assistant != victim);
    if (largerTeam != TFTeam_Unassigned && shouldChange && largerTeam == TF2_GetClientTeam(victim)) {
        TF2_ChangeClientTeam(victim, getOpposite(largerTeam));
    }
}

TFTeam getOpposite(TFTeam team) {
    if (team == TFTeam_Red) {
        return TFTeam_Blue;
    }
    return TFTeam_Red;
}

TFTeam GetLargerTeam() {
    int redAmount = 0;
    int blueAmount = 0;
    for (int i = 1; i <= MaxClients; i++) {
        if (IsClientInGame(i)) {
            TFTeam team = TF2_GetClientTeam(i);
            if (team == TFTeam_Red) {
                redAmount++;
            } else if (team == TFTeam_Blue) {
                blueAmount++;
            }
        }
    }
    if (redAmount > blueAmount) {
        return TFTeam_Red;
    } else if (blueAmount > redAmount) {
        return TFTeam_Blue;
    }
    return TFTeam_Unassigned;
}

