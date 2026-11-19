this.nggh_mod_egg_rider <- ::inherit("scripts/skills/nggh_mod_rider_skill", {
	m = {},
	function create()
	{
		this.nggh_mod_rider_skill.create();
		this.m.ID = "special.egg_rider";
		this.m.Name = "На прогулке";
		this.m.Description = "На что вы смотрите? Никогда не видели людей, верхом на яйцах?";
		this.m.Icon = "skills/status_effect_eggs.png";
		this.m.IconMini = "status_effect_eggs_mini";
	}

	function getDescription()
	{
		if (this.getManager() == null)
		{
			return this.m.Description;
		}
		
		return "Вы едете верхом на [color=#1e468f]" + this.getManager().getMount().getName() + "[/color]! В этом есть свои преимущества, например, подвижность. А в довершение всего, это ещё одна жизнь, о которой вы должны заботиться.";
	}
	
	function onAfterUpdate( _properties )
	{
		this.nggh_mod_rider_skill.onAfterUpdate(_properties);

		if (this.isMounted())
		{
			local stats = {
				MeleeSkill = 0,
				RangedSkill = 0
			};
			local mount = this.m.Manager.getMount();

			if (::Is_AccessoryCompanions_Exist || ("getAttributes" in mount.get()))
			{
				stats = mount.getAttributes();
			}
			else 
			{
			    stats = ::Const.Tactical.Actor[::Const.GoblinRiderMounts[this.getMountType()].Attributes];
			}
			
			_properties.MeleeSkill += stats.MeleeSkill;
			_properties.RangedSkill += stats.RangedSkill;
			_properties.MeleeDefense += 50;
			_properties.IsRooted = false;
		}
	}

	function onUpdate( _properties )
	{
		this.nggh_mod_rider_skill.onUpdate(_properties);

		if (!this.isMounted())
		{
			return;
		}

		_properties.Stamina += 10;
		_properties.Initiative += 65;
		_properties.RangedDefense -= 10;
	}

	function setTemporarySpiderMount( _spider, _item = null )
	{
		local b = _spider.getBaseProperties();
		local stats = {
			HitpointsPct = _spider.getHitpointsPct(),
			HitpointsMax = ::Math.floor(b.Hitpoints * (b.HitpointsMult >= 0 ? b.HitpointsMult : 1.0 / b.HitpointsMult)),
			//Bravery = b.getBravery(),
			//Stamina = this.Math.floor(b.Bravery * (b.BraveryMult >= 0 ? b.BraveryMult : 1.0 / b.BraveryMult)),
			//MeleeSkill = b.getMeleeSkill(),
			//RangedSkill = 0,
			//MeleeDefense = b.getMeleeDefense(),
			//RangedDefense = b.getRangedDefense(),
			//Initiative = b.getInitiative(),
			Armor = [ 
				::Math.floor(b.Armor[0] * (b.ArmorMult[0] >= 0 ? b.ArmorMult[0] : 1.0 / b.ArmorMult[0])),
				::Math.floor(b.Armor[1] * (b.ArmorMult[1] >= 0 ? b.ArmorMult[1] : 1.0 / b.ArmorMult[0])),
			],
			ArmorMax = [ 
				::Math.floor(b.ArmorMax[0] * (b.ArmorMult[0] >= 0 ? b.ArmorMult[0] : 1.0 / b.ArmorMult[0])),
				::Math.floor(b.ArmorMax[1] * (b.ArmorMult[1] >= 0 ? b.ArmorMult[1] : 1.0 / b.ArmorMult[1])),
			],
		};

		/*if (::Is_AccessoryCompanions_Exist && _item != null)
		{
			_item.m.Attributes.Hitpoints = stats.HitpointsMax;
			_item.m.Attributes.Stamina = stats.Stamina;
			_item.m.Attributes.Bravery = stats.Bravery;
			_item.m.Attributes.Initiative = stats.Initiative;
			_item.m.Attributes.MeleeSkill = stats.MeleeSkill; 
			_item.m.Attributes.RangedSkill = stats.RangedSkill;
			_item.m.Attributes.MeleeDefense = stats.MeleeDefense;
			_item.m.Attributes.RangedDefense = stats.RangedDefense;
		}*/

		this.m.Manager.applyingAttributes(stats);
	}

});

