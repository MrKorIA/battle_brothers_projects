// Утилиты мира (порт из mod_hardened/namespaces/util.nut)
::ReforgedLite.util <- {
	// @return число в конце имени баннера мировой сущности ("banner_17" -> 17) или -1
	function getBannerID( _entity )
	{
		if (_entity.hasSprite("banner"))
		{
			local bannerSprite = _entity.getSprite("banner");
			if (bannerSprite.HasBrush)
			{
				local stringIndex = bannerSprite.getBrush().Name.find("banner_");
				try	// Не-player баннер бросит ошибку при tointeger
				{
					return bannerSprite.getBrush().Name.slice(stringIndex + 7).tointeger();	// +7 = длина "banner_"
				}
				catch (err) {}
			}
		}
		return -1;
	}

	// PlayerBanner, который сейчас не использует ни игрок, ни другая мировая партия/локация
	function findUnusedMercenaryBanner()
	{
		local possibleBanners = clone ::Const.PlayerBanners;

		::MSU.Array.removeByValue(possibleBanners, ::World.Assets.getBanner());

		foreach (worldParty in ::World.getAllEntitiesAtPos(::World.State.getPlayer().getPos(), 9000000))
		{
			::MSU.Array.removeByValue(possibleBanners, "banner_" + ::ReforgedLite.util.getBannerID(worldParty));
		}

		foreach (location in ::World.EntityManager.getLocations())
		{
			::MSU.Array.removeByValue(possibleBanners, "banner_" + ::ReforgedLite.util.getBannerID(location));
		}

		if (possibleBanners.len() == 0)
		{
			::logWarning("ReforgedLite.findUnusedMercenaryBanner: свободный баннер не найден, возвращается баннер игрока.");
			return ::World.Assets.getBanner();
		}

		return ::MSU.Array.rand(possibleBanners);
	}

	// Случайное имя из ::Const.Strings.MercenaryCompanyNames, не занятое игроком и мировыми партиями
	// (%randomname% заменяется случайным именем из ::Const.Strings.CharacterNames)
	function findUnusedMercenaryName()
	{
		local unusedNames = [];

		local randName = ::MSU.Array.rand(::Const.Strings.CharacterNames);
		foreach (mercName in ::Const.Strings.MercenaryCompanyNames)
		{
			mercName = ::MSU.String.replace(mercName, "%randomname%", randName);
			if (mercName == ::World.Assets.getName()) continue;

			local skipName = false;
			foreach (worldParty in ::World.getAllEntitiesAtPos(::World.State.getPlayer().getPos(), 9000000))
			{
				if (mercName == worldParty.getName())
				{
					skipName = true;
					break;
				}
			}
			if (skipName) continue;

			unusedNames.push(mercName);
		}

		return ::MSU.Array.rand(unusedNames);
	}
};
