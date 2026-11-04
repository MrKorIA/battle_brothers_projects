// Druid's take on the goblin shaman's Root: writhing roots pin an enemy in place.
this.druid_entangle <- this.inherit("scripts/skills/actives/root_skill", {
    m = {
        // Turns until the roots can be called again (0 = ready). Set on use, ticked down each turn.
        Cooldown = 0
    },
    function create()
    {
        this.root_skill.create();
        this.m.ID = "actives.druid_entangle";
        this.m.Name = "Оплетающие корни";
        this.m.Description = "Поднимает из земли извивающиеся корни, оплетающие врага и удерживающие его на месте на ход.";
        this.m.Icon = "druid/active_entangle.png";
        this.m.IconDisabled = "druid/active_entangle_sw.png";
        this.m.MaxRange = 6;  // root_skill defaults to 8; everything else is inherited
    }

    function getTooltip()
    {
        local tooltip = this.getDefaultUtilityTooltip();
        tooltip.push({
            id = 6,
            type = "text",
            icon = "ui/icons/vision.png",
            text = "Дальность " + ::std.Text.positive(this.getMaxRange()) + " клеток"
        });
        tooltip.push({
            id = 7,
            type = "text",
            icon = "ui/icons/special.png",
            text = this.m.Cooldown > 0
                ? "Восстановится через " + ::std.Text.negative(this.m.Cooldown)
                    + " ходов" + ::std.Text.plural(this.m.Cooldown)
                : "Готов к использованию"
        });
        return tooltip;
    }

    function isUsable()
    {
        return this.root_skill.isUsable() && this.m.Cooldown == 0;
    }

    function onTurnStart()
    {
        this.root_skill.onTurnStart();
        this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
    }

    function onUse( _user, _targetTile )
    {
        local ok = this.root_skill.onUse(_user, _targetTile);
        // Ready again every other turn: used turn N -> usable turn N+2.
        if (ok) this.m.Cooldown = 2;
        return ok;
    }

    function onCombatStarted()
    {
        this.root_skill.onCombatStarted();
        this.m.Cooldown = 0;
    }

    function onCombatFinished()
    {
        this.root_skill.onCombatFinished();
        this.m.Cooldown = 0;
    }
});
