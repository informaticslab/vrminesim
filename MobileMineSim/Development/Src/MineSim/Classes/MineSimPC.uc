/**
 * Based on CastlePC:
 *   Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class MineSimPC extends SimplePC;

/** Flashlight attached to user's head */
var MineSimFlashlight HelmetLight;

var MineSimQuestion PopUpQuestion;
var MineSimMessage PopUpMessage;

/**
 * Setup the in world indicator for tap to move and some other subsystems
 */
simulated function PostBeginPlay()
{
	HelmetLight = Spawn(class'MineSimFlashlight', self);
	HelmetLight.SetBase(self);
	HelmetLight.LightComponent.SetEnabled(true);
	HelmetLight.LightComponent.SetLightProperties(0.95);
	
	Super.PostBeginPlay();
}

/**
 * Called from PlayerMove, it's here that we adjust the viewport                                                                     
 */
function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot )
{
	local vector lightLoc;
	
	Super.ProcessViewRotation( DeltaTime, out_ViewRotation, DeltaRot );
	HelmetLight.SetRotation(out_ViewRotation);
	lightLoc = Pawn.Location;
	lightLoc.z += Pawn.Eyeheight;
	HelmetLight.SetLocation(lightLoc);

	HelmetLight.LightComponent.SetEnabled(true);
}

function UpdateRotation( float DeltaTime )
{
    local Rotator	ViewRotation, DeltaRot;

	if (MPI.aTilt.Y != 0.0)
	{   
		ViewRotation = Rotation;
		if (Pawn!=none)
		{
			Pawn.SetDesiredRotation(ViewRotation);
		}		
		
		ViewRotation.Pitch = MPI.aTilt.X - 15708;
		ViewRotation.Yaw = MPI.aTilt.Y;
		ViewRotation.Roll = MPI.aTilt.Z;

		SetRotation(ViewRotation);
	}
	else
	{
		ViewRotation = Rotation;
		if (Pawn!=none)
		{
			Pawn.SetDesiredRotation(ViewRotation);
		}
		
		// Calculate Delta to be applied on ViewRotation
		DeltaRot.Yaw   = PlayerInput.aTurn;
		DeltaRot.Pitch   = PlayerInput.aLookUp;

		ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
		SetRotation(ViewRotation);
		ViewRotation.Roll = Rotation.Roll;
	}

    if ( Pawn != None )
        Pawn.FaceRotation(ViewRotation, DeltaTime);
}  

/**
 * The main purpose of this function is to size and reset zones.  There's a lot of specific code in
 * here to reposition zones based on if it's an phone vs pad.
 */
function SetupZones()
{
	local MobileInputZone Zone;

	Super.SetupZones();
	
	if ( MPI != none && WorldInfo.GRI.GameClass != none ) 
	{
		// Find the button zone that shows the settings menu.
		Zone = MPI.FindZone("SettingsZone");
		if ( Zone != none )
		{
			Zone.OnTapDelegate = ShowSettingsTap;
			MPI.ActivateInputGroup("HUDGroup");
		}
	}
}

simulated function OnPopQuestion(MineSimSeqAct_PopQuestion inAction)
{
	PopUpQuestion = MineSimQuestion(MPI.OpenMenuScene(class'MineSimQuestion'));
	PopUpQuestion.SetStrings(inAction.Question, inAction.AnswerA, inAction.AnswerB, inAction.AnswerC, inAction.IDResponseA, inAction.IDResponseB, inAction.IDResponseC);
}

simulated function OnPopMessage(MineSimSeqAct_PopMessage inAction)
{
	PopUpMessage = MineSimMessage(MPI.OpenMenuScene(class'MineSimMessage'));
	PopUpMessage.SetStrings(inAction.Message, inAction.Caption);
}

/**
 * Delegate that gets called when the Settings button is tapped
 */
function bool ShowSettingsTap(MobileInputZone Zone, EZoneTouchEvent EventType, Vector2D TouchLocation)
{
	MineSimMenuSettings(MPI.OpenMenuScene(class'MineSimMenuSettings'));
	return true;
}
