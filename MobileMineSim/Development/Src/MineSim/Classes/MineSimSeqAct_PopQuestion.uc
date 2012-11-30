/**
 */

class MineSimSeqAct_PopQuestion extends SequenceAction;

var() string	Question;

var() string AnswerA;
var() string AnswerB;
var() string AnswerC;
var() string IDResponseA;
var() string IDResponseB;
var() string IDResponseC;

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Pop Question"
	ObjCategory="Toggle"

	Question=""
	AnswerA=""
	AnswerB=""
	AnswerC=""
	IDResponseA=""
	IDResponseB=""
	IDResponseC=""

	InputLinks(0)=(LinkDesc="Show")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target",PropertyName=Targets)
}
