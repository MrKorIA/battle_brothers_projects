this.rf_barrows_horns <- ::inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Крупные рога и кости";
	}

	function getDescription()
	{
		return "Останки крупных животных.";
	}

	function onInit()
	{
		local variants = [
			"01"
		];
		local tile = this.getTile();
		local isOnSnow = tile.Subtype == ::Const.Tactical.TerrainSubtype.Snow || tile.Subtype == ::Const.Tactical.TerrainSubtype.LightSnow;

		local body = this.addSprite("body");
		body.setBrush("rf_barrows_horns_" + ::MSU.Array.rand(variants) + (isOnSnow ? "_snow" : ""));
		body.setHorizontalFlipping(::Math.rand(0, 1) == 1);
	}
});
