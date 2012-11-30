/**
 */
 
class MineSimQuestion extends MobileMenuScene;

enum EMineSimQuestionObjects
{
	MSQO_Background,
	MSQO_TitleText,
	MSQO_CloseButton,
	MSQO_QuestionText,
	MSQO_ResponseAButton,
	MSQO_ResponseBButton,
	MSQO_ResponseCButton
};

var string ResponseA;
var string ResponseB;
var string ResponseC;

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
		MenuObjects[MSQO_CloseButton].Width = MenuObjects[MSQO_CloseButton].Height;
	}
	else
	{
		MenuObjects[MSQO_CloseButton].Height = MenuObjects[MSQO_CloseButton].Width;
	}

	Super.InitMenuScene(PlayerInput, ScreenWidth, ScreenHeight, bIsFirstInitialization);

	// TODO: if we want more or less than 3 answers, add more Answer strings to MineSimSeqAct_PopQuestion. 
	//		Then check here until an Answer string is empty, to see how many buttons to place. 
	//		Adjust button placement accordingly. -DBW
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
//   InputLinks(0)=(LinkDesc="START",LinkedOp=SeqEvent_SequenceActivated'SeqEvent_SequenceActivated_0',DrawY=667)

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
	else if ( Sender.Tag == "ANSWER_A" )
	{
		ButtonActivatesSequence(ResponseA);
		InputOwner.CloseMenuScene(self);
	}
	else if ( Sender.Tag == "ANSWER_B" )
	{
		ButtonActivatesSequence(ResponseB);
		InputOwner.CloseMenuScene(self);
	}
	else if ( Sender.Tag == "ANSWER_C" )
	{
		ButtonActivatesSequence(ResponseC);
		InputOwner.CloseMenuScene(self);
	}
}

function SetStrings(string Question, string AnswerA, string AnswerB, string AnswerC, string IDResponseA, string IDResponseB, string IDResponseC)
{
	local int i;
	
	ResponseA = IDResponseA;
	ResponseB = IDResponseB;
	ResponseC = IDResponseC;

	for ( i = 0; i < MenuObjects.Length; i++ )
	{
		if (MenuObjects[i].Tag == "QUESTION_TEXT")
		{
			MobileMenuLabel(MenuObjects[i]).Caption =  Question;
		}
		if (MenuObjects[i].Tag == "ANSWER_A")
		{
			MobileMenuButton(MenuObjects[i]).Caption =  AnswerA;
		}
		if (MenuObjects[i].Tag == "ANSWER_B")
		{
			MobileMenuButton(MenuObjects[i]).Caption =  AnswerB;
		}
		if (MenuObjects[i].Tag == "ANSWER_C")
		{
			MobileMenuButton(MenuObjects[i]).Caption =  AnswerC;
		}
	}

}

function ButtonActivatesSequence(string ResponseID)
{
	local int i;
	local array<SequenceObject> AllSeqEvents;		
	local Sequence GameSeq;
	
	GameSeq = InputOwner.Outer.WorldInfo.GetGameSequence();
	
	if (GameSeq != None)
	{
		// find any Level Loaded events that exist
		GameSeq.FindSeqObjectsByClass(class'SeqEvent_SequenceActivated', true, AllSeqEvents);

		for (i = 0; i < AllSeqEvents.Length; i++)
		{
			if (ResponseID == SeqEvent_SequenceActivated(AllSeqEvents[i]).InputLabel)
			{
				SeqEvent_SequenceActivated(AllSeqEvents[i]).CheckActivate(InputOwner.Outer, none);
			}
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
	MenuObjects(MSQO_Background)=Background

	Begin Object Class=MobileMenuLabel Name=TitleLabel
		Caption="Question"
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
	MenuObjects(MSQO_TitleText)=TitleLabel
	
	Begin Object Class=MobileMenuButton Name=CloseButton
		Tag="CLOSE"
		Left=0.73
		Top=0.11
		Width=0.03125
		Height=0.05556
		Images(0)=Texture2D'MineSimUI.menus.CloseButton'
		Images(1)=Texture2D'MineSimUI.menus.CloseButtonDown'
	End Object
	MenuObjects(MSQO_CloseButton)=CloseButton

	Begin Object Class=MobileMenuLabel Name=QuestionLabel
		Tag="QUESTION_TEXT"
		Caption="Question Default"
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
	MenuObjects(MSQO_QuestionText)=QuestionLabel

	Begin Object Class=MobileMenuButton Name=AnswerAButton
		Tag="ANSWER_A"
		Caption="A: Default Answer"
		Left=0.225
		Top=0.6
		Width=0.55
		Height=0.08
		Images(0)=Texture2D'MineSimUI.menus.Button'
		Images(1)=Texture2D'MineSimUI.menus.ButtonDown'
		ImagesUVs(0)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
      	ImagesUVs(1)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
	End Object
	MenuObjects(MSQO_ResponseAButton)=AnswerAButton

	Begin Object Class=MobileMenuButton Name=AnswerBButton
		Tag="ANSWER_B"
		Caption="B: Default Answer"
		Left=0.225
		Top=0.7
		Width=0.55
		Height=0.08
		Images(0)=Texture2D'MineSimUI.menus.Button'
		Images(1)=Texture2D'MineSimUI.menus.ButtonDown'
		ImagesUVs(0)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
      	ImagesUVs(1)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
	End Object
	MenuObjects(MSQO_ResponseBButton)=AnswerBButton

	Begin Object Class=MobileMenuButton Name=AnswerCButton
		Tag="ANSWER_C"
		Caption="C: Default Answer"
		Left=0.225
		Top=0.8
		Width=0.55
		Height=0.08
		Images(0)=Texture2D'MineSimUI.menus.Button'
		Images(1)=Texture2D'MineSimUI.menus.ButtonDown'
		ImagesUVs(0)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
      	ImagesUVs(1)=(bCustomCoords=true,U=0,V=0,UL=256,VL=32)
	End Object
	MenuObjects(MSQO_ResponseCButton)=AnswerCButton

	UITouchSound=SoundCue'A_Gameplay.Gameplay.MessageBeepCue'
	UIUnTouchSound=SoundCue'A_Gameplay.Gameplay.MessageBeepCue'
}
