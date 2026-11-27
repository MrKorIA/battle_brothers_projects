::ArrowDecalFlip <- {
	ID = "mod_arrow_decal_flip",
	Name = "Arrow Decal Flip",
	Version = "1.0.1"
}

::ArrowDecalFlip.HooksMod <- ::Hooks.register(::ArrowDecalFlip.ID, ::ArrowDecalFlip.Version, ::ArrowDecalFlip.Name);
::ArrowDecalFlip.HooksMod.require(["mod_modern_hooks"]);

::ArrowDecalFlip.HooksMod.queue(">mod_modern_hooks", function() {
	// Фикс ориентации декали промахнувшегося снаряда (стрелы/болты/дротики/метательные топоры).
	// Зеркалим по фактическому положению тайла приземления относительно стрелка:
	// горизонтальная составляющая декали всегда совпадает с направлением полёта.
	::ArrowDecalFlip.HooksMod.hook("scripts/skills/skill", function(q) {
		q.onScheduledProjectileSpawned = @(__original) { function onScheduledProjectileSpawned( _info )
		{
			_info.Container.setBusy(false);
			local flip = _info.TileHit.Pos.X < _info.User.getPos().X;

			for( local n = this.Const.Combat.SpawnArrowDecalAttempts; n != 0;  )
			{
				local decal = this.Const.ProjectileDecals[_info.Skill.getProjectileType()][this.Math.rand(0, this.Const.ProjectileDecals[_info.Skill.getProjectileType()].len() - 1)];
				local detail = _info.TileHit.spawnDetail(decal, 0, flip);

				if (detail == null)
				{
					n = --n;
					continue;
				}
				else
				{
					detail.setHorizontalFlipping(flip);
					local quantityMult = 0.5;

					if (_info.TileHit.IsVisibleForPlayer && this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype].len() != 0)
					{
						for( local i = 0; i < this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype].len(); i = i )
						{
							if (this.Tactical.getWeather().IsRaining && !this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].ApplyOnRain)
							{
							}
							else
							{
								this.Tactical.spawnParticleEffect(false, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].Brushes, _info.TileHit, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].Delay, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].Quantity * quantityMult, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].LifeTimeQuantity * quantityMult, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].SpawnRate, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].Stages);
							}

							i = ++i;
						}
					}
				}

				break;
			}
		}}.onScheduledProjectileSpawned;
	});
});
