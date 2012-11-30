/**
 */
 
class MineSimGame extends SimpleGame;

/** Set to true to allow attract mode */
var config bool bAllowAttractMode;

var	bool	bWaterLeakHidden;

event OnEngineHasLoaded()
{
}

/**
 * Don't allow dying in CastleGame!
 */
function bool PreventDeath(Pawn KilledPawn, Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	return true;
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	// We'll only force CastleGame game type for maps that we know were build for Epic Citadel (EpicCitadel).
	// Note that ignore any possible prefix on the map file name so that PIE and Play On still work with this.

	return super.SetGameType(MapName, Options, Portal);


	return class'UDKBase.SimpleGame';
}

defaultproperties
{
	PlayerControllerClass=class'MineSim.MineSimPC'
	HUDType=class'MineSim.MineSimHUD'
}

