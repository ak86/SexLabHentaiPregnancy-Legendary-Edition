ScriptName HentaiPregnancyConfig extends SKI_ConfigBase

HentaiPregnancy Property hentaiPregnancyQuest auto

; ----- Pregnancy settings -----
int Property CumInflationChance = 0 Auto Hidden
int CumInflationChanceDefault = 0
int OIDCumInflationChance
string CumInflationChanceDescription = "The chance of cum inflation."

int Property PregnancyChance = 100 Auto Hidden
int PregnancyChanceDefault = 100
int OIDPregnancyChance
string PregnancyChanceDescription = "The chance of pregnancy."

int Property ChildChance = 0 Auto Hidden
int ChildChanceDefault = 0
int OIDChildChance
string ChildChanceDescription = "The chance that the pregnancy produces a child."

int Property PregnancyDuration = 7 Auto Hidden
int PregnancyDurationDefault = 7
int OIDPregnancyDuration
string PregnancyDurationDescription = "Duration that pregnancy lasts in days."

string[] PregnancyActorOptions
int OIDPregnancyActorOptions
int Property PregnancyActorOption = 0 Auto Hidden
string PregnancyActorOptionDescription  = "Who can get pregnant."

int OIDClearPregnancies
bool ClearPregnancy = false
string ClearPregnancyDescription = "Remove pregnancies for uninstall or upgrade, go back to game and wait for message"

int OIDPregnancyEffects
bool Property PregnancyEffects = true Auto Hidden
string PregnancyEffectsDescription = "Enable pregnancy effects"

int OIDPostPregnancyEffects
bool Property PostPregnancyEffects = true Auto Hidden
string PostPregnancyEffectsDescription = "Enable post pregnancy effects"

int OIDAllowAnal
bool Property AllowAnal = true Auto Hidden
string AllowAnalDescription = "Allow anal pregnancy"

int OIDBreastScaling
bool Property BreastScaling = true Auto Hidden
string BreastScalingDescription = "Allow Breast Scaling"

int OIDBellyScaling
bool Property BellyScaling = true Auto Hidden
string BellyScalingDescription = "Allow Belly Scaling"

string[] BodyTypeOptions
int OIDBodyTypeOptions
int Property BodyTypeOption = 0 Auto Hidden
string BodyTypeOptionDescription  = "Which body - CBBE or UNP, used to apply pregnancy effects"

int OIDEnableMessages
bool Property EnableMessages = true Auto Hidden
string EnableMessagesDescription = "Enable pregnancy messages"

; ----- Size settings -----
Float Property MaxScaleBelly = 5.0 Auto Hidden
Float MaxScaleBellyDefault = 5.0
int OIDMaxScaleBelly
string MaxScaleBellyDescription = "Adjust the max belly scale."

Float Property MaxScaleBreasts = 2.0 Auto Hidden
Float MaxScaleBreastsDefault = 2.0
int OIDMaxScaleBreasts
string MaxScaleBreastsDescription = "Adjust the max breast scale."

Event OnConfigInit()
	Pages = new string[2]
	Pages[0] = "Pregnancy Settings"
	Pages[1] = "Pregnancy List"
	
	PregnancyActorOptions = new string[2]
	PregnancyActorOptions[0] = "All"
	PregnancyActorOptions[1] = "NPC Only"	
	
	BodyTypeOptions = new string[2]
	BodyTypeOptions[0] = "CBBE"
	BodyTypeOptions[1] = "UNP"		
	
EndEvent

int function GetVersion()
	return 1170
endFunction

event OnVersionUpdate(int a_version)
	if (a_version > 1)
		Debug.Trace(self + ": Updating script to version " + a_version)
		OnConfigInit()
		;if (a_version >= 1050 && CurrentVersion < 1050)
		
		;endIf
	endIf
endEvent

Event OnPageReset(string page)
	{Called when a new page is selected, including the initial empty page}
	
	If page == "Pregnancy Settings"
		
		SetCursorFillMode(TOP_TO_BOTTOM)
		
		SetCursorPosition(0)
		
		AddHeaderOption("Pregnancy Settings")
		
		OIDPregnancyActorOptions = AddMenuOption("Include Actors", PregnancyActorOptions[PregnancyActorOption])
		OIDAllowAnal = AddToggleOption("Allow Anal", AllowAnal)
		
		OIDPregnancyChance = AddSliderOption("Chance of pregnancy", PregnancyChance, "{0}%")
		OIDChildChance = AddSliderOption("Chance of producing a child", ChildChance, "{0}%")
		OIDCumInflationChance = AddSliderOption("Chance of cum inflation", CumInflationChance, "{0}%")
		OIDPregnancyDuration = AddSliderOption("Pregnancy Duration", PregnancyDuration, "{0} days")

		OIDBellyScaling = AddToggleOption("Allow Belly Scaling", BellyScaling)
		OIDMaxScaleBelly = AddSliderOption("Belly Max Scale", MaxScaleBelly, "{1}")

		OIDBreastScaling = AddToggleOption("Allow Breast Scaling", BreastScaling)
		OIDMaxScaleBreasts = AddSliderOption("Breasts Max Scale", MaxScaleBreasts, "{1}")
		
		OIDPregnancyEffects = AddToggleOption("Enable Pregnancy effects", PregnancyEffects)
		OIDPostPregnancyEffects = AddToggleOption("Enable Post Pregnancy effects", PostPregnancyEffects)
		OIDBodyTypeOptions = AddMenuOption("Body Type", BodyTypeOptions[BodyTypeOption])
		
		OIDEnableMessages = AddToggleOption("Enable Messages", EnableMessages)
		
		OIDClearPregnancies = AddToggleOption("Clear Pregnancies", ClearPregnancy)
		
	ElseIf page == "Pregnancy List"
		SetCursorFillMode(TOP_TO_BOTTOM)
		
		SetCursorPosition(0)
		
		AddHeaderOption("Pregnancy List")
		string[] plist = hentaiPregnancyQuest.getPregnancyList()
		int i = 0
		while i < plist.Length
			AddTextOption(plist[i], "", OPTION_FLAG_DISABLED)
			i += 1
		endWhile		
		
	Else
		
		SetCursorFillMode(TOP_TO_BOTTOM)
		
		SetCursorPosition(0)
		
		AddHeaderOption("SexLab Hentai Pregnancy")
		AddTextOption("Simplified pregnancy for SexLab.", "", OPTION_FLAG_DISABLED)
	EndIf
	
EndEvent

Event OnOptionSliderAccept(int option, float floatValue)
	
	int value = floatValue as int
	
	If option == OIDPregnancyChance
		
		SetSliderOptionValue(option, floatValue, "{0}%")
		PregnancyChance = value

	ElseIf option == OIDChildChance
		
		SetSliderOptionValue(option, floatValue, "{0}%")
		ChildChance = value
		
	ElseIf option == OIDCumInflationChance
		
		SetSliderOptionValue(option, floatValue, "{0}%")
		CumInflationChance = value
		
	ElseIf option == OIDMaxScaleBelly
		
		SetSliderOptionValue(option, floatValue,"{1}")
		MaxScaleBelly = floatValue
		
	ElseIf option == OIDMaxScaleBreasts
		
		SetSliderOptionValue(option, floatValue, "{1}")
		MaxScaleBreasts = floatValue
		
	ElseIf option == OIDPregnancyDuration
		
		SetSliderOptionValue(option, floatValue, "{0} days")
		PregnancyDuration = value
		
	EndIf
	
EndEvent

Event OnOptionSliderOpen(int option)
	
	If option == OIDPregnancyChance
		
		SetSliderDialogStartValue(PregnancyChance)
		SetSliderDialogDefaultValue(PregnancyChanceDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	
	ElseIf option == OIDChildChance
		
		SetSliderDialogStartValue(ChildChance)
		SetSliderDialogDefaultValue(ChildChanceDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		
	ElseIf option == OIDCumInflationChance
		
		SetSliderDialogStartValue(CumInflationChance)
		SetSliderDialogDefaultValue(CumInflationChanceDefault)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)	
		
	ElseIf option == OIDMaxScaleBelly
		
		SetSliderDialogStartValue(MaxScaleBelly)
		SetSliderDialogDefaultValue(MaxScaleBellyDefault)
		SetSliderDialogRange(0.5, 20)
		SetSliderDialogInterval(0.5)
		
	ElseIf option == OIDMaxScaleBreasts
		
		SetSliderDialogStartValue(MaxScaleBreasts)
		SetSliderDialogDefaultValue(MaxScaleBreastsDefault)
		SetSliderDialogRange(1, 10)
		SetSliderDialogInterval(0.1)

	ElseIf option == OIDPregnancyDuration
		
		SetSliderDialogStartValue(PregnancyDuration)
		SetSliderDialogDefaultValue(PregnancyDurationDefault)
		SetSliderDialogRange(1, 30)
		SetSliderDialogInterval(1)
		
	EndIf
	
EndEvent

event OnOptionMenuOpen(int option)
	if (option == OIDPregnancyActorOptions)
	
		SetMenuDialogOptions(PregnancyActorOptions)
		SetMenuDialogStartIndex(PregnancyActorOption)
		SetMenuDialogDefaultIndex(PregnancyActorOption)
		
	elseif (option == OIDBodyTypeOptions)
	
		SetMenuDialogOptions(BodyTypeOptions)
		SetMenuDialogStartIndex(BodyTypeOption)
		SetMenuDialogDefaultIndex(BodyTypeOption)	
			
	endIf
endEvent


event OnOptionMenuAccept(int option, int index)
	if (option == OIDPregnancyActorOptions)
	
		PregnancyActorOption = index
		SetMenuOptionValue(OIDPregnancyActorOptions, PregnancyActorOptions[PregnancyActorOption])
		
	elseif (option == OIDBodyTypeOptions)
	
		BodyTypeOption = index
		SetMenuOptionValue(OIDBodyTypeOptions, BodyTypeOptions[BodyTypeOption])
		
	endIf
endEvent

event OnOptionSelect(int option)
	if (option == OIDClearPregnancies && !ClearPregnancy)
	
		ClearPregnancy = true
		SetToggleOptionValue(OIDClearPregnancies, ClearPregnancy)
		hentaiPregnancyQuest.clearPregnancies()
		
	elseIf option == OIDPregnancyEffects
	
		PregnancyEffects = !PregnancyEffects
		SetToggleOptionValue(OIDPregnancyEffects, PregnancyEffects)
		
	elseIf option == OIDBellyScaling
	
		BellyScaling = !BellyScaling
		SetToggleOptionValue(OIDBellyScaling, BellyScaling)
		
	elseIf option == OIDBreastScaling
	
		BreastScaling = !BreastScaling
		SetToggleOptionValue(OIDBreastScaling, BreastScaling)
		
	elseIf option == OIDPostPregnancyEffects
	
		PostPregnancyEffects = !PostPregnancyEffects
		SetToggleOptionValue(OIDPostPregnancyEffects, PostPregnancyEffects)
		
	elseIf option == OIDAllowAnal
	
		AllowAnal = !AllowAnal
		SetToggleOptionValue(OIDAllowAnal, AllowAnal)
		
	elseIf option == OIDEnableMessages
	
		EnableMessages = !EnableMessages
		SetToggleOptionValue(OIDEnableMessages, EnableMessages)
		
	endIf
endEvent

Event OnOptionHighlight(int option)
	
	If option == OIDPregnancyChance
		SetInfoText(PregnancyChanceDescription)
		
	ElseIf option == OIDChildChance
		SetInfoText(ChildChanceDescription)
		
	ElseIf option == OIDCumInflationChance
		SetInfoText(CumInflationChanceDescription)	
		
	ElseIf option == OIDPregnancyDuration
		SetInfoText(PregnancyDurationDescription)
		
	ElseIf option == OIDMaxScaleBelly
		SetInfoText(MaxScaleBellyDescription)
		
	ElseIf option == OIDMaxScaleBreasts
		SetInfoText(MaxScaleBreastsDescription)
		
	ElseIf option == OIDPregnancyActorOptions
		SetInfoText(PregnancyActorOptionDescription)	
			
	ElseIf option == OIDClearPregnancies
		SetInfoText(ClearPregnancyDescription)	
			
	ElseIf option == OIDPregnancyEffects
		SetInfoText(PregnancyEffectsDescription)	
		
	ElseIf option == OIDBreastScaling
		SetInfoText(BreastScalingDescription)	
		
	ElseIf option == OIDBellyScaling
		SetInfoText(BellyScalingDescription)	
		
	ElseIf option == OIDPostPregnancyEffects
		SetInfoText(PostPregnancyEffectsDescription)						
			
	ElseIf option == OIDAllowAnal
		SetInfoText(AllowAnalDescription)						
			
	ElseIf option == OIDEnableMessages
		SetInfoText(EnableMessagesDescription)						
			
	EndIf
	
EndEvent

function pregnanciesCleared()
	ClearPregnancy = false
	SetToggleOptionValue(OIDClearPregnancies, ClearPregnancy)
endfunction

event OnGameReload()
	parent.OnGameReload() ; Don't forget to call the parent!
	
	hentaiPregnancyQuest.gameLoaded()
endEvent