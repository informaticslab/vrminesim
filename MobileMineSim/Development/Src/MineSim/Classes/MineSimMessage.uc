/**
 */
 
class MineSimMessage extends MobileMenuScene;

enum EMineSimMessageObjects
{
	MSMO_Background,
	MSMO_TitleText,
	MSMO_CloseButton,
	MSMO_MessageText,
	MSMO_OKButton
};

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
		MenuObjects[MSMO_CloseButton].Width = MenuObjects[MSMO_CloseButton].Height;
	}
	else
	{
		MenuObjects[MSMO_CloseButton].Height = MenuObjects[MSMO_CloseButton].Width;
	}

	Super.InitMenuScene(PlayerInput, ScreenWidth, ScreenHeight, bIsFirstInitialization);
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
	else if ( Sender.Tag == "MESSAGE_OK" )
	{
		`log("MESSAGE_OK");

		if ( MobileMenuButton(Sender).Caption == "Reset Scenario" )
		{
			InputOwner.Outer.WorldInfo.Game.ResetLevel();
			InputOwner.Outer.WorldInfo.Game.StartMatch();
		}
	
		InputOwner.CloseMenuScene(self);
	}
}

function SetStrings(string Message, string Caption)
{
	local int i;

	for ( i = 0; i < MenuObjects.Length; i++ )
	{
		if (MenuObjects[i].Tag == "MESSAGE_TEXT")
		{
			MobileMenuLabel(MenuObjects[i]).Caption =  Message;
		}
		else if (MenuObjects[i].Tag == "MESSAGE_OK")
		{
			MobileMenuButton(MenuObjects[i]).Caption =  Caption;
		}
	}

}

defaultproperties
{
	SceneCaptionFont=MultiFont'CastleFonts.Positec'
	Left=0.0
	Top=0.0
	Width=1.0
	Height=0.8
	bRelativeLeft=true
	bRelativeWidth=true

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
	MenuObjects(MSMO_Background)=Background

	Begin Object Class=MobileMenuLabel Name=TitleLabel
		Caption="Message"
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
	MenuObjects(MSMO_TitleText)=TitleLabel
	
	Begin Object Class=MobileMenuButton Name=CloseButton
		Tag="CLOSE"
		Left=0.73
		Top=0.11
		Width=0.03125
		Height=0.05556
		Images(0)=Texture2D'MineSimUI.menus.CloseButton'
		Images(1)=Texture2D'MineSimUI.menus.CloseButtonDown'
	End Object
	MenuObjects(MSMO_CloseButton)=CloseButton

	Begin Object Class=MobileMenuLabel Name=MessageLabel
		Tag="MESSAGE_TEXT"
		Caption=""
		Left=0.225
		Top=0.30
		Width=0.55
		Height=0.28
		TextFont=MultiFont'CastleFonts.Positec'
		TextColor=(R=0,G=0,B=0,A=255)
		TextXScale=1.0
		TextYScale=1.0
		bAutoSize=false
	End Object
	MenuObjects(MSMO_MessageText)=MessageLabel

	Begin Object Class=MobileMenuButton Name=MessageOKButton
		Tag="MESSAGE_OK"
		Caption="OK"
		Left=0.225
		Top=0.75
		Width=0.55
		Height=0.08
		Images(0)=Texture2D'MineSimUI.menus.Button'
		Images(1)=Texture2D'MineSimUI.menus.ButtonDown'
		ImagesUVs(0)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
      	ImagesUVs(1)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
	End Object
	MenuObjects(MSMO_OKButton)=MessageOKButton

	UITouchSound=SoundCue'A_Gameplay.Gameplay.MessageBeepCue'
	UIUnTouchSound=SoundCue'A_Gameplay.Gameplay.MessageBeepCue'
}
