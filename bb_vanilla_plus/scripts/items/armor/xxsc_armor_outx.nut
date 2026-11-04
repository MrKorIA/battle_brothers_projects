this.xxsc_armor_outx <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.xxsc_armor_outx";
		this.m.NameList = [
            "Мститель",
            "Предок",
            "Василиск",
            "Кокатрис",
            "Горгона",
            "Грифон",
            "Феникс",
            "Пегас",
            "Сквоч",
            "Йети",
            "Лучший друг",
            "Приятель",
            "Бастион",
            "Защитник",
            "Доппельгангер",
            "Хранитель",
            "Покровитель",
            "Властелин",
            "Страж",
            "Опекун",
            "Защитник",
            "Оберег",
            "Дух",
            "Оборотень",
            "Наследие",
            "Миротворец",
            "Надзиратель",
            "Верховный владыка",
            "Мудрец",
            "Тиран",
            "Великий",
            "Древний",
            "Старший страж",
            "Непобедимый",
            "Неодолимый",
            "Хранитель",
            "Спаситель",
            "Фамильяр",
            "Вечная жизнь",
            "Избавитель",
            "Искупитель",
            "Высший страж",
            "Уникальный страж"
		];
		this.m.Description = "Было применено изменение формы.";
		this.m.ShowOnCharacter = false;
		this.m.VariantString = "body_southern_named";
		this.m.Variant = 301;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.JesterImpact;
		this.m.Value = 100;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -20;
		this.m.UseRandomName = true;
		this.xxnameditem();
	}

	function xxnameditem()
	{
		if (this.Math.rand(0, 2) == 2)
		{
			this.m.StaminaModifier = this.Math.rand(-40, -10);
			this.m.Condition = this.Math.rand(100, 400);
		}
		else
		{
			this.m.StaminaModifier = this.Math.rand(-40, -20);
			this.m.Condition = this.Math.rand(100, 350);
		}
		this.m.ConditionMax = this.m.Condition;
	}

	function onSerialize( _out )
	{
		_out.writeString(this.m.Name);
		_out.writeF32(this.m.Condition);
		_out.writeF32(this.m.ConditionMax);
		_out.writeI8(this.m.StaminaModifier);
		_out.writeString(this.m.Sprite);
		_out.writeString(this.m.SpriteDamaged);
		_out.writeString(this.m.SpriteCorpse);
		_out.writeString(this.m.IconLarge);
		_out.writeString(this.m.Icon);
		_out.writeString(this.m.VariantString);
		_out.writeI8(this.m.Variant);
		this.armor.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Name = _in.readString();
		this.m.Condition = _in.readF32();
		this.m.ConditionMax = _in.readF32();
		this.m.StaminaModifier = _in.readI8();
		this.m.Sprite = _in.readString();
		this.m.SpriteDamaged = _in.readString();
		this.m.SpriteCorpse = _in.readString();
		this.m.IconLarge = _in.readString();
		this.m.Icon = _in.readString();
		this.m.VariantString = _in.readString();
		this.m.Variant = _in.readI8();
		this.armor.onDeserialize(_in);
		this.updateVariant();
	}

});

