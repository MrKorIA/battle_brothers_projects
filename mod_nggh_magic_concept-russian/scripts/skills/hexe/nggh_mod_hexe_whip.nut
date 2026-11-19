this.nggh_mod_hexe_whip <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.hexe_whip";
		this.m.Name = "Подстегнуть";
		this.m.Description = "Напомнить своему простаку о том, кто его мамочка, устроив ему хорошую порку, чтобы он отдал вам все свои силы. 'Всегда слушай свою мамочку'.";
		this.m.KilledString = "Захлёстан до смерти";
		this.m.Icon = "skills/active_214.png";
		this.m.IconDisabled = "skills/active_214_sw.png";
		this.m.Overlay = "active_214";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/whip_slave_01.wav",
			"sounds/combat/dlc6/whip_slave_02.wav",
			"sounds/combat/dlc6/whip_slave_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Наносит [color=" + ::Const.UI.Color.DamageValue + "]2[/color] - [color=" + ::Const.UI.Color.DamageValue + "]5[/color] урона, игнорирующего броню цели."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] клеток"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Накладывает на выбранного простака статусный эффект 'Подстёгнут', увеличивающий многие его характеристики на 2 хода. Чем выше уровень простака-цели, тем больше прирост."
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снимает эффект [color=" + ::Const.UI.Color.NegativeValue + "]Очарован[/color] с выбранного простака"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Восстанавливает боевой дух выбранного простака до 'уравновешенного', если он был ниже"
			},
		];

		if (this.isUpgraded())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Повышен при помощи навыка '[color=" + ::Const.UI.Color.PositiveValue + "]" + ::Const.Strings.PerkName.NggH_BDSM_DommyMommy + "[/color]'"
			})
		}

		return ret;
	}

	function getWhip()
	{
		local main = this.getContainer().getActor().getMainhandItem();

		if (main == null || !main.isWeaponType(::Const.Items.WeaponType.Whip))
			return null;

		return main;
	}

	function isEquippedWithWhip()
	{
		return this.getWhip() != null;
	}

	function isHidden()
	{
		return this.skill.isHidden() || !this.isEquippedWithWhip();
	}

	function isUpgraded()
	{
		return this.getContainer().hasSkill("perk.bdsm_dommy_mommy");
	}

	function onUpdate( _properties )
	{
		local w = this.getWhip();
		this.m.MaxRange = w == null ? 1 : w.getRangeMax();
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCleavers ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		return _targetTile.getEntity().getSkills().hasSkill("effects.simp");
	}

	function onUse( _user, _targetTile )
	{
		local t = _targetTile.getEntity();
		local upgraded = this.isUpgraded();
		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = ::Math.rand(2, 5);
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		t.onDamageReceived(_user, this, hitInfo);

		if (upgraded)
			_user.checkMorale(1, 9000);

		if (t.isAlive() && !t.isDying())
		{
			local n = t.getSkills().getSkillByID("effects.simp").getSimpLevel();

			if (upgraded)
				n += 3;

			t.getSkills().removeByID("effects.charmed");
			t.getSkills().removeByID("effects.legend_intensely_charmed");

			if (t.getSkills().hasSkill("effects.whipped"))
			{
				local s = t.getSkills().getSkillByID("effects.whipped");
				s.onRefresh();
				s.setLevel(n);
				t.getSkills().update();
			}
			else
			{
				local s = ::new("scripts/skills/effects/whipped_effect");
				s.getDescription = function()
				{
					return "Этот персонаж только что получил согревающее напоминание о том, что он должен сделать для своей мамочки. Эффект будет длиться ещё " + this.m.TurnsLeft + " ход(а,ов).";
				};
				s.setLevel(n);
				t.getSkills().add(s);
			}

			if (t.getMoraleState() < ::Const.MoraleState.Steady)
				t.setMoraleState(::Const.MoraleState.Steady);
		}

		return true;
	}

});

