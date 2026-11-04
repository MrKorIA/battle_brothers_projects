this.nomad_fireblunderbuss <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.NomadFireBlunderbuss;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.NomadFireBlunderbuss.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.BeardChance = 30;
		this.m.Ethnicity = 1;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/military_gunner_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.NomadFireBlunderbuss);
		b.TargetAttractionMult = 1.1;
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInCrossbows = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.m.Skills.add(this.new("scripts/skills/perks/perk_bullseye"));		
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_quick_hands"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"))
	}

	function onOtherActorDeath( _killer, _victim, _skill )
	{
		if (_victim.getType() == this.Const.EntityType.Slave && _victim.isAlliedWith(this))
		{
			return;
		}

		this.actor.onOtherActorDeath(_killer, _victim, _skill);
	}

	function onOtherActorFleeing( _actor )
	{
		if (_actor.getType() == this.Const.EntityType.Slave && _actor.isAlliedWith(this))
		{
			return;
		}

		this.actor.onOtherActorFleeing(_actor);
	}

	function assignRandomEquipment()
	{
		local r;
		local banner = 3;
		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/jinweapon11"));
		}
		else if (r == 2)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/jinweapon11"));
		}

		this.m.Items.equip(this.new("scripts/items/weapons/jinweapon10"));
		this.m.Items.equip(this.new("scripts/items/ammo/powder_bag"));
		this.m.Items.equip(this.new("scripts/items/armor/oriental2_armor"));
		local helmet = this.new("scripts/items/helmets/tiefutu3_helmet");
		this.m.Items.equip(helmet);
	}

	function onPlacedOnMap()
	{
		this.actor.onPlacedOnMap();
	    local isSpawnBarrel = false;

        if (this.Math.rand(1, 90) <= 30)
        {
            local mapSize = ::Tactical.getMapSize();
            local width = mapSize.X - 1;
            local height = mapSize.Y - 1;

            for (local x = 1; x < width; x++)
            {
                for (local y = 1; y < height; y++)
                {
                    local tile = ::Tactical.getTileSquare(x, y);
                    if (!tile.IsEmpty && ::isKindOf(tile.getEntity(), "jin_camp_supplies"))
                    {
                        isSpawnBarrel = true;
                        break;
                    }
                }
                if (isSpawnBarrel) break;
            }

            if (isSpawnBarrel)
            {

                local barrel = {
                    ID = this.Const.EntityType.CaravanDonkey,
                    Variant = 0,
                    Script = "scripts/entity/tactical/objective/barrel_of_gunpowder",
                    Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getID(),
                    Callback = null
                }

                ::Tactical.Entities.spawnEntitiesAtCenter([barrel]);
            }
		}
    }

});

