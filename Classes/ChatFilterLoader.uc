///////////////////////////////////////////////////////////////////////////////
// filename:    ChatFilterLoader.uc
// version:     101
// author:      Michiel 'El Muerte' Hendriks <elmuerte@drunksnipers.com>
// purpose:     Auto loader for ChatFilter
///////////////////////////////////////////////////////////////////////////////

class ChatFilterLoader extends AutoLoader;

var config bool bEnabled;

event PreBeginPlay()
{
	class'ChatFilter'.default.bEnabled = bEnabled;
	Super.PreBeginPlay();
}

static function bool IsActive()
{
	return true;
}

static function bool EnableLoader(optional string SpecialActor)
{
	default.bEnabled = True;
	return true;
}

static function bool DisableLoader(optional string SpecialActor)
{
	default.bEnabled = False;
	return true;
}

function bool ApplyUpdate()
{
	return default.bEnabled;
}

static function FillPlayInfo(PlayInfo PI)
{
  Super.FillPlayInfo(PI);
  PI.AddSetting("Server Actors", "bEnabled", "Chat Filter", 10, 255, "Check");
}

function bool ObjectNeedsUpdate(Object O, string PropName, string PropValue)
{
  if (Caps(PropName) == "SERVERPACKAGES")
  {
    if (!class'ChatFilter'.default.bCheckNicknames && !class'ChatFilter'.default.bFriendlyMessage && !Super.ObjectNeedsUpdate(O, PropName, PropValue))
    {
      RemoveArrayEntry(O, PropName, PropValue);
      return false;
    }
  }
  return Super.ObjectNeedsUpdate(O, PropName, PropValue);
}

function int CheckArrayEntry(string PropName, array<string> PropArray)
{
	local int i;
  if (Caps(PropName) == "SERVERPACKAGES")
  {
    for (i = 0; i < PropArray.Length; i++)
    {
      if (Caps(PropArray[i]) == "\"CHATFILTERMSG\"")
      {
        return i;
      }
      if (Caps(PropArray[i]) == "\"CHATFILTERMSG151\"")
      {
        return i;
      }
    }
  }
  return -1;
}

defaultproperties
{
  bEnabled=true
  bIncludeServerActor=True
  ActorClass="ChatFilter.ChatFilter"
  FriendlyName="ChatFilter"
  ActorDescription="Filter chats on the server"
  RequiredIniEntries(0)=(ClassFrom="Engine.GameEngine",PropName="ServerPackages",PropValue="ChatFilterMsg152")
}
