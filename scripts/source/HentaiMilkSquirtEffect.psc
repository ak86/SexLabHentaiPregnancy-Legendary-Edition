Scriptname HentaiMilkSquirtEffect extends ActiveMagicEffect  

Event OnEffectStart(Actor Target, Actor Caster)
	HentaiPregnancy HentaiP = Quest.GetQuest("HentaiPregnancyQuest") as HentaiPregnancy
	
	If HentaiP.PlayerREF == Caster
		Game.DisablePlayerControls()
	EndIf
	
	Debug.SendAnimationEvent(Caster,"ZaZAPCHorFC")
	
	int i = 0
	while i < HentaiP.PregnantActors.Length
			if HentaiP.PregnantActors[i].GetActorRef() == Caster
				int t = HentaiP.PregnantActors[i].getMilk()
				if t > 0
					t = HentaiP.PregnantActors[i].setMilk(t - 1)
					
					if self.GetBaseObject() != HentaiP.HentaiMilkSquirtSpellEffect && Game.GetModbyName("HearthFires.esm") != 255 
						Debug.Notification("You begin squeezing your delicious breast milk into a bottle.")
						HentaiP.PlayerRef.AddItem(Game.GetFormFromFile(0x3534, "HearthFires.esm"), 1)
					else
						Debug.Notification("You playfully squeeze breast milk everywhere!")
					endif
					
					if(Utility.RandomInt(0, 1) == 1)	
						HentaiP.playLeftMilkEffect(Caster)
					else
						HentaiP.playRightMilkEffect(Caster)
					endif
				else
					Debug.Notification("You playfully squeeze breasts, unfortunately they don't have much milk.")
					HentaiP.playNoMilkEffect(Caster)
				endIf
			endIf
		i += 1
	endWhile
	
	Debug.SendAnimationEvent(Caster, "IdleForceDefaultState")
	
	If HentaiP.PlayerREF == Caster
		Game.EnablePlayerControls()
	EndIf
endEvent