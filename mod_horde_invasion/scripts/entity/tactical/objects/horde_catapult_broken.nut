// Обломок катапульты Железной Орды — ставится на тайл при уничтожении
// (onAfterDeath объекта horde_catapult). Образец —
// data_014/scripts/entity/tactical/objects/destroyed_greenskin_catapult.nut,
// спрайт один — «horde_catapult_broken» (без слоёв top/bottom).
this.horde_catapult_broken <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Разрушенный онагр орды";
	}

	function getDescription()
	{
		return "Эта осадная машина Великой Орды выведена из строя.";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("horde_catapult_broken");
		this.setBlockSight(false);
	}

	function isDying()
	{
		return true;
	}

});
