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
	class'ChatFilter'.static.FillPlayInfo(PI);
}

function bool ObjectNeedsUpdate(Object O, string PropName, string PropValue)
{
  if (PropName ~= "ServerPackages")
  {
    if (!class'ChatFilter'.default.bCheckNicknames && !Super.ObjectNeedsUpdate(O, PropName, PropValue))
    {
      RemoveArrayEntry(O, PropName, PropValue);
      return false;
    }
  }
  return Super.ObjectNeedsUpdate(O, PropName, PropValue);
}

defaultproperties
{
  bEnabled=true
  bIncludeServerActor=False
  ActorClass="ChatFilter.ChatFilter"
  FriendlyName="ChatFilter"
  ActorDescription="Filter chats on the server"
  RequiredIniEntries(0)=(ClassFrom="Engine.GameEngine",PropName="ServerActors",PropValue="ChatFilter.ChatFilter")
  RequiredIniEntries(1)=(ClassFrom="Engine.GameEngine",PropName="ServerPackages",PropValue="ChatFilter")
}
