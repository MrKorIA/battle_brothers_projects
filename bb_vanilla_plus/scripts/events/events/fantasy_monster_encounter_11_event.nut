this.fantasy_monster_encounter_11_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null,
		SSitem = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_11_event";
		this.m.Title = "На привале...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_58.png[/img]{Пока компания отдыхает, %hedgeknight1% просит вас о личной встрече. %SPEECH_ON%Босс, можно вас на минутку? Во время моих приключений я наткнулся на редкий и ценный предмет. Изначально я планировал продать его после ухода на пенсию, но поскольку мне нравится жизнь наемника, я считаю, что лучше будет использовать его в нашей группе наемников, чем продавать где-то еще. Однако я также должен получить что-то в обмен. Как насчет увеличения моей зарплаты в 2 раза? Я считаю, что это справедливая сделка.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Принять предложение %hedgeknight1%",
					function getResult( _event )
					{
						_event.m.HedgeKnight1.improveMood(this.Math.rand(2, 3), "Предложение было принято");
						_event.m.HedgeKnight1.getBaseProperties().DailyWage += (_event.m.HedgeKnight1.getDailyCost() * 1) + 1;
						_event.m.HedgeKnight1.getSkills().update();
						_event.m.SSitem = null;
						return 0;
					}
				},
				{
					Text = "Отклонить предложение %hedgeknight1%",
					function getResult( _event )
					{
						_event.m.HedgeKnight1.worsenMood(this.Math.rand(2, 3), "Предложение было отклонено.");
						this.World.Assets.getStash().remove(_event.m.SSitem);
						_event.m.SSitem = null;
						return 0;
					}
				}
			],
			function start( _event )
			{
				local weapons = [
						"weapons/named/named_axe",
						"weapons/named/named_billhook",
						"weapons/named/named_cleaver",
						"weapons/named/named_crossbow",
						"weapons/named/named_crypt_cleaver",
						"weapons/named/named_dagger",
						"weapons/named/named_flail",
						"weapons/named/named_goblin_falchion",
						"weapons/named/named_goblin_heavy_bow",
						"weapons/named/named_goblin_pike",
						"weapons/named/named_goblin_spear",
						"weapons/named/named_greataxe",
						"weapons/named/named_greatsword",
						"weapons/named/named_javelin",
						"weapons/named/named_khopesh",
						"weapons/named/named_longaxe",
						"weapons/named/named_mace",
						"weapons/named/named_orc_axe",
						"weapons/named/named_orc_cleaver",
						"weapons/named/named_pike",
						"weapons/named/named_spear",
						"weapons/named/named_sword",
						"weapons/named/named_warhammer",
						"weapons/named/named_throwing_axe",
						"weapons/named/named_warbow",
						"weapons/named/named_warbrand",
						"weapons/named/named_warhammer",
						"weapons/named/named_warscythe"
				];
				if (this.Const.DLC.Unhold && this.Const.DLC.Wildmen && this.Const.DLC.Desert)
				{
					weapons.extend([
						"weapons/named/named_bardiche",
						"weapons/named/named_battle_whip",
						"weapons/named/named_bladed_pike",
						"weapons/named/named_fencing_sword",
						"weapons/named/named_handgonne",
						"weapons/named/named_heavy_rusty_axe",
						"weapons/named/named_polehammer",
						"weapons/named/named_polemace",
						"weapons/named/named_qatal_dagger",
						"weapons/named/named_rusty_warblade",
						"weapons/named/named_shamshir",
						"weapons/named/named_skullhammer",
						"weapons/named/named_spetum",
						"weapons/named/named_swordlance",
						"weapons/named/named_three_headed_flail",
						"weapons/named/named_two_handed_flail",
						"weapons/named/named_two_handed_hammer",
						"weapons/named/named_two_handed_mace",
						"weapons/named/named_two_handed_scimitar",
						"weapons/named/named_two_handed_spiked_mace"
					]);
				}
				if ("LegendMod" in this.Const) {}	else
				{
					weapons.extend([
						"helmets/named/gold_and_black_turban",
						"helmets/named/golden_feathers_helmet",
						"helmets/named/heraldic_mail_helmet",
						"helmets/named/lindwurm_helmet",
						"helmets/named/named_conic_helmet_with_faceguard",
						"helmets/named/named_metal_bull_helmet",
						"helmets/named/named_metal_nose_horn_helmet",
						"helmets/named/named_metal_skull_helmet",
						"helmets/named/named_nordic_helmet_with_closed_mail",
						"helmets/named/named_steppe_helmet_with_mail",
						"helmets/named/nasal_feather_helmet",
						"helmets/named/norse_helmet",
						"helmets/named/red_and_gold_band_helmet",
						"helmets/named/sallet_green_helmet",
						"helmets/named/red_and_gold_band_helmet",
						"helmets/named/wolf_helmet",
						"armor/named/black_and_gold_armor",
						"armor/named/black_leather_armor",
						"armor/named/blue_studded_mail_armor",
						"armor/named/brown_coat_of_plates_armor",
						"armor/named/golden_scale_armor",
						"armor/named/green_coat_of_plates_armor",
						"armor/named/heraldic_mail_armor",
						"armor/named/leopard_armor",
						"armor/named/lindwurm_armor",
						"armor/named/named_bronze_armor",
						"armor/named/named_golden_lamellar_armor",
						"armor/named/named_noble_mail_armor",
						"armor/named/named_plated_fur_armor",
						"armor/named/named_sellswords_armor",
						"armor/named/named_skull_and_chain_armor",
						"shields/named/named_bandit_heater_shield",
						"shields/named/named_bandit_kite_shield",
						"shields/named/named_dragon_shield",
						"shields/named/named_full_metal_heater_shield",
						"shields/named/named_golden_round_shield",
						"shields/named/named_lindwurm_shield",
						"shields/named/named_orc_heavy_shield",
						"shields/named/named_red_white_shield",
						"shields/named/named_rider_on_horse_shield",
						"shields/named/named_sipar_shield",
						"shields/named/named_undead_heater_shield",
						"shields/named/named_undead_kite_shield"
					]);
				}
				local item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Предлагаемый предмет: " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.SSitem = item;
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 50)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local rr = 1;
		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getLevel() < 10)
			{
				continue;
			}

			if (bro.getSkills().hasSkill("effects.xxzzfantasy_skill"))
			{
				candidates.push(bro);
			}
		}
		if (candidates.len() < rr)
		{
			return;
		}
		rr = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight1 = candidates[rr];
		candidates.remove(rr);
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight1",
			this.m.HedgeKnight1.getName()
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight1 = null;
		this.m.SSitem = null;
	}

});

