::Nggh_MagicConcept.HooksMod.hook("scripts/items/tools/faction_banner", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.ID = "weapon.player_banner";
		m.Description = "Штандарт благородного дома, который можно взять с собой в бой. Держа его высоко, союзники сплотятся вокруг него с новой решимостью, а враги будут хорошо знать, кто собирается их сокрушить.";
		m.IsIndestructible = true;
		m.Condition = 1.0;
		m.ConditionMax = 1.0;

		setWeaponType(::Const.Items.WeaponType.Polearm);
	}

	q.onEquip = @(__original) function()
	{
		__original();
		addSkill(::new("scripts/skills/actives/repel"));
		m.IsDroppedAsLoot = !::MSU.isNull(getContainer()) && !::MSU.isNull(getContainer().getActor()) && ::MSU.isKindOf(getContainer().getActor(), "player");
	}

	q.onUnequip <- function()
	{
		local actor = getContainer().getActor();

		if (::MSU.isNull(actor))
			return;

		if (actor.hasSprite("background"))
			actor.getSprite("background").resetBrush();

		if (actor.hasSprite("shaft"))
			actor.getSprite("shaft").resetBrush();

		actor.setDirty(true);
		weapon.onUnequip();
	}

	q.updateVariant <- function()
	{
		local variant = m.Variant < 10 ? "0" + m.Variant : m.Variant;
		m.IconLarge = "weapons/faction_banner/faction_banner_" + variant + ".png";
		m.Icon = "weapons/faction_banner/faction_banner_" + variant + "_70x70.png";
	}

	q.setVariant <- function( _v )
	{
		local houseName = "";
		if (("State" in ::Tactical) && !::MSU.isNull(::Tactical.State) && !::Tactical.State.isScenarioMode()) {
			foreach ( house in ::World.FactionManager.getFactionsOfType(::Const.FactionType.NobleHouse) )
			{
				if (house.getBanner() == _v) {
					houseName = house.getName();
					break;
				}
			}
		}
		
		if (houseName.len() == 0)
			houseName = "благородного дома";
		
		m.Variant = _v;
		setName(format("Боевой штандарт %s", houseName));
		updateVariant();
	}

	q.setName <- function( _name )
	{
		m.Name = _name;
	}

	q.getTooltip <- function()
	{
		local result = weapon.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Союзники в радиусе 4-х клеток получают бонус к решимости, составляющий [color=" + ::Const.UI.Color.PositiveValue + "]10%[/color] от максимального показателя решимости знаменосца."
		});
		return result;
	}

	q.getBuyPrice = @() function()
	{
		return 1000000;
	}

	q.onSerialize <- function( _out )
	{
		_out.writeString(m.Name);
		weapon.onSerialize(_out);
	}

	q.onDeserialize <- function( _in )
	{
		m.Name = _in.readString();
		weapon.onDeserialize(_in);
	}
	
});
