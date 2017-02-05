Scriptname HentaiPregnantActorAlias extends ReferenceAlias  

HentaiPregnancy Property HentaiP Auto

Actor Property ActorRef Auto
Actor Property FatherRef Auto

Float CurrentBreastSize = 1.0
Float CurrentBellySize = 1.0

Float IncrBreastRate = 0.0
Float IncrBellyRate = 0.0

Int pregnancyId = -1
Int DurationHours = 0
Int PostDurationHours = 0
Int CurrentHour = 0
Int Milk = 0

float TargetBreastSize = 0.0
float TargetBellySize = 0.0

float lastGameTime = 0.0

bool isvictim = false
bool fertilised = false

Event OnInit()
	GoToState("ReadyForPregnancy")
EndEvent

auto State ReadyForPregnancy
	Event OnBeginState()
		CurrentHour = 0
		ActorRef = none
		FatherRef = none
		lastGameTime = 0.0
		isvictim = false
		fertilised = false
		Clear()
		;Debug.Notification("HentaiPregnantActorAlias Normal")
	EndEvent
	
	event OnUpdate()
		; catch any pending updates
	endEvent
EndState

function setFather(Actor male)
	FatherRef = male
endFunction

function setIsVictim(bool victim)
	isvictim = victim
endFunction

bool function isVictim()
	return isvictim
endFunction

function setFertilised(bool fertilise)
	fertilised = fertilise
endFunction

bool function isFertilised()
	return fertilised
endFunction

Actor function getFather()
	return FatherRef
endFunction

Actor function getMother()
	return ActorRef
endFunction

int function getCurrentHour()
	return CurrentHour
endFunction

int function getId()
	return pregnancyId
endFunction

int function setId(int newid)
	pregnancyId = newid
endFunction

int function getDurationHours()
	return DurationHours
endFunction

int function getPostDurationHours()
	return PostDurationHours
endFunction

int function getMilk()
	return Milk
endFunction

int function setMilk(int i)
	Milk = i
	return Milk
endFunction

function incrSize()
	if ( CurrentBreastSize < TargetBreastSize)
		CurrentBreastSize += IncrBreastRate
		if HentaiP.config.BreastScaling 
			HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC L Breast", CurrentBreastSize)
			HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC R Breast", CurrentBreastSize)
		EndIf
	endIf
	if ( CurrentBellySize < TargetBellySize)
		CurrentBellySize += IncrBellyRate
		if HentaiP.config.BellyScaling
			HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC Belly", CurrentBellySize)
		EndIf
	endIf	
endFunction

function decrSizeBreast()
	if ( CurrentBreastSize > 1)
		CurrentBreastSize -= IncrBreastRate
		if HentaiP.config.BreastScaling 
			HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC L Breast", CurrentBreastSize)
			HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC R Breast", CurrentBreastSize)
		EndIf
	endIf
	if CurrentBreastSize < 1
		if HentaiP.config.BellyScaling 
			HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC Belly", 1)
		EndIf
	EndIf
endFunction

function decrSizeBelly()
	if ( CurrentBellySize > 1)
		CurrentBellySize -= IncrBellyRate
		if HentaiP.config.BellyScaling 
			HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC Belly", CurrentBellySize)
		EndIf
	endIf
	
	if CurrentBellySize < 1
		if HentaiP.config.BreastScaling 
			HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC L Breast", 1)
			HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC R Breast", 1)
		EndIf
	EndIf
endFunction

State Inseminated
	Event OnBeginState()
		ActorRef = GetActorRef()
	
		int random = Utility.RandomInt(0, 100)
		int chance = HentaiP.config.CumInflationChance
		if random <= chance
			GoToState("CumInflated")
		elseif fertilised
			GoToState("Pregnant")
		else
			GoToState("ReadyForPregnancy")
		endIf
	EndEvent
	
	event OnDeath(Actor akKiller)
		GoToState("PregnancyEnded")
	EndEvent	
EndState

State CumInflated
	Event OnBeginState()
		CurrentBellySize = 1
		TargetBellySize = HentaiP.config.MaxScaleBelly * 0.25
		
		While CurrentBellySize < TargetBellySize
			if CurrentBellySize < TargetBellySize
				CurrentBellySize += 0.1
				if HentaiP.config.BellyScaling 
					HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC Belly", CurrentBellySize)
				endif
			EndIf
			Utility.Wait(0.1)
		EndWhile
		RegisterForSingleUpdateGameTime(1)
	EndEvent
	
	Event OnUpdateGameTime()
		UnregisterForUpdate()
		if fertilised
			GoToState("Pregnant")
		else
			GoToState("ReadyForPregnancy")		
		endIf
	EndEvent
		
	event OnEndState()
		While CurrentBellySize > 1
			if CurrentBellySize > 1
				CurrentBellySize -= 0.1
				if HentaiP.config.BellyScaling 
					HentaiP.BodyMod.SetNodeScale(ActorRef, "NPC Belly", CurrentBellySize)
				EndIf
			EndIf
			Utility.Wait(0.1)
		EndWhile
		HentaiP.ResetBody(ActorRef)
	endEvent
	
	event OnDeath(Actor akKiller)
		GoToState("PregnancyEnded")
	EndEvent	
EndState

State Pregnant
	Event OnBeginState()
		ActorRef = GetActorRef()
		;Debug.Notification("HentaiPregnantActorAlias Pregnant")
		int DurationDays = HentaiP.config.PregnancyDuration
		
		CurrentBellySize = 1
		CurrentBreastSize = 1
		TargetBreastSize = HentaiP.config.MaxScaleBreasts
		TargetBellySize = HentaiP.config.MaxScaleBelly	
		
		float BreastSizeDelta = TargetBreastSize - CurrentBreastSize
		float BellySizeDelt = TargetBellySize - CurrentBellySize
		DurationHours = DurationDays * 24
		IncrBreastRate = BreastSizeDelta / (DurationHours / 2)
		IncrBellyRate = BellySizeDelt / (DurationHours / 2)
		
		lastGameTime = Utility.GetCurrentGameTime()

		RegisterForSingleUpdateGameTime(1)
	EndEvent
	
	Event OnUpdateGameTime()
		if CurrentHour < DurationHours
			if(lastGameTime == 0.0)
				lastGameTime  = Utility.GetCurrentGameTime()
			EndIf		
			float currentTime  = Utility.GetCurrentGameTime()	
			float hourspassedfloat = (currentTime - lastGameTime) * 24
			int hourspassed = hourspassedfloat as int
			;Debug.Notification("Hours passed " + hourspassed)	
			if(hourspassed<=0)
				hourspassed = 1
			endif
			CurrentHour += hourspassed
			incrSize()
			lastGameTime = currentTime
			
			HentaiP.addTempPregnancyEffects(ActorRef, DurationHours - CurrentHour, isvictim)
			
			RegisterForSingleUpdateGameTime(1)
			
			if ActorRef == HentaiP.PlayerRef
				If CurrentHour >= DurationHours/3
					;hand milking
					if !ActorRef.HasSpell(HentaiP.HentaiMilkSquirtSpellList.GetAt(0) as Spell)
						Debug.Notification("It seems due to pregnancy you breasts started lactating")
						ActorRef.Addspell(HentaiP.HentaiMilkSquirtSpellList.GetAt(0) as Spell)
					EndIf
					;bottle milking; req HF
					if !ActorRef.HasSpell(HentaiP.HentaiMilkSquirtSpellList.GetAt(1) as Spell) && Game.GetModbyName("HearthFires.esm") != 255
						ActorRef.Addspell(HentaiP.HentaiMilkSquirtSpellList.GetAt(1) as Spell)
					EndIf
				EndIf
				
				If CurrentHour > DurationHours/3
					Milk += 1
				EndIf
			EndIf
			
		Else
			UnregisterForUpdate()
			GoToState("PregnancyEnded")
		EndIf
	EndEvent		
	
	event OnDeath(Actor akKiller)
		GoToState("PregnancyEnded")
	EndEvent	
EndState

State PregnancyEnded
	Event OnBeginState()
		;Debug.Notification("HentaiPregnantActorAlias PregnancyEnded")
		
		while ( ActorRef.IsOnMount() )
			ActorRef.Dismount()
			Utility.Wait( 2.0 )
		endWhile		
	
		HentaiP.endPregnancy(ActorRef, pregnancyId, isvictim, CurrentHour)
		GoToState("PostPregnancy")
	EndEvent
	
	event OnEndState()
		Debug.Notification(ActorRef.GetActorBase().GetName() + " is no longer pregnant")
	endEvent	
EndState

State PostPregnancy
	Event OnBeginState()
		int DurationDays = HentaiP.config.PregnancyDuration
		float BreastSizeDelta = CurrentBreastSize - 1
		float BellySizeDelt = CurrentBellySize - 1
		PostDurationHours = DurationDays * 7
		PostDurationHours += CurrentHour
		IncrBreastRate = BreastSizeDelta / PostDurationHours
		IncrBellyRate = BellySizeDelt / PostDurationHours
		
		lastGameTime = Utility.GetCurrentGameTime()
		While CurrentBellySize > 1
			decrSizeBelly()
			Utility.Wait(0.1)
		EndWhile
		
		RegisterForSingleUpdateGameTime(1)
	EndEvent
	
	Event OnUpdateGameTime()
		if CurrentHour < PostDurationHours
			if(lastGameTime == 0.0)
				lastGameTime  = Utility.GetCurrentGameTime()
			EndIf		
			float currentTime  = Utility.GetCurrentGameTime()	
			float hourspassedfloat = (currentTime - lastGameTime) * 24
			int hourspassed = hourspassedfloat as int
			;Debug.Notification("Hours passed " + hourspassed)	
			if(hourspassed<=0)
				hourspassed = 1
			endif
			CurrentHour += hourspassed
			int hourcount = 0;
			decrSizeBreast()
			lastGameTime = currentTime
			
			HentaiP.addTempPostPregnancyEffects(ActorRef, PostDurationHours - CurrentHour)
			
			RegisterForSingleUpdateGameTime(1)
		Else
			UnregisterForUpdate()
			GoToState("ReadyForPregnancy")
		EndIf
	EndEvent		
	
	event OnEndState()
		HentaiP.ResetBody(ActorRef)
		if HentaiP.config.EnableMessages
			Debug.Notification(ActorRef.GetActorBase().GetName() + "'s post pregnancy has ended")
		endif
	endEvent	
EndState

State ClearPregnancy
	Event OnBeginState()
		UnregisterForUpdate()
			
		if ActorRef == HentaiP.PlayerRef
			if ActorRef.HasSpell(HentaiP.HentaiMilkSquirtSpellList.GetAt(0) as Spell)
				Debug.Notification("As your pregnancy has ended you feel your breasts no longer produce any milk")
				ActorRef.RemoveSpell(HentaiP.HentaiMilkSquirtSpellList.GetAt(0) as Spell)
			EndIf
			if ActorRef.HasSpell(HentaiP.HentaiMilkSquirtSpellList.GetAt(1) as Spell)
				ActorRef.RemoveSpell(HentaiP.HentaiMilkSquirtSpellList.GetAt(1) as Spell)
			EndIf
		endif

		GoToState("ReadyForPregnancy")
	EndEvent
	
	event OnEndState()
		HentaiP.ResetBody(ActorRef)
		if HentaiP.config.EnableMessages
			Debug.Notification(ActorRef.GetActorBase().GetName() + "'s pregnancy terminated")
		endif
	endEvent	
EndState
