this.xxhero_female_background <- this.inherit("scripts/skills/backgrounds/xxhero_background", {
	m = {},
	function create()
	{
		this.xxhero_background.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
		this.m.Names = this.Const.Strings.CharacterNamesFemale;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local xbody = actor.getSprite("body");
		local xhead = actor.getSprite("head");
		local xhair = actor.getSprite("hair");
		xbody.setBrush("bust_naked_body_78" + this.Math.rand(69, 70));
		xhead.setBrush("bust_head_787" + this.Math.rand(0, 1));
		local zxtype = this.Math.rand(0, 5);
	  if (zxtype == 1) // pyro
	  {
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local pp;
		local hair_color = [
			"grey",
			"blonde",
			"brown",
			"red"
		];
		hair_color = hair_color[this.Math.rand(0, hair_color.len() - 1)]
		local hair_type = [
			"03",
			"08",
			"21"
		];
		hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
		xhair.setBrush("hair_" + hair_color + "_" + hair_type);
		pp = this.Math.rand(1, 2)
		if (pp == 1)
		{
			tattoo_body.setBrush("tattoo_03_bust_naked_body_00");
			tattoo_head.setBrush("tattoo_0" + this.Math.rand(1, 2) + "_head");
		}
		else
		if (pp == 2)
		{
			tattoo_body.setBrush("warpaint_01_bust_naked_body_00");
			tattoo_head.setBrush("warpaint_01_head");
		}
		pp = this.Math.rand(1, 2)
		if (pp == 1)
		{
			xhair.Color = this.createColor("#ff6a00");
			xhair.Saturation = 1.5;
			tattoo_head.Color = this.createColor("#ff0000");
			tattoo_head.Saturation = 3.5;
			tattoo_head.Visible = true;
			tattoo_body.Color = this.createColor("#ff0000");
			tattoo_body.Saturation = 3.5;
			tattoo_body.Visible = true;
			tattoo_body.Scale = 0.9;
		}
		actor.setSpriteOffset("tattoo_body", this.createVec(0, -4));
		actor.setAlwaysApplySpriteOffset(true);
	  }
	  else if (zxtype == 2) // umbra
	  {
		local tattoo_head = actor.getSprite("tattoo_head");
		local tattoo_body = actor.getSprite("tattoo_body");
		local hair_color = this.Const.HairColors.Zombie[this.Math.rand(0, 1)]

		if (this.Math.rand(1, 2) == 1)
		{
			xhead.Color = this.createColor("#595350");
			xhead.Saturation = 0.5;
		}
		else
		{
			xhead.Color = this.createColor("#784b2f");
			xhead.Saturation = 0.9;
		}
		xbody.Color = xhead.Color;
		xbody.Saturation = xhead.Saturation;
		if (this.Math.rand(1, 2) == 1)
		{
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_body.setBrush("warpaint_01_bust_naked_body_00");
		}
		else
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_body.setBrush("scar_02_bust_naked_body_00");
		}
		tattoo_body.Scale = 0.8;
		tattoo_head.Visible = true;
		tattoo_body.Visible = true;

		local hair_type = [
			"",
			"",
			"hair_black_03",
			"hair_brown_03",
			"hair_grey_03",
			"hair_black_03",
			"hair_brown_03",
			"hair_grey_03",
			"hair_black_southern_05",
			"hair_brown_southern_05",
			"hair_grey_southern_05"
		];
		xhair.setBrush(hair_type[this.Math.rand(0, hair_type.len() - 1)]);
	  }
	  else
	  {
		local xtattoo_head = actor.getSprite("tattoo_head");
		xhead.Color = this.createColor("#ffdeb8");
		xbody.Color = xhead.Color;
		xhead.Saturation = 0.7;
		xbody.Saturation = xhead.Saturation;
		local hair_type = [
			"01",
			"02",
			"03",
			"04",
			"08",
			"10",
			"19",
			"21",
			"southern_03"
		];
		if (this.Math.rand(0, 2) == 2)
		{
			xhair.setBrush("hair_black_787" + this.Math.rand(0, 6));
		}
		else
		{
			xhair.setBrush("hair_" + this.Const.HairColors.All[this.Math.rand(0, 4)] + "_" + hair_type[this.Math.rand(0, hair_type.len() - 1)]);
		}
		if (this.Math.rand(0, 3) == 0)
		{
			if (this.Math.rand(0, 1) == 0)
			{
				xtattoo_head.setBrush("bust_head_pox_01");
			}
			else
			{
				xtattoo_head.setBrush("bust_head_darkeyes_01");
			}
		}
		if (this.Math.rand(5, 8) == 7)
		{
			actor.getSprite("accessory_special").setBrush("ear_elf");
		}
	  }
	}

	function onAdded()
	{
		this.xxhero_background.onAdded();
		if (!this.getContainer().getActor().getSkills().hasSkill("effects.xxzzvoice_skill"))
		{
			local actor = this.getContainer().getActor();
			actor.getSkills().add(this.new("scripts/skills/actives/xxzzvoice_skill"));
			actor.getFlags().add("xxzzvoice_girl");
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 5);
		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/two_handed_flail"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/polehammer"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/billhook"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/longaxe"));
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/longsword"));
		}

		r = this.Math.rand(0, 17);
		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/ragged_dark_surcoat"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else if (r == 8)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}
		else if (r == 9)
		{
			items.equip(this.new("scripts/items/armor/oriental/stitched_nomad_armor"));
		}
		else if (r == 10)
		{
			items.equip(this.new("scripts/items/armor/oriental/gladiator_harness"));
		}
		else if (r == 11)
		{
			items.equip(this.new("scripts/items/armor/werewolf_hide_armor"));
		}
		else if (r == 12)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_mail"));
		}
		else if (r == 13)
		{
			items.equip(this.new("scripts/items/armor/barbarians/scrap_metal_armor"));
		}
		else if (r == 14)
		{
			items.equip(this.new("scripts/items/armor/barbarians/thick_furs_armor"));
		}
		else if (r == 15)
		{
			items.equip(this.new("scripts/items/armor/thick_dark_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/xxdress"));
		}
	}

});

