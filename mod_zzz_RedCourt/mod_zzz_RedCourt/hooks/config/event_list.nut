::TheRedCourt.EventList <- {
    StatGain = "%s получаете [color=%s]+%d[/color] %s",
    StatLose = "%s теряете [color=%s]-%d[/color] %s",
    LightWound = "%s получает лёгкие ранения",
    HeavyWound = "%s получает тяжелые ранения",
    Injury = "%s получает %s",
    RenownGain = "Вы получаете [color=%s]%s[/color] известности",
    RenownLose = "Вы теряете [color=%s]%s[/color] известности",
    GoldGain = "Вы получаете [color=%s]%d[/color] крон",
    GoldLose = "Вы теряете [color=%s]%d[/color] крон",
    Amount = [
        "небольшое количество",
        "приличное количество",
        "большое количество",
        "значительное количество"
    ]
}

::TheRedCourt.EventList.changeStat <- function (_name, _value, _icon, _skill) {
    return {
        id = 17,
        icon = _icon,
        text = (_value > 0) ?
            ::format(::TheRedCourt.EventList.StatGain, _name, ::Const.UI.Color.PositiveEventValue, ::Math.abs(_value), _skill):
            ::format(::TheRedCourt.EventList.StatLose, _name, ::Const.UI.Color.NegativeEventValue, ::Math.abs(_value), _skill)
    }
}

::TheRedCourt.EventList.changeHitpoints <- function (_bro, _value) {
    _bro.getBaseProperties().Hitpoints += _value;
    return ::TheRedCourt.EventList.changeStat(_bro.getName(), _value, "ui/icons/health.png", "к ОЗ");
}

::TheRedCourt.EventList.changeResolve <- function (_bro, _value) {
    _bro.getBaseProperties().Bravery += _value;
    return ::TheRedCourt.EventList.changeStat(_bro.getName(), _value, "ui/icons/bravery.png", "к решимости");
}

::TheRedCourt.EventList.changeFatigue <- function (_bro, _value) {
    _bro.getBaseProperties().Stamina += _value;
    return ::TheRedCourt.EventList.changeStat(_bro.getName(), _value, "ui/icons/fatigue.png", "к выносливости");
}

::TheRedCourt.EventList.changeMeleeSkill <- function (_bro, _value) {
    _bro.getBaseProperties().MeleeSkill += _value;
    return ::TheRedCourt.EventList.changeStat(_bro.getName(), _value, "ui/icons/melee_skill.png", "к навыку ближнего боя");
}

::TheRedCourt.EventList.changeMeleeDefense <- function (_bro, _value) {
    _bro.getBaseProperties().MeleeDefense += _value;
    return ::TheRedCourt.EventList.changeStat(_bro.getName(), _value, "ui/icons/melee_defense.png", "к защите в ближнем бою");
}

::TheRedCourt.EventList.changeRangedSkill <- function (_bro, _value) {
    _bro.getBaseProperties().RangedSkill += _value;
    return ::TheRedCourt.EventList.changeStat(_bro.getName(), _value, "ui/icons/ranged_skill.png", "к навыку дальнего боя");
}

::TheRedCourt.EventList.changeRangedDefense <- function (_bro, _value) {
    _bro.getBaseProperties().RangedDefense += _value;
    return ::TheRedCourt.EventList.changeStat(_bro.getName(), _value, "ui/icons/ranged_defense.png", "к защите в дальнем бою");
}

::TheRedCourt.EventList.changeInitiative <- function (_bro, _value) {
    _bro.getBaseProperties().Initiative += _value;
    return ::TheRedCourt.EventList.changeStat(_bro.getName(), _value, "ui/icons/initiative.png", "к инициативе");
}

::TheRedCourt.EventList.changeMood <- function (_bro, _value = 0, _cause = "") {
    if (_value > 0)
        _bro.improveMood(_value, _cause);
    else if (_value < 0)
        _bro.worsenMood(_value * -1.0, _cause);
    return {
        id = 10,
        icon = ::Const.MoodStateIcon[_bro.getMoodState()],
        text = _bro.getName() + ::Const.MoodStateEvent[_bro.getMoodState()]
    }
}
::TheRedCourt.EventList.changeBroExperience <- function (_bro, _value) {
    _bro.addXP(_value);
    _bro.updateLevel();
    return {
        id = 10,
        icon = "ui/icons/xp_received.png",
        text = _bro.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _value + "[/color] опыта"
    };
}

::TheRedCourt.EventList.addInjury <- function (_bro, _injuryConst) {
    local injury = _bro.addInjury(_injuryConst);
    return {
        id = 10,
        icon = injury.getIcon(),
        text = ::format(::TheRedCourt.EventList.Injury, _bro.getName(), injury.getNameOnly())
    };
}

::TheRedCourt.EventList.addLightInjury <- function (_bro) {
    _bro.addLightInjury();
    return {
        id = 10,
        icon = "ui/icons/days_wounded.png",
        text = ::format(::TheRedCourt.EventList.LightWound, _bro.getName())
    };
}
::TheRedCourt.EventList.addHeavyInjury <- function (_bro) {
    _bro.addHeavyInjury();
    return {
        id = 10,
        icon = "ui/icons/days_wounded.png",
        text = ::format(::TheRedCourt.EventList.HeavyWound, _bro.getName())
    };
}

::TheRedCourt.EventList.changeRenown <- function (_renown) {
    ::World.Assets.addBusinessReputation(_renown);
    return {
        id = 10,
        icon = "ui/icons/special.png",
        text = (_renown > 0) ?
            ::format(::TheRedCourt.EventList.RenownGain, this.Const.UI.Color.PositiveEventValue, function(_amount) {
                if (_amount <= 50)
                    return ::TheRedCourt.EventList.Amount[0];
                if (_amount <= 75)
                    return ::TheRedCourt.EventList.Amount[1];
                if (_amount <= 100)
                    return ::TheRedCourt.EventList.Amount[2];
                return ::TheRedCourt.EventList.Amount[3];
            } (_renown))
            :
            ::format(::TheRedCourt.EventList.RenownLose, this.Const.UI.Color.NegativeEventValue, function(_amount) {
                if (_amount <= 50)
                    return ::TheRedCourt.EventList.Amount[0];
                if (_amount <= 75)
                    return ::TheRedCourt.EventList.Amount[1];
                if (_amount <= 100)
                    return ::TheRedCourt.EventList.Amount[2];
                return ::TheRedCourt.EventList.Amount[3];
            } (::Math.abs(_renown)))
    };
}

::TheRedCourt.EventList.changeMoney <- function (_amount) {
    ::World.Assets.addMoney(_amount);
    return {
        id = 10,
        icon = "ui/icons/asset_money.png",
        text = (_amount > 0) ?
            ::format(::TheRedCourt.EventList.GoldGain, ::Const.UI.Color.PositiveEventValue, ::Math.abs(_amount)):
            ::format(::TheRedCourt.EventList.GoldLose, ::Const.UI.Color.NegativeEventValue, ::Math.abs(_amount))
    }
}

::TheRedCourt.EventList.addItems <- function (_itemList, _stash = null,  _prefix = "Вы получаете ") {
    if (_stash != null)
        _stash.makeEmptySlots(_itemList.len());
    local grouped = {};
    foreach (item in _itemList) {
        if (_stash != null)
            _stash.add(item);
        if (item.getID() in grouped) {
            grouped[item.getID()].count++;
            continue;
        }
        grouped[item.getID()] <- {
            item = item,
            count = 1
        };
    }

    local list = [];
    foreach (entry in grouped) {
        list.push({
            id = 1,
            icon = "ui/items/" + entry.item.getIcon(),
            text = _prefix + (entry.count > 1 ? ::format("%dx ", entry.count) : "") + entry.item.getName()
        });
    }
    return list;
}