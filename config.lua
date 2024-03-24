	
	--[[

		PlateBuffer
			Nameplate auras for Wow TBC 2.4.3
			https://github.com/nullfoxh

			Config

			Thanks to Pyralis who let me butcher his config GUI for this.

	]]--


	local guiFrame
	local frameWidth = 460
	local frameHeight = 600
	local listWidth = 195

	---------------------------------------------------------------------------------------------

	local function SetActiveProfile(profile)
		PBCONF.activeprofile = PBCONF.profiles[profile]

		local realm, player = GetRealmName(), UnitName("player")

		if not PBCONF.playerprofiles[realm] then
			PBCONF.playerprofiles[realm] = {}
		end

		PBCONF.playerprofiles[realm][player] = PBCONF.activeprofile.name

	end

	local function NewProfile(pname)
		if not pname or pname == "" or PBCONF.profiles[pname] then
			return false
		end

		local profile = {
			name = pname,
			auraWidth = 25,
			auraHeight = 15,
			auraSpacing = 3,
			aurasPerRow = 4,
			auraRows = 2,
			auraOffx = 0,
			auraOffy = 16,
			fontSize = 10,
			fontOffx = 1,
			fontOffy = 1,
			borderSize = 1,
			auraList = {},
			disableDuration = false,
			disableCooldown = false,
		}
		PBCONF.profiles[pname] = profile
		return profile
	end

	local function NewDefaultProfile()
		local profile = NewProfile("default")
		if GetLocale() == "frFR" then
		profile.auraList = {

			-- Racials
			["Volonté des Réprouvés"] = "all",
			["Choc martial"] = "all",
			["Forme de pierre"] = "all",
			["Perception"] = "all",
			["Berserker"] = "all",
			["Fureur sanguinaire"] = "all",
			["Châtier"] = "all",
			["Torrent arcanique"] = "all",
  
			-- Items
			["Grenade en adamantite"] = "all",
			["Bombe en gangrefer"] = "all",
			["Etourdir"] = "all", -- Deep Thunder/Storm Herald stun
			["Filet en tisse-néant"] = "all",
			["Filet épais en tisse-néant"] = "all",
			["Potion de vive action"] = "all",
			["Potion de libre action"] = "all",
			["Libre action ravivée"] = "all",
			["Libre action"] = "all",

			-- Rogue
			["Coup bas"] = "all",
			["Aiguillon perfide"] = "all",
			["Suriner"] = "all",
			["Cécité"] = "all",
			["Assommer"] = "all",
			["Cécité"] = "all",
			["Cape d'ombre"] = "all",
			["Trompe-la-mort"] = "all",
			["Poussée d'adrénaline"] = "all",
			["Evasion"] = "all",
			["Sprint"] = "all",
			["Lancer mortel"] = "mine",
			["Coup de pied - Silencieux"] = "all",
			["Riposte"] = "all",
			["Sang froid"] = "all",
			["Rupture"] = "mine",
			["Garrot"] = "mine",
			["Garrot - Silence"] = "mine",
			["Exposer l'armure"] = "all",
			["Poison douloureux"] = "mine",
			["Poison mortel"] = "mine",
			["Poison affaiblissant"] = "mine",
			["Poison de distraction mentale"] = "mine",
			["Hébétement"] = "mine", -- blade twisting
			["Hémorragie"] = "mine",
			["Frappe fantomatique"] = "all",


			-- Warlock
			["Voile mortel"] = "all",
			["Peur"] = "all",
			["Hurlement de terreur"] = "all",
			["Furie de l'ombre"] = "all",
			["Séduction"] = "all",
			["Verrou magique"] = "all",
			["Bannir"] = "all",
			["Malédiction d'agonie"] = "mine",
			["Corruption"] = "mine",
			["Immolation"] = "mine",
			["Affliction instable"] = "mine",
			["Malédiction de faiblesse"] = "mine",
			["Malédiction de témérité"] = "mine",
			["Malédiction des éléments"] = "all",
			["Malédiction des langages"] = "all",
			["Malédiction funeste"] = "mine",
			["Siphon de vie"] = "mine",
			["Graine de Corruption"] = "mine",
			--["Interception étourdissante"] = "all", -- Felguard
			["Pyroclasme"] = "all",
			["Contrecoup"] = "all",
			["Transe de l'ombre"] = "all",
			["Domination corrompue"] = "all",
			["Gardien de l'ombre"] = "all",
			["Protection du Néant"] = "all",
			["Malédiction de fatigue"] = "all",
			["Sacrifice"] = "all",

			-- Priest
			["Contrôle mental"] = "all",
			["Cri psychique"] = "all",
			["Aveuglement"] = "all",
			["Silence"] = "all",
			["Gardien de peur"] = "all",
			["Suppression de la douleur"] = "all",
			["Infusion de puissance"] = "all",
			["Entraves des morts-vivants"] = "all",
			["Grâce d'Elune"] = "all",
			["Toucher de faiblesse"] = "all",
			["Garde de l'ombre"] = "all",
			["Mot de l'ombre : Douleur"] = "mine",
			["Toucher vampirique"] = "mine",
			["Etreinte vampirique"] = "mine",
			["Peste dévorante"] = "mine",
			["Eclats stellaires"] = "mine",
			["Flammes sacrées"] = "mine",
			["Châtier"] = "all",
			["Mot de pouvoir : Bouclier"] = "all",
			["Prière de guérison"] = "all",
			["Maléfice de faiblesse"] = "all",
			["Apaisement"] = "all",

			-- Mage
			["Nova de givre"] = "all",
			["Gel"] = "all",
			["Morsure de givre"] = "all",
			["Métamorphose"] = "all",
			["Contresort - Silencieux"] = "all",
			["Bloc de glace"] = "all",
			["Veines glaciales"] = "all",
			["Pouvoir des arcanes"] = "all",
			["Souffle du dragon"] = "all",
			["Vague explosive"] = "mine",
			["Cône de froid"] = "mine",
			["Lenteur"] = "all",
			["Vulnérabilité au Feu"] = "all",
			["Froid hivernal"] = "mine",
			["Gardien de feu"] = "all",
			["Gardien de givre"] = "all",
			["Barrière de glace"] = "all",
			["Présence spirituelle"] = "all",
			["Bouclier de mana"] = "all",
			["Vitesse flamboyante"] = "all",
			["Invisibilité"] = "all",
			["Impact"] = "all",
			["Eclair de givre"] = "mine",
			["Choc de flammes"] = "mine",
			["Evocation"] = "all",

			-- Warrior
			["Charge étourdissante"] = "all",
			["Coup traumatisant"] = "all",
			["Interception étourdissante"] = "all",
			["Désarmement"] = "all",
			["Effet étourdissant de la masse"] = "all",
			["Intervention"] = "all",
			["Renvoi de sort"] = "all",
			["Souhait mortel"] = "all",
			["Rage berserker"] = "all",
			["Cri d'intimidation"] = "all",
			["Coup de bouclier - silencieux"] = "all",
			["Frappe mortelle"] = "mine",
			["Hurlement perçant"] = "mine",
			["Pourfendre"] = "mine",
			["Coup de tonnerre"] = "mine",
			["Brise-genou"] = "mine",
			["Brise-genou amélioré"] = "all",
			["Cri de défi"] = "all",
			["Coup railleur"] = "all",
			["Fracasser armure"] = "all",
			["Cri de guerre"] = "mine",
			["Cri de commandement"] = "mine",
			["Rage sanguinaire"] = "all",
			--["Sanguinaire"] = "all",
			["Folie sanguinaire"] = "all",
			["Souhait mortel"] = "all",
			["Enrager"] = "all",
			["Dernier rempart"] = "all",
			["Représailles"] = "all",
			["Second souffle"] = "all",
			["Mur protecteur"] = "all",
			["Attaques circulaires"] = "all",
			["Maîtrise du blocage"] = "all",
			["Témérité"] = "all",
			["Etourdissement vengeur"] = "all",
			["Provocation"] = "mine",

			-- Druid
			["Sonner"] = "all",
			["Cyclone"] = "all",
			["Sarments"] = "all",
			["Hibernation"] = "all",
			["Estropier"] = "all",
			["Traquenard"] = "all",
			["Traquenard sanglant"] = "mine",
			["Innervation"] = "all",
			["Ecorce"] = "all",
			["Eclat lunaire"] = "mine",
			["Effet de charge farouche"] = "all",
			["Lucioles"] = "mine",
			["Lucioles (farouche)"] = "mine",
			["Focalisation céleste"] = "all",
			["Feu stellaire étourdissant"] = "all",
			["Essaim d'insectes"] = "mine",
			["Mutilation (ours)"] = "mine",
			["Mutilation (félin)"] = "mine",
			["Déchirure"] = "mine",
			["Griffure"] = "mine",
			["Régénération frénétique"] = "all",
			["Rugissement démoralisant"] = "mine",
			["Lacérer"] = "mine",
			["Rugissement provocateur"] = "all",
			["Rapidité de la nature"] = "all",
			["Abolir le poison"] = "all",
			["Célérité"] = "all",
			["Grondement"] = "all",
			["Tranquillité"] = "all",
			["Emprise de la nature"] = "all",
			["Apaiser les animaux"] = "all",

			-- Hunter
			["Piège givrant"] = "all",
			["Effet Piège givrant"] = "all",
			["Intimidation"] = "all",
			["Effrayer une bête"] = "all",
			["Flèche de dispersion"] = "all",
			["La bête intérieure"] = "all",
			["Courroux bestial"] = "all",
			["Flèche-bâillon"] = "all",
			["Piège"] = "all",
			["Dissuasion"] = "all",
			["Piqûre de wyverne"] = "all",
			["Morsure de vipère"] = "mine",
			["Morsure de serpent"] = "mine",
			["Trait de choc"] = "mine",
			["Barrage commotionnant"] = "mine",
			["Trait de choc amélioré"] = "all",
			["Coupure d'ailes"] = "mine",
			["Coupure d'ailes améliorée"] = "all",
			["Marque du chasseur"] = "mine",
			["Fusée éclairante"] = "mine",
			["Visée"] = "mine",
			["Flèche noire"] = "mine",
			["Effet Piège explosif"] = "mine",
			["Effet de Piège d'immolation"] = "mine",
			["Guérison du familier"] = "all",
			["Contre-attaque"] = "all",
			-- Pet
			["Crachat de poison"] = "all", -- Serpent
			["Poison de scorpide"] = "all",
			["Boutoir"] = "all",
			--["Hurlement"] = "all", -- Bat / Bird of Prey / Carrion Bird
			["Souffle de feu"] = "all", -- Dragonhawk

			-- Shaman
			["Furie sanguinaire"] = "all",
			["Héroïsme"] = "all",
			["Lien à la terre"] = "all",
			["Horion de flammes"] = "mine",
			["Horion de givre"] = "mine",
			["Attaque Arme de givre"] = "mine",
			["Etourdissement de Griffes de pierre"] = "all",
			["Frappe-tempête"] = "mine",
			["Bouclier de terre"] = "all",
			["Bouclier d'eau"] = "all",
			["Bouclier de foudre"] = "all",
			["Rapidité de la nature"] = "all",
			["Totem de Vague de mana"] = "all",
			["Maîtrise élémentaire"] = "all",
			["Rage du chaman"] = "all",
			["Incantation focalisée"] = "all",

			-- Paladin
			["Marteau de la justice"] = "all",
			["Repentir"] = "all",
			["Bouclier divin"] = "all",
			["Bénédiction de protection"] = "all",
			["Bénédiction de liberté"] = "all",
			["Bénédiction de sacrifice"] = "all",
			["Protection divine"] = "all",
			["Bouclier du vengeur"] = "mine",
			["Consécration"] = "mine",
			["Jugement de justice"] = "mine",
			["Jugement de lumière"] = "mine",
			["Jugement de sagesse"] = "mine",
			["Jugement du Croisé"] = "mine",
			["Faveur divine"] = "all",
			["Renvoi des morts-vivants"] = "all",
			["Courroux vengeur"] = "all",
			["Renvoi du mal"] = "all",

		}
		else
		profile.auraList = {

			-- Racials
			["Will of the Forsaken"] = "all",
			["War Stomp"] = "all",
			["Stoneform"] = "all",
			["Perception"] = "all",
			["Berserking"] = "all",
			["Blood Fury"] = "all",
			["Stoneform"] = "all",
			["Arcane Torrent"] = "all",

			-- Items
			["Adamantite Grenade"] = "all",
			["Fel Iron Bomb"] = "all",
			["Stun"] = "all", -- Deep Thunder/Storm Herald stun
			["Netherweave Net"] = "all",
			["Heavy Netherweave Net"] = "all",
			["Living Free Action Potion"] = "all",
			["Free Action Potion"] = "all",
			["Living Free Action"] = "all",
			["Free Action"] = "all",
			
			-- Rogue
			["Cheap Shot"] = "all",
			["Kidney Shot"] = "all",
			["Gouge"] = "all",
			["Blind"] = "all",
			["Sap"] = "all",
			["Blind"] = "all",
			["Cloak of Shadows"] = "all",
			["Cheat Death"] = "all",
			["Adrenaline Rush"] = "all",
			["Evasion"] = "all",
			["Sprint"] = "all",
			["Deadly Throw"] = "mine",
			["Kick - Silenced"] = "all",
			["Riposte"] = "all",
			["Cold Blood"] = "all",
			["Rupture"] = "mine",
			["Garrote"] = "mine",
			["Expose Armor"] = "all",
			["Wound Poison"] = "mine",
			["Deadly Poison"] = "mine",
			["Crippling Poison"] = "mine",
			["Mind-numbing Poison"] = "mine",
			["Dazed"] = "mine", -- blade twisting
			["Hemorrhage"] = "mine",
			["Ghostly Strike"] = "all",
			["Garrote - Silence"] = "mine",
			
			-- Warlock
			["Death Coil"] = "all",
			["Fear"] = "all",
			["Howl of Terror"] = "all",
			["Shadowfury"] = "all",
			["Seduction"] = "all",
			["Spell Lock"] = "all",
			["Banish"] = "all",
			["Curse of Agony"] = "mine",
			["Corruption"] = "mine",
			["Immolate"] = "mine",
			["Unstable Affliction"] = "mine",
			["Curse of Weakness"] = "mine",
			["Curse of Recklessness"] = "mine",
			["Curse of the Elements"] = "all",
			["Curse of Tongues"] = "all",
			["Curse of Doom"] = "mine",
			["Siphon Life"] = "mine",
			["Seed of Corruption"] = "mine",
			--["Intercept Stun"] = "all", -- Felguard
			["Pyroclasm"] = "all",
			["Backlash"] = "all",
			["Shadow Trance"] = "all",
			["Fel Domination"] = "all",
			["Shadow Ward"] = "all",
			["Nether Protection"] = "all",
			["Curse of Exhaustion"] = "all",
			["Sacrifice"] = "all",

			-- Priest
			["Mind Control"] = "all",
			["Psychic Scream"] = "all",
			["Blackout"] = "all",
			["Silence"] = "all",
			["Fear Ward"] = "all",
			["Pain Suppression"] = "all",
			["Power Infusion"] = "all",
			["Shackle Undead"] = "all",
			["Elune's Grace"] = "all",
			["Touch of Weakness"] = "all",
			["Shadowguard"] = "all",
			["Shadow Word: Pain"] = "mine",
			["Vampiric Touch"] = "mine",
			["Vampiric Embrace"] = "mine",
			["Devouring Plague"] = "mine",
			["Starshards"] = "mine",
			["Holy Fire"] = "mine",
			["Chastise"] = "all",
			["Power Word: Shield"] = "all",
			["Prayer of Mending"] = "all",
			["Hex of Weakness"] = "all",
			["Mind Soothe"] = "all",
		
			-- Mage
			["Frost Nova"] = "all",
			["Freeze"] = "all",
			["Frostbite"] = "all",
			["Polymorph"] = "all",
			["Counterspell - Silenced"] = "all",
			["Ice Block"] = "all",
			["Icy Veins"] = "all",
			["Arcane Power"] = "all",
			["Dragon's Breath"] = "all",
			["Blast Wave"] = "mine",
			["Cone of Cold"] = "mine",
			["Slow"] = "all",
			["Fire Vulnerability"] = "all",
			["Winter's Chill"] = "all",
			["Fire Ward"] = "all",
			["Frost Ward"] = "all",
			["Ice Barrier"] = "all",
			["Presence of Mind"] = "all",
			["Mana Shield"] = "all",
			["Blazing Speed"] = "all",
			["Invisibility"] = "all",
			["Impact"] = "all",
			["Frostbolt"] = "mine",
			["Flamestrike"] = "mine",
			["Evocation"] = "all",
			
			-- Warrior
			["Charge Stun"] = "all",
			["Concussion Blow"] = "all",
			["Intercept Stun"] = "all",
			["Disarm"] = "all",
			["Mace Stun Effect"] = "all",
			["Intervene"] = "all",
			["Spell Reflection"] = "all",
			["Death Wish"] = "all",
			["Berserker Rage"] = "all",
			["Intimidating Shout"] = "all",
			["Shield Bash - Silenced"] = "all",
			["Mortal Strike"] = "mine",
			["Piercing Howl"] = "mine",
			["Rend"] = "mine",
			["Thunder Clap"] = "mine",
			["Hamstring"] = "mine",
			["Improved Hamstring"] = "all",
			["Challenging Shout"] = "all",
			["Mocking Blow"] = "all",
			["Sunder Armor"] = "all",
			["Battle Shout"] = "mine",
			["Commanding Shout"] = "mine",
			["Bloodrage"] = "all",
			--["Bloodthirst"] = "all",
			["Blood Craze"] = "all",
			["Death Wish"] = "all",
			["Enrage"] = "all",
			["Last Stand"] = "all",
			["Retaliation"] = "all",
			["Second Wind"] = "all",
			["Shield Wall"] = "all",
			["Sweeping Strikes"] = "all",
			["Shield Block"] = "all",
			["Recklessness"] = "all",
			["Revenge Stun"] = "all",
			["Taunt"] = "mine",

			-- Druid
			["Bash"] = "all",
			["Cyclone"] = "all",
			["Entangling Roots"] = "all",
			["Hibernate"] = "all",
			["Maim"] = "all",
			["Pounce"] = "all",
			["Pounce Bleed"] = "mine",
			["Innervate"] = "all",
			["Barkskin"] = "all",
			["Moonfire"] = "mine",
			["Feral Charge Effect"] = "all",
			["Faerie Fire"] = "mine",
			["Faerie Fire (Feral)"] = "mine",
			["Celestial Focus"] = "all",
			["Insect Swarm"] = "mine",
			["Mangle (Bear)"] = "mine",
			["Mangle (Cat)"] = "mine",
			["Rip"] = "mine",
			["Rake"] = "mine",
			["Frenzied Regeneration"] = "all",
			["Demoralizing Roar"] = "mine",
			["Lacerate"] = "mine",
			["Challenging Roar"] = "all",
			["Nature's Swiftness"] = "all",
			["Abolish Poison"] = "all",
			["Starfire Stun"] = "all",
			["Dash"] = "all",
			["Growl"] = "all",
			["Tranquility"] = "all",
			["Nature's Grasp"] = "all",
			["Soothe Animal"] = "all",
			
			-- Hunter
			["Freezing Trap"] = "all",
			["Intimidation"] = "all",
			["Scare Beast"] = "all",
			["Scatter Shot"] = "all",
			["The Beast Within"] = "all",
			["Bestial Wrath"] = "all",
			["Silencing Shot"] = "all",
			["Entrapment"] = "all",
			["Deterrence"] = "all",
			["Wyvern Sting"] = "all",
			["Viper Sting"] = "mine",
			["Serpent Sting"] = "mine",
			["Concussive Shot"] = "mine",
			["Concussive Barrage"] = "mine",
			["Improved Concussive Shot"] = "all",
			["Wing Clip"] = "mine",
			["Improved Wing Clip"] = "all",
			["Hunter's Mark"] = "mine",
			["Flare"] = "mine",
			["Aimed Shot"] = "mine",
			["Black Arrow"] = "mine",
			["Explosive Trap Effect"] = "mine",
			["Immolation Trap Effect"] = "mine",
			["Freezing Trap Effect"] = "all",
			["Mend Pet"] = "all",
			["Counterattack"] = "all",
			-- Pet
			["Poison Spit"] = "all", -- Serpent
			["Scorpid Poison"] = "all",
			["Boar Charge"] = "all",
			--["Screech"] = "all", -- Bat / Bird of Prey / Carrion Bird
			["Fire Breath"] = "all", -- Dragonhawk

			-- Shaman
			["Bloodlust"] = "all",
			["Heroism"] = "all",
			["Earthbind"] = "all",
			["Flame Shock"] = "mine",
			["Frost Shock"] = "mine",
			["Frostbrand Attack"] = "mine",
			["Stoneclaw Stun"] = "all",
			["Stormstrike"] = "mine",
			["Earth Shield"] = "all",
			["Water Shield"] = "all",
			["Lightning Shield"] = "all",
			["Nature's Swiftness"] = "all",
			["Mana Tide Totem"] = "all",
			["Elemental Mastery"] = "all",
			["Shamanistic Rage"] = "all",
			["Focused Casting"] = "all",
			
			-- Paladin
			["Hammer of Justice"] = "all",
			["Repentance"] = "all",
			["Divine Shield"] = "all",
			["Blessing of Protection"] = "all",
			["Blessing of Freedom"] = "all",
			["Blessing of Sacrifice"] = "all",
			["Divine Protection"] = "all",
			["Avenger's Shield"] = "mine",
			["Consecration"] = "mine",
			["Judgement of Justice"] = "mine",
			["Judgement of Light"] = "mine",
			["Judgement of Wisdom"] = "mine",
			["Judgement of Wisdom"] = "mine",
			["Judgement of the Crusader"] = "mine",
			["Divine Favor"] = "all",
			["Turn Undead"] = "all",
			["Avenging Wrath"] = "all",
			["Turn Evil"] = "all",
		}
		end
		return profile
	end

	local function ApplySettings()
		_G["PlateBufferListEditInput"]:ClearFocus()
		_G["PlateBufferInput1"]:ClearFocus()
		_G["PlateBufferInput3"]:ClearFocus()
		_G["PlateBufferInput2"]:ClearFocus()
		_G["PlateBufferInput4"]:ClearFocus()
		_G["PlateBufferInput6"]:ClearFocus()
		_G["PlateBufferInput7"]:ClearFocus()
		_G["PlateBufferInput8"]:ClearFocus()
		_G["PlateBufferInput9"]:ClearFocus()
		_G["PlateBufferInput10"]:ClearFocus()
		_G["PlateBufferInput11"]:ClearFocus()
		_G["PlateBufferInput12"]:ClearFocus()
		
		PBCONF.activeprofile.auraWidth = _G["PlateBufferInput1"]:GetText()
		PBCONF.activeprofile.auraHeight = _G["PlateBufferInput3"]:GetText()
		PBCONF.activeprofile.aurasPerRow =_G["PlateBufferInput2"]:GetText()
		PBCONF.activeprofile.auraRows = _G["PlateBufferInput4"]:GetText()
		PBCONF.activeprofile.auraSpacing = _G["PlateBufferInput6"]:GetText()
		PBCONF.activeprofile.fontSize = _G["PlateBufferInput7"]:GetText()
		PBCONF.activeprofile.fontOffx = _G["PlateBufferInput8"]:GetText()
		PBCONF.activeprofile.fontOffy = _G["PlateBufferInput9"]:GetText()
		PBCONF.activeprofile.auraOffx = _G["PlateBufferInput10"]:GetText()
		PBCONF.activeprofile.auraOffy = _G["PlateBufferInput11"]:GetText()
		PBCONF.activeprofile.borderSize = _G["PlateBufferInput12"]:GetText() or 1
		PBCONF.activeprofile.disableDuration = _G["PlateBufferCheckbox1"]:GetChecked() or false
		PBCONF.activeprofile.disableCooldown = _G["PlateBufferCheckbox2"]:GetChecked() or false

		PBCONF.activeprofile.auraList = {}

		for line in string.gmatch(_G["PlateBufferListEditInput"]:GetText(), "[^\r\n]+") do
			PBCONF.activeprofile.auraList[line] = "mine"

		end

		for line in string.gmatch(_G["PlateBufferListEditInput2"]:GetText(), "[^\r\n]+") do
			PBCONF.activeprofile.auraList[line] = "all"
		end

		ReloadUI()

	end

	local function LoadProfile(profile)
		if PBCONF.profiles[profile] then
			_G["PlateBufferInput1"]:SetText(PBCONF.profiles[profile].auraWidth)
			_G["PlateBufferInput3"]:SetText(PBCONF.profiles[profile].auraHeight)
			_G["PlateBufferInput2"]:SetText(PBCONF.profiles[profile].aurasPerRow)
			_G["PlateBufferInput4"]:SetText(PBCONF.profiles[profile].auraRows)
			_G["PlateBufferInput6"]:SetText(PBCONF.profiles[profile].auraSpacing)
			_G["PlateBufferInput7"]:SetText(PBCONF.profiles[profile].fontSize)
			_G["PlateBufferInput8"]:SetText(PBCONF.profiles[profile].fontOffx)
			_G["PlateBufferInput9"]:SetText(PBCONF.profiles[profile].fontOffy)
			_G["PlateBufferInput10"]:SetText(PBCONF.profiles[profile].auraOffx)
			_G["PlateBufferInput11"]:SetText(PBCONF.profiles[profile].auraOffy)
			_G["PlateBufferInput12"]:SetText(PBCONF.profiles[profile].borderSize or 1)

			-- These will be nil on old installations, but should still work just fine.
			_G["PlateBufferCheckbox1"]:SetChecked(PBCONF.profiles[profile].disableDuration)
			_G["PlateBufferCheckbox2"]:SetChecked(PBCONF.profiles[profile].disableCooldown)
			
			local own = {}
			local all = {}

			-- get aura lists
			for k,v in pairs(PBCONF.profiles[profile].auraList) do
				if v == "all" then
					all[#all+1] = k
				elseif v == "mine" then
					own[#own+1] = k
				end
			end

			table.sort(own)
			table.sort(all)

			_G["PlateBufferListEditInput"]:SetText(table.concat(own, "\n"))
			_G["PlateBufferListEditInput2"]:SetText(table.concat(all, "\n"))
		end
	end

	local function RemoveProfile(profile)
		if PBCONF.profiles[profile] then
			PBCONF.profiles[profile] = nil
			return true
		end

		return false
	end

	local function RenameProfile(oldName, newName)
		local oldGroup = PBCONF.profiles[oldName]

		if not oldGroup or not newName or newName == "" or PBCONF.profiles[newName] or oldName == newName then
			return false
		end

		RemoveProfile(oldName)
		NewProfile(newName)

		oldGroup.name = newName
		local newGroup = PBCONF.profiles[newName]

		for k, v in pairs(oldGroup) do
			newGroup[k] = v
		end

		return true
	end

	-- a dropdown menu item was selected
	local function ProfileDropdown_OnClick()
		local dropdownGroup = _G["PlateBufferDropdownGroup"]

		if GetCurrentKeyBoardFocus() then
			GetCurrentKeyBoardFocus():ClearFocus()
		end

		UIDropDownMenu_SetSelectedValue(dropdownGroup, this.value)
		LoadProfile(this.value)
		SetActiveProfile(this.value)
	end

	-- set up the dropdown choices
	local dropdownGroupItem = {}
	local function ProfileDropdown_Initialize()
		local dropdownGroup = _G["PlateBufferDropdownGroup"]

		local list = {}
		for k,v in pairs(PBCONF.profiles) do
			list[#list+1] = k
		end
		table.sort(list)

		for i, v in pairs(list) do
			dropdownGroupItem.func    = ProfileDropdown_OnClick
			dropdownGroupItem.checked = nil
			dropdownGroupItem.value   = v
			dropdownGroupItem.text    = v
			UIDropDownMenu_AddButton(dropdownGroupItem)
		end
	end

	local function NewButtonClick()
		if not StaticPopupDialogs["PB_POPUP_NEW"] then
			StaticPopupDialogs["PB_POPUP_NEW"] = {
				text = "Enter a name for the new profile:",
				button1 = ACCEPT,
				button2 = CANCEL,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				hasEditBox = true,
				preferredIndex = 3, -- to avoid interferring with Blizzard UI popups

				OnShow = function()
					_G[this:GetName().."EditBox"]:SetText("")
				end,

				OnAccept = function()
					local name = _G[this:GetParent():GetName().."EditBox"]:GetText()
					if NewProfile(name) then
						LoadProfile(name)
						SetActiveProfile(name)
						UIDropDownMenu_Initialize(_G["PlateBufferDropdownGroup"], ProfileDropdown_Initialize)
						UIDropDownMenu_SetSelectedValue(_G["PlateBufferDropdownGroup"], PBCONF.activeprofile.name)
					end
				end,

				EditBoxOnEnterPressed = function()
					StaticPopupDialogs["PB_POPUP_NEW"]:OnAccept()
					this:GetParent():Hide()
				end,

				EditBoxOnEscapePressed = function()
					this:GetParent():Hide()
				end,
			}
		end
		StaticPopup_Show("PB_POPUP_NEW")
	end

	local function RenameButtonClick()
		if not PBCONF.activeprofile or not PBCONF.activeprofile.name then
			return
		end

		-- create the dialog if it doesn't exist yet
		if not StaticPopupDialogs["PB_POPUP_RENAME"] then
			StaticPopupDialogs["PB_POPUP_RENAME"] = {
				text = "Enter a new name for the profile:",
				button1 = ACCEPT,
				button2 = CANCEL,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				hasEditBox = true,
				preferredIndex = 3, -- to avoid interferring with Blizzard UI popups

				OnShow = function()
					_G[this:GetName().."EditBox"]:SetText(PBCONF.activeprofile.name)
				end,

				OnAccept = function()
					local name = _G[this:GetParent():GetName().."EditBox"]:GetText()
					if RenameProfile(PBCONF.activeprofile.name, name) then
						LoadProfile(name)
						SetActiveProfile(name)
						UIDropDownMenu_Initialize(_G["PlateBufferDropdownGroup"], ProfileDropdown_Initialize)
						UIDropDownMenu_SetSelectedValue(_G["PlateBufferDropdownGroup"], PBCONF.activeprofile.name)
					end
				end,

				EditBoxOnEnterPressed = function()
					StaticPopupDialogs["PB_POPUP_RENAME"]:OnAccept()
					this:GetParent():Hide()
				end,

				EditBoxOnEscapePressed = function()
					this:GetParent():Hide()
				end,
			}
		end
		StaticPopup_Show("PB_POPUP_RENAME")
	end

	local function DeleteButtonClick()
		if not PBCONF.activeprofile or not PBCONF.activeprofile.name then
			return
		end

		-- create the dialog if it doesn't exist yet
		if not StaticPopupDialogs["PB_POPUP_REMOVE"] then
			StaticPopupDialogs["PB_POPUP_REMOVE"] = {
				text = "Really delete this profile?",
				button1 = ACCEPT,
				button2 = CANCEL,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				hasEditBox = false,
				preferredIndex = 3, -- to avoid interferring with Blizzard UI popups
				OnAccept = function()
					if RemoveProfile(PBCONF.activeprofile.name) then
						-- get first remaining profile, if none exist, create a new one and load it
						local profile
						for k, v in pairs(PBCONF.profiles) do
							profile = v 
							break
						end

						if not profile then
							profile = NewDefaultProfile()
						end

						LoadProfile(profile.name)
						SetActiveProfile(profile.name)
						UIDropDownMenu_Initialize(_G["PlateBufferDropdownGroup"], ProfileDropdown_Initialize)
						UIDropDownMenu_SetSelectedValue(_G["PlateBufferDropdownGroup"], PBCONF.activeprofile.name)
					end
				end,
			}
		end
		StaticPopup_Show("PB_POPUP_REMOVE")
	end

	

	local function CreateGUI()

		-- main frame
		guiFrame = CreateFrame("frame", "PlateBufferguiFrame", UIParent)
		table.insert(UISpecialFrames, guiFrame:GetName()) -- make it closable with escape key
		guiFrame:SetFrameStrata("HIGH")
		guiFrame:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
			tile = 1,
			tileSize = 32,
			edgeSize = 32,
			insets = {
				left = 11,
				right = 12,
				top = 12,
				bottom = 11
			}
		})

		guiFrame:SetBackdropColor(0, 0, 0, 1)
		guiFrame:SetPoint("CENTER")
		guiFrame:SetWidth(frameWidth)
		guiFrame:SetHeight(frameHeight)
		guiFrame:SetMovable(true)
		guiFrame:EnableMouse(true)
		guiFrame:RegisterForDrag("LeftButton")
		guiFrame:SetScript("OnDragStart", guiFrame.StartMoving)
		guiFrame:SetScript("OnDragStop", guiFrame.StopMovingOrSizing)

		guiFrame:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" and not self.isMoving then
				self:StartMoving()
				self.isMoving = true
			end
		end)

		guiFrame:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" and self.isMoving then
				self:StopMovingOrSizing()
				self.isMoving = false
			end
		end)

		guiFrame:SetScript("OnHide", function(self)
			if self.isMoving then
				self:StopMovingOrSizing()
				self.isMoving = false
			end
		end)

		guiFrame:SetScript("OnShow", function()
			LoadProfile(PBCONF.activeprofile.name)
			UIDropDownMenu_Initialize(_G["PlateBufferDropdownGroup"], ProfileDropdown_Initialize)
			UIDropDownMenu_SetSelectedValue(_G["PlateBufferDropdownGroup"], PBCONF.activeprofile.name)
		end)

		guiFrame:Hide()


		-- header
		local textureHeader = guiFrame:CreateTexture(nil, "ARTWORK")
		textureHeader:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
		textureHeader:SetWidth(315)
		textureHeader:SetHeight(64)
		textureHeader:SetPoint("TOP", 0, 12)
		local textHeader = guiFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		textHeader:SetPoint("TOP", textureHeader, "TOP", 0, -14)
		textHeader:SetText("PlateBuffer")


		-- Profile settings

		local dropdownGroup = CreateFrame("frame", "PlateBufferDropdownGroup", guiFrame, "UIDropDownMenuTemplate")
		dropdownGroup:SetPoint("TOPLEFT", guiFrame, "TOPLEFT", 5, -42)
		UIDropDownMenu_SetWidth(160, dropdownGroup)

		local textDescription = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		textDescription:SetPoint("BOTTOMLEFT", dropdownGroup, "TOPLEFT", 18, 3)
		textDescription:SetText("Profile")

		local buttonRename = CreateFrame("Button", "PlateBufferButtonRename", guiFrame, "UIPanelButtonTemplate")
		buttonRename:SetWidth(115)
		buttonRename:SetHeight(24)
		--buttonRename:SetPoint("TOPLEFT", buttonNew, "TOPRIGHT", 2, 0)
		buttonRename:SetPoint("TOPLEFT", dropdownGroup, "TOPRIGHT", -10, 0)
		_G[buttonRename:GetName().."Text"]:SetText("Rename profile")
		buttonRename:SetScript("OnClick", RenameButtonClick)

		local buttonDelete = CreateFrame("Button", "PlateBufferButtonDelete", guiFrame, "UIPanelButtonTemplate")
		buttonDelete:SetWidth(115)
		buttonDelete:SetHeight(24)
		buttonDelete:SetPoint("TOPLEFT", buttonRename, "TOPRIGHT", 2, 0)
		_G[buttonDelete:GetName().."Text"]:SetText("Delete profile")
		buttonDelete:SetScript("OnClick", DeleteButtonClick)

		local buttonNew = CreateFrame("Button", "PlateBufferButtonNew", guiFrame, "UIPanelButtonTemplate")
		buttonNew:SetWidth(115)
		buttonNew:SetHeight(24)
		buttonNew:SetPoint("TOPLEFT", dropdownGroup, "TOPRIGHT", -10, -25)
		_G[buttonNew:GetName().."Text"]:SetText("New profile")
		buttonNew:SetScript("OnClick", NewButtonClick)

		local buttonApply = CreateFrame("Button", "PlateBufferButtonApply", guiFrame, "UIPanelButtonTemplate")
		buttonApply:SetWidth(115)
		buttonApply:SetHeight(24)
		buttonApply:SetPoint("TOPLEFT", buttonNew, "TOPRIGHT", 2, 0)
		_G[buttonApply:GetName().."Text"]:SetText("Apply settings")
		buttonApply:SetScript("OnClick", ApplySettings)

		-- separator 1
		local lineSeparator1 = guiFrame:CreateTexture()
		lineSeparator1:SetTexture(.4, .4, .4)
		lineSeparator1:SetPoint("TOP", guiFrame, "TOP", 0, 0-(guiFrame:GetTop()-buttonNew:GetBottom())-8)
		lineSeparator1:SetWidth(guiFrame:GetWidth()-36)
		lineSeparator1:SetHeight(2)

		-- AURA CONFIG

		local group1Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		group1Label:SetPoint("TOPLEFT", lineSeparator1, "BOTTOMLEFT", 6, -8)
		group1Label:SetText("Aura frame")


		-- Frame Offset x
		local input10 = CreateFrame("EditBox", "PlateBufferInput10", guiFrame, "InputBoxTemplate")
		input10:SetWidth(32)
		input10:SetHeight(12)
		input10:SetPoint("TOP", lineSeparator1, "BOTTOM", 35, -8)
		--input10:SetNumeric(true)
		input10:SetMaxLetters(3)
		input10:SetAutoFocus(false)
		input10:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input10:SetScript("OnEditFocusLost", function()
			local value = tonumber(input10:GetText())
			if not value then
				value = 1
				input10:SetText(value)
			end
		end)

		local input10Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input10Label:SetPoint("RIGHT", input10, "LEFT", -15, 0)
		input10Label:SetText("Frame x-offset")


		-- Frame Offset Y
		local input11 = CreateFrame("EditBox", "PlateBufferInput11", guiFrame, "InputBoxTemplate")
		input11:SetWidth(32)
		input11:SetHeight(12)
		input11:SetPoint("TOPRIGHT", lineSeparator1, "BOTTOMRIGHT", -10, -8)
		--input11:SetNumeric(true)
		input11:SetMaxLetters(3)
		input11:SetAutoFocus(false)
		input11:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input11:SetScript("OnEditFocusLost", function()
			local value = tonumber(input11:GetText())
			if not value then
				value = 1
				input11:SetText(value)
			end
		end)

		local input11Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input11Label:SetPoint("RIGHT", input11, "LEFT", -15, 0)
		input11Label:SetText("Frame y-offset")


		-- Per Row
		local input2 = CreateFrame("EditBox", "PlateBufferInput2", guiFrame, "InputBoxTemplate")
		input2:SetWidth(32)
		input2:SetHeight(12)
		input2:SetPoint("TOP", input10, "BOTTOM", 0, -12)
		input2:SetNumeric(true)
		input2:SetMaxLetters(2)
		input2:SetAutoFocus(false)
		input2:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input2:SetScript("OnEditFocusLost", function()
			local value = tonumber(input2:GetText())
			if not value or value < 1 then
				value = 1
			elseif value > 10 then
				value = 10
			end
			input2:SetText(value)
		end)

		local input2Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input2Label:SetPoint("RIGHT", input2, "LEFT", -15, 0)
		input2Label:SetText("Auras Per Row")


		-- num rows
		local input4 = CreateFrame("EditBox", "PlateBufferInput4", guiFrame, "InputBoxTemplate")
		input4:SetWidth(32)
		input4:SetHeight(12)
		input4:SetPoint("TOP", input11, "BOTTOM", 0, -12)
		input4:SetNumeric(true)
		input4:SetMaxLetters(3)
		input4:SetAutoFocus(false)
		input4:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input4:SetScript("OnEditFocusLost", function()
			local value = tonumber(input4:GetText())
			if not value or value < 1 or value > 6 then
				value = 1
				input4:SetText(value)
			end
		end)

		local input4Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input4Label:SetPoint("RIGHT", input4, "LEFT", -15, 0)
		input4Label:SetText("Number of Rows")


		-- Group Separator 1
		local groupSeparator1 = guiFrame:CreateTexture()
		groupSeparator1:SetTexture(.4, .4, .4)
		groupSeparator1:SetPoint("TOP", guiFrame, "TOP", 0, -160)
		groupSeparator1:SetWidth(guiFrame:GetWidth()-36)
		groupSeparator1:SetHeight(2)
		

		local group2Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		group2Label:SetPoint("TOPLEFT", groupSeparator1, "BOTTOMLEFT", 6, -6)
		group2Label:SetText("Aura icon")


		-- Aura Height
		local input3 = CreateFrame("EditBox", "PlateBufferInput3", guiFrame, "InputBoxTemplate")
		input3:SetWidth(32)
		input3:SetHeight(12)
		input3:SetPoint("TOP", groupSeparator1, "BOTTOM", 35, -8)
		input3:SetNumeric(true)
		input3:SetMaxLetters(2)
		input3:SetAutoFocus(false)
		input3:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input3:SetScript("OnEditFocusLost", function()
			local value = tonumber(input3:GetText())
			if not value or value < 4 then
				value = 4
				input3:SetText(value)
			end
		end)

		local input3Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input3Label:SetPoint("RIGHT", input3, "LEFT", -15, 0)
		input3Label:SetText("Aura height")

		-- Aura Width
		local input1 = CreateFrame("EditBox", "PlateBufferInput1", guiFrame, "InputBoxTemplate")
		input1:SetWidth(32)
		input1:SetHeight(12)
		input1:SetPoint("TOPRIGHT", groupSeparator1, "BOTTOMRIGHT", -10, -8)
		input1:SetNumeric(true)
		input1:SetMaxLetters(2)
		input1:SetAutoFocus(false)
		input1:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input1:SetScript("OnEditFocusLost", function()
			local value = tonumber(input1:GetText())
			if not value or value < 4 then
				value = 4
				input1:SetText(value)
			end
		end)

		local input1Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input1Label:SetPoint("RIGHT", input1, "LEFT", -15, 0)
		input1Label:SetText("Aura width")


		-- Border Size
		local input12 = CreateFrame("EditBox", "PlateBufferInput12", guiFrame, "InputBoxTemplate")
		input12:SetWidth(32)
		input12:SetHeight(12)
		input12:SetPoint("TOP", input3, "BOTTOM", 0, -8)
		input12:SetNumeric(true)
		input12:SetMaxLetters(2)
		input12:SetAutoFocus(false)
		input12:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input12:SetScript("OnEditFocusLost", function()
			local value = tonumber(input12:GetText())
			if not value then
				value = 1
				input12:SetText(value)
			end
		end)

		local input6Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input6Label:SetPoint("RIGHT", input12, "LEFT", -15, 0)
		input6Label:SetText("Border Size")

		-- Aura Spacing
		local input6 = CreateFrame("EditBox", "PlateBufferInput6", guiFrame, "InputBoxTemplate")
		input6:SetWidth(32)
		input6:SetHeight(12)
		input6:SetPoint("TOP", input1, "BOTTOM", 0, -8)
		input6:SetNumeric(true)
		input6:SetMaxLetters(2)
		input6:SetAutoFocus(false)
		input6:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input6:SetScript("OnEditFocusLost", function()
			local value = tonumber(input6:GetText())
			if not value then
				value = 1
				input6:SetText(value)
			end
		end)

		local input6Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input6Label:SetPoint("RIGHT", input6, "LEFT", -15, 0)
		input6Label:SetText("Aura Spacing")


		-- Disable cooldown texture
		local checkbox2 = CreateFrame("CheckButton", "PlateBufferCheckbox2", guiFrame, "UICheckButtonTemplate")
		checkbox2:SetPoint("TOPRIGHT", input6, "BOTTOMRIGHT", 5, -2)
		
		local checkbox2Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		checkbox2Label:SetPoint("RIGHT", checkbox2, "LEFT", -2, 2)
		checkbox2Label:SetText("Disable cooldown texture")
		


		-- Group Separator 2
		local groupSeparator2 = guiFrame:CreateTexture()
		groupSeparator2:SetTexture(.4, .4, .4)
		groupSeparator2:SetPoint("TOP", guiFrame, "TOP", 0, -235)
		groupSeparator2:SetWidth(guiFrame:GetWidth()-36)
		groupSeparator2:SetHeight(2)
		
		local group3Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		group3Label:SetPoint("TOPLEFT", groupSeparator2, "BOTTOMLEFT", 6, -6)
		group3Label:SetText("Aura text")


		-- Font Offset x
		local input8 = CreateFrame("EditBox", "PlateBufferInput8", guiFrame, "InputBoxTemplate")
		input8:SetWidth(32)
		input8:SetHeight(12)
		input8:SetPoint("TOP", groupSeparator2, "BOTTOM", 35, -8)
		--input8:SetNumeric(true)
		input8:SetMaxLetters(3)
		input8:SetAutoFocus(false)
		input8:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input8:SetScript("OnEditFocusLost", function()
			local value = tonumber(input8:GetText())
			if not value then
				value = 1
				input8:SetText(value)
			end
		end)

		local input8Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input8Label:SetPoint("RIGHT", input8, "LEFT", -15, 0)
		input8Label:SetText("Font x-offset")


		-- Font Offset y
		local input9 = CreateFrame("EditBox", "PlateBufferInput9", guiFrame, "InputBoxTemplate")
		input9:SetWidth(32)
		input9:SetHeight(12)
		input9:SetPoint("TOPRIGHT", groupSeparator2, "BOTTOMRIGHT", -10, -8)
		--input9:SetNumeric(true)
		input9:SetMaxLetters(3)
		input9:SetAutoFocus(false)
		input9:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input9:SetScript("OnEditFocusLost", function()
			local value = tonumber(input9:GetText())
			if not value then
				value = 1
				input9:SetText(value)
			end
		end)

		local input9Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input9Label:SetPoint("RIGHT", input9, "LEFT", -15, 0)
		input9Label:SetText("Font y-offset")


		-- FontSize
		local input7 = CreateFrame("EditBox", "PlateBufferInput7", guiFrame, "InputBoxTemplate")
		input7:SetWidth(32)
		input7:SetHeight(12)
		input7:SetPoint("TOP", input9, "BOTTOM", 0, -12)
		input7:SetNumeric(true)
		input7:SetMaxLetters(2)
		input7:SetAutoFocus(false)
		input7:SetScript("OnEnterPressed", function() this:ClearFocus() end)
		input7:SetScript("OnEditFocusLost", function()
			local value = tonumber(input7:GetText())
			if not value or value < 4 then
				input7:SetText(4)
			end
		end)

		local input7Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		input7Label:SetPoint("RIGHT", input7, "LEFT", -15, 0)
		input7Label:SetText("Font Size")


		-- Disable duration text
		local checkbox1 = CreateFrame("CheckButton", "PlateBufferCheckbox1", guiFrame, "UICheckButtonTemplate")
		checkbox1:SetPoint("TOPRIGHT", input8, "BOTTOMRIGHT", 5, -2)

		local checkbox1Label = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		checkbox1Label:SetPoint("RIGHT", checkbox1, "LEFT", -2, 2)
		checkbox1Label:SetText("Disable duration text")

		-- separator 2
		local lineSeparator2 = guiFrame:CreateTexture()
		lineSeparator2:SetTexture(.4, .4, .4)
		lineSeparator2:SetPoint("TOP", guiFrame, "TOP", 0, -302)
		lineSeparator2:SetWidth(guiFrame:GetWidth()-36)
		lineSeparator2:SetHeight(2)
		

		-- edit box
		local editBox = CreateFrame("Frame", "PlateBufferListEdit", guiFrame)
		local editBoxInput = CreateFrame("EditBox", "PlateBufferListEditInput", editBox)
		local editBoxScroll = CreateFrame("ScrollFrame", "PlateBufferListEditScroll", editBox, "UIPanelScrollFrameTemplate")

		-- editbox label
		local editboxLabel = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		editboxLabel:SetPoint("BOTTOM", editBox, "TOP", 0, 3)
		editboxLabel:SetText("Auras by you")

		-- editBox - main container
		editBox:SetPoint("TOP", lineSeparator2, "BOTTOM", -10, -26)
		editBox:SetPoint("BOTTOM", guiFrame, "BOTTOM", 0, 15)
		editBox:SetPoint("LEFT", guiFrame, "LEFT", 15, 0)
		--editBox:SetPoint("RIGHT", guiFrame, "RIGHT", -34, 0)
		editBox:SetWidth(listWidth)

		editBox:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
			tile = 1,
			tileSize = 32,
			edgeSize = 16,
			insets = { 
				left = 5,
				right = 5,
				top = 5,
				bottom = 5
			}
		})
		editBox:SetBackdropColor(0, 0, 0, 1)

		editBoxInput:SetWidth(editBox:GetWidth()-20)
		editBoxInput:SetHeight(editBox:GetHeight()-30)
		editBoxInput:SetMultiLine(true)
		editBoxInput:SetAutoFocus(false)
		editBoxInput:EnableMouse(true)
		editBoxInput:SetFont("Fonts/ARIALN.ttf", 13)
		editBoxInput:SetScript("OnEscapePressed", function() editBoxInput:ClearFocus() end)

		-- editBoxScroll
		editBoxScroll:SetPoint("TOPLEFT", editBox, "TOPLEFT", 9, -4)
		editBoxScroll:SetPoint("BOTTOMRIGHT", editBox, "BOTTOMRIGHT", -5, 4)
		editBoxScroll:EnableMouse(true)
		editBoxScroll:SetScript("OnMouseDown", function() editBoxInput:SetFocus() end)
		editBoxScroll:SetScrollChild(editBoxInput)

		-- taken from Blizzard's macro UI XML to handle scrolling
		editBoxInput:SetScript("OnTextChanged", function()
			local scrollbar = _G[editBoxScroll:GetName() .. "ScrollBar"]
			local min, max = scrollbar:GetMinMaxValues()
			if max > 0 and this.max ~= max then
				this.max = max
				scrollbar:SetValue(max)
			end
		end)

		editBoxInput:SetScript("OnUpdate", function(this)
			ScrollingEdit_OnUpdate(editBoxScroll)
		end)

		editBoxInput:SetScript("OnCursorChanged", function()
			ScrollingEdit_OnCursorChanged(arg1, arg2, arg3, arg4)
		end)


		-- editBox2
		local editBox2 = CreateFrame("Frame", "PlateBufferListEdit2", guiFrame)
		local editBox2Input = CreateFrame("EditBox", "PlateBufferListEditInput2", editBox2)
		local editBox2Scroll = CreateFrame("ScrollFrame", "PlateBufferListEditScroll2", editBox2, "UIPanelScrollFrameTemplate")

		-- editbox label
		local editboxLabel2 = guiFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		editboxLabel2:SetPoint("BOTTOM", editBox2, "TOP", 0, 3)
		editboxLabel2:SetText("Auras by anyone")

		-- editBox2 - main container
		editBox2:SetPoint("TOP", lineSeparator2, "BOTTOM", -10, -26)
		editBox2:SetPoint("BOTTOM", guiFrame, "BOTTOM", 0, 15)
		--editBox2:SetPoint("LEFT", editBox, "RIGHT", 15, 0)
		editBox2:SetPoint("RIGHT", guiFrame, "RIGHT", -34, 0)
		editBox2:SetWidth(listWidth)
		
		editBox2:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
			tile = 1,
			tileSize = 32,
			edgeSize = 16,
			insets = {
				left = 5,
				right = 5,
				top = 5,
				bottom = 5
			}
		})
		editBox2:SetBackdropColor(0, 0, 0, 1)

		editBox2Input:SetWidth(editBox2:GetWidth()-20)
		editBox2Input:SetHeight(editBox2:GetHeight()-30)
		editBox2Input:SetMultiLine(true)
		editBox2Input:SetAutoFocus(false)
		editBox2Input:EnableMouse(true)
		editBox2Input:SetFont("Fonts/ARIALN.ttf", 13)
		editBox2Input:SetScript("OnEscapePressed", function() editBox2Input:ClearFocus() end)

		-- editBox2Scroll
		editBox2Scroll:SetPoint("TOPLEFT", editBox2, "TOPLEFT", 9, -4)
		editBox2Scroll:SetPoint("BOTTOMRIGHT", editBox2, "BOTTOMRIGHT", -5, 4)
		editBox2Scroll:EnableMouse(true)
		editBox2Scroll:SetScript("OnMouseDown", function() editBox2Input:SetFocus() end)
		editBox2Scroll:SetScrollChild(editBox2Input)

		-- taken from Blizzard's macro UI XML to handle scrolling
		editBox2Input:SetScript("OnTextChanged", function()
			local scrollbar = _G[editBox2Scroll:GetName() .. "ScrollBar"]
			local min, max = scrollbar:GetMinMaxValues()
			if max > 0 and this.max ~= max then
				this.max = max
				scrollbar:SetValue(max)
			end
		end)

		editBox2Input:SetScript("OnUpdate", function(this)
			ScrollingEdit_OnUpdate(editBox2Scroll)
		end)

		editBox2Input:SetScript("OnCursorChanged", function()
			ScrollingEdit_OnCursorChanged(arg1, arg2, arg3, arg4)
		end)

		-- close button
		local buttonClose = CreateFrame("Button", "PlateBufferListButtonClose", guiFrame, "UIPanelCloseButton")
		buttonClose:SetPoint("TOPRIGHT", guiFrame, "TOPRIGHT", -8, -8)
		buttonClose:SetScript("OnClick", function()
			editBoxInput:ClearFocus()
			editBox2Input:ClearFocus()
			guiFrame:Hide()
		end)

	end



	---------------------------------------------------------------------------------------------

	local f = CreateFrame("Frame")
	f:SetScript("OnEvent", function(self, event, addon)
		if event == "ADDON_LOADED" and addon == "PlateBuffer" then
			f:UnregisterEvent(event)

			local realm, player = GetRealmName(), UnitName("player")
			
			if not PBCONF then
				PBCONF = {}
				PBCONF.profiles = {}
				NewDefaultProfile()
				PBCONF.playerprofiles = {}
			end

			if not PBCONF.playerprofiles[realm] then
				PBCONF.playerprofiles[realm] = {}
			end

			-- yikes
			if PBCONF.playerprofiles[realm][player] and PBCONF.profiles[PBCONF.playerprofiles[realm][player]] then
				PBCONF.activeprofile = PBCONF.profiles[PBCONF.playerprofiles[realm][player]]
			else
				if not PBCONF.profiles["default"] then
					NewDefaultProfile()
				end
				SetActiveProfile("default")
			end
		end
	end)
	f:RegisterEvent("ADDON_LOADED")

	SLASH_PLATEBUFFER1 = "/pb"
	SLASH_PLATEBUFFER2 = "/platebuffer"
	SlashCmdList.PLATEBUFFER = function()
		if not guiFrame then
			CreateGUI()
		end
		guiFrame:Show()
	end
