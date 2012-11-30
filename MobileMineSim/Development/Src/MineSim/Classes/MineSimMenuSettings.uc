/**
 */

class MineSimMenuSettings extends MobileMenuScene;

enum EMineSimSettingsObjects
{
	MSSO_Background,
	MSSO_TitleText,
	MSSO_CloseButton,
	MSSO_WaterLeakButton,
	MSSO_ScopeCircleButton,
	MSSO_SettingsButton3,
	MSSO_SettingsButton4,
	MSSO_SettingsButton5
};

var	bool	bWaterLeakHidden;
var	string	WaterLeakCaptions[2];

var	bool	bScopeCircleHidden;
var	string	ScopeCircleCaptions[2];

event InitMenuScene(MobilePlayerInput PlayerInput, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
	local int i;
	
	Width = ScreenWidth;
	Height = ScreenHeight;

	for ( i = 0; i < MenuObjects.Length; i++ )
	{
		MenuObjects[i].Left = MenuObjects[i].Left * ScreenWidth;
		MenuObjects[i].Top = MenuObjects[i].Top * ScreenHeight;
		MenuObjects[i].Width = MenuObjects[i].Width * ScreenWidth;
		MenuObjects[i].Height = MenuObjects[i].Height * ScreenHeight;
	}

	// Always make sure the Close Button is Square
	if ( ScreenWidth > ScreenHeight )
	{
		MenuObjects[MSSO_CloseButton].Width = MenuObjects[MSSO_CloseButton].Height;
	}
	else
	{
		MenuObjects[MSSO_CloseButton].Height = MenuObjects[MSSO_CloseButton].Width;
	}

	Super.InitMenuScene(PlayerInput, ScreenWidth, ScreenHeight, bIsFirstInitialization);
	
	bWaterLeakHidden = MineSimGame(InputOwner.Outer.WorldInfo.Game).bWaterLeakHidden;
	MobileMenuButton(MenuObjects[MSSO_WaterLeakButton]).Caption = WaterLeakCaptions[int(bWaterLeakHidden)];

	bScopeCircleHidden = MineSimHUD(InputOwner.Outer.myHUD).bShowScope;
	MobileMenuButton(MenuObjects[MSSO_ScopeCircleButton]).Caption = ScopeCircleCaptions[int(bScopeCircleHidden)];
}

/**
 * Override this function to change the font used by this Scene
 *
 * @return the Font to use for this scene
 */
function Font GetSceneFont()
{
	return default.SceneCaptionFont;
}

event OnTouch(MobileMenuObject Sender,float TouchX, float TouchY, bool bCancel)
{
	if ( Sender == none )
	{
		return;
	}

	if ( bCancel == true )
	{
		return;
	}

	if ( Sender.Tag == "CLOSE" )
	{
		InputOwner.CloseMenuScene(self);
	}
	else if ( Sender.Tag == "WATERLEAK" )
	{
		bWaterLeakHidden = !bWaterLeakHidden;
		MineSimGame(InputOwner.Outer.WorldInfo.Game).bWaterLeakHidden = bWaterLeakHidden;
		SetLeakHidden(bWaterLeakHidden);
		MobileMenuButton(MenuObjects[MSSO_WaterLeakButton]).Caption = WaterLeakCaptions[int(bWaterLeakHidden)];
	}
	else if ( Sender.Tag == "SCOPECIRCLE" )
	{
		bScopeCircleHidden = !bScopeCircleHidden;
		MineSimHUD(InputOwner.Outer.myHUD).bShowScope = bScopeCircleHidden;
		MobileMenuButton(MenuObjects[MSSO_ScopeCircleButton]).Caption = ScopeCircleCaptions[int(bScopeCircleHidden)];
	}
	else if ( Sender.Tag == "RESET" )
	{
		InputOwner.Outer.WorldInfo.Game.ResetLevel();
		InputOwner.Outer.WorldInfo.Game.StartMatch();
		InputOwner.CloseMenuScene(self);
	}
}

function SetLeakHidden(bool bHidden)
{
	local int i;
	local array<SequenceObject> AllSeqEvents;		
	local Sequence GameSeq;
	local Emitter Emitter;

	GameSeq = InputOwner.Outer.WorldInfo.GetGameSequence();

	if ( GameSeq != none )
	{
		// find any Level Loaded events that exist
		GameSeq.FindSeqObjectsByClass(class'SeqEvent_SequenceActivated', true, AllSeqEvents);

		for ( i = 0; i < AllSeqEvents.Length; i++ )
		{
			if ( (bHidden && SeqEvent_SequenceActivated(AllSeqEvents[i]).InputLabel == "InstrHideLeak") ||
				 (!bHidden && SeqEvent_SequenceActivated(AllSeqEvents[i]).InputLabel == "InstrShowLeak") )
			{
				SeqEvent_SequenceActivated(AllSeqEvents[i]).CheckActivate(InputOwner.Outer, none);
				break;
			}
		}
	}

	foreach InputOwner.Outer.WorldInfo.AllActors(class'Emitter', Emitter)
	{
		if ( Emitter.Tag == 'WaterLeak' )
		{
			if ( bHidden )
			{
				Emitter.ParticleSystemComponent.DeactivateSystem();
			}
			else
			{
				Emitter.ParticleSystemComponent.ActivateSystem();
			}
			
			Emitter.bCurrentlyActive = !bHidden;
		}
	}
}

defaultproperties
{
	SceneCaptionFont=MultiFont'CastleFonts.Positec'
	Left=0.0
	Top=0.0
	Width=1.0
	Height=1.0
	bRelativeLeft=true
	bRelativeWidth=true
	
	WaterLeakCaptions(0)="Water Drip Animation OFF"
	WaterLeakCaptions(1)="Water Drip Animation ON"

	ScopeCircleCaptions(0)="Toggle Viewer OFF"
	ScopeCircleCaptions(1)="Toggle Viewer ON"
	
	Begin Object Class=MobileMenuImage Name=Background
		Tag="Background"
		Left=0.0
		Top=0.0
		Width=1.0
		Height=1.0
		Image=Texture2D'MineSimUI.menus.Background'
		ImageDrawStyle=IDS_Stretched
		ImageUVs=(bCustomCoords=true,U=0,V=0,UL=512,VL=256)
	End Object
	MenuObjects(MSSO_Background)=Background

	Begin Object Class=MobileMenuLabel Name=TitleLabel
		Caption="Settings"
		Left=0.45
		Top=0.11
		Width=1.0
		Height=0.15
		TextFont=MultiFont'CastleFonts.Positec'
		TextColor=(R=255,G=255,B=255,A=255)
		TextXScale=1.5
		TextYScale=1.5
		bAutoSize=false
	End Object
	MenuObjects(MSSO_TitleText)=TitleLabel

	Begin Object Class=MobileMenuButton Name=CloseButton
		Tag="CLOSE"
		Left=0.73
		Top=0.11
		Width=0.03125
		Height=0.05556
		Images(0)=Texture2D'MineSimUI.menus.CloseButton'
		Images(1)=Texture2D'MineSimUI.menus.CloseButtonDown'
	End Object
	MenuObjects(MSSO_CloseButton)=CloseButton

	Begin Object Class=MobileMenuButton Name=WaterLeakButton
		Tag="WATERLEAK"
		Caption="Water Drip Animation OFF"
		Left=0.225
		Top=0.30
		Width=0.55
		Height=0.08
		Images(0)=Texture2D'MineSimUI.menus.Button'
		Images(1)=Texture2D'MineSimUI.menus.ButtonDown'
		ImagesUVs(0)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
      		ImagesUVs(1)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
	End Object
	MenuObjects(MSSO_WaterLeakButton)=WaterLeakButton

	Begin Object Class=MobileMenuButton Name=ScopeCircleButton
		Tag="SCOPECIRCLE"
		Caption="Toggle Viewer OFF"
		Left=0.225
		Top=0.40
		Width=0.55
		Height=0.08
		Images(0)=Texture2D'MineSimUI.menus.Button'
		Images(1)=Texture2D'MineSimUI.menus.ButtonDown'
		ImagesUVs(0)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
      		ImagesUVs(1)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
	End Object
	MenuObjects(MSSO_ScopeCircleButton)=ScopeCircleButton

	Begin Object Class=MobileMenuButton Name=InDev
		Caption="Instructor Mode (in development)"
		Left=0.225
		Top=0.50
		Width=0.55
		Height=0.08
		Images(0)=Texture2D'MineSimUI.menus.Button'
		Images(1)=Texture2D'MineSimUI.menus.Button'
		ImagesUVs(0)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
      		ImagesUVs(1)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
	End Object	
	MenuObjects(MSSO_SettingsButton3)=InDev
	
	Begin Object Class=MobileMenuButton Name=InDev2
		Caption="Multi-User mode (in development)"
		Left=0.225
		Top=0.60
		Width=0.55
		Height=0.08
		Images(0)=Texture2D'MineSimUI.menus.Button'
		Images(1)=Texture2D'MineSimUI.menus.Button'
		ImagesUVs(0)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
      		ImagesUVs(1)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
	End Object
	MenuObjects(MSSO_SettingsButton4)=InDev2
	
	Begin Object Class=MobileMenuButton Name=ResetButton
		Tag="RESET"
		Caption="Reset Scenario"
		Left=0.225
		Top=0.85
		Width=0.55
		Height=0.08
		Images(0)=Texture2D'MineSimUI.menus.Button'
		Images(1)=Texture2D'MineSimUI.menus.ButtonDown'
		ImagesUVs(0)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
      	ImagesUVs(1)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
	End Object
	MenuObjects(MSSO_SettingsButton5)=ResetButton

	UITouchSound=SoundCue'A_Gameplay.Gameplay.MessageBeepCue'
	UIUnTouchSound=SoundCue'A_Gameplay.Gameplay.MessageBeepCue'
}
