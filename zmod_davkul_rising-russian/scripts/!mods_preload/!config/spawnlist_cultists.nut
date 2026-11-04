
local gt = this.getroottable();

if (!("World" in gt.Const))
{
    gt.Const.World <- {};
}

if (!("Spawn" in gt.Const.World))
{
    gt.Const.World.Spawn <- {};
}
gt.Const.World.Spawn.CultistRoamers <- [
    {
        Cost = 60,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 70,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 80,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 90,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 100,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 2,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 110,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 2,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 120,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 130,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 140,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 150,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 160,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 2,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 170,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 180,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 190,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 200,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 210,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 220,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 230,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 240,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 250,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 260,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 7,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 270,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 280,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 290,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 300,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 310,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 7,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 320,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 330,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 340,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 350,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 360,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 370,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 7,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 380,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 9,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 9
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 390,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 400,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 7,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 410,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 420,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 430,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 440,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 10,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 10
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 450,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 16,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 16
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 460,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 470,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 480,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 490,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 21,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 21
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 500,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 510,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 520,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 18,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 18
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 530,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 14,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 14
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 540,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 550,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 17,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 17
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 560,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 18,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 18
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 570,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 580,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 17,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 17
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 590,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
];
gt.Const.World.Spawn.CultistRaiders <- [
    {
        Cost = 60,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 70,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 80,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 90,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 100,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 110,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 2,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 120,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 2,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 130,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 140,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 150,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 160,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 1,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 170,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 180,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 190,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 200,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 210,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 220,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 230,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 240,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 250,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 7,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 260,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 9,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 9
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 270,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 9,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 9
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 280,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 290,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 300,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 310,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 10,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 10
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 320,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 330,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 340,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 350,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 9,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 9
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 360,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 370,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 9,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 9
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 380,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 390,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 10,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 10
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 400,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 14,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 14
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 410,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 420,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 10,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 10
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 430,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 440,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 14,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 14
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 450,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 9,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 9
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 460,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 15,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 15
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 470,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 14,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 14
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 480,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 14,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 14
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 490,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 500,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 510,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 17,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 17
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 520,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 10,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 10
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 530,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 10,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 10
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 540,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 16,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 16
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 550,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 15,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 15
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 560,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 570,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 580,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 590,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
];
gt.Const.World.Spawn.CultistDefenders <- [

    {
        Cost = 50,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 60,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 70,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 80,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 90,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 0,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
        ]
    },
    {
        Cost = 100,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 2,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 110,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 2,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 120,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 130,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 140,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 150,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 160,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 170,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 180,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 190,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 200,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 210,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 220,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 3,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 230,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 240,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 250,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 4,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Acolyte,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 260,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 7,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 270,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 280,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 290,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 300,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Herald,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 310,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 5,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 320,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 330,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 7,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 340,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 9,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 9
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 350,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 360,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 10,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 10
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 370,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 380,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 6,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 390,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 7,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 400,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 410,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 420,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 8,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 430,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 440,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 7,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 450,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 460,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 470,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 15,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 15
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 480,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 14,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 14
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 490,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 500,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 510,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 10,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 10
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 520,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 16,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 16
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 530,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 14,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 14
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 540,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 12,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 12
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 550,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 14,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 14
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 560,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 11,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 11
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 570,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 15,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 15
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 580,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 590,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 17,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 17
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 600,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 21,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 21
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 610,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 18,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 18
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 620,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 16,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 16
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 630,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 16,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 16
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 640,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 17,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 17
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 650,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 21,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 21
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 660,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 19,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 19
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 670,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 18,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 18
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 680,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 19,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 19
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 690,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 18,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 18
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 700,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 18,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 18
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 710,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 18,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 18
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 720,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 21,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 21
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 730,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 24,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 24
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 740,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 24,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 24
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 750,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 24,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 24
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 760,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 23,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 23
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 770,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 21,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 21
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 780,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 15,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 15
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 790,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 20,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 20
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 800,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 20,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 20
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 810,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 19,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 19
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 820,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 20,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 20
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 830,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 22,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 22
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 840,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 21,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 21
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 850,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 13,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 13
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 860,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 25,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 25
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 870,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 24,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 24
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 880,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 23,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 23
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 890,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 15,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 15
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 900,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 20,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 20
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 910,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 24,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 24
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 920,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 22,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 22
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 930,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 25,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 25
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 940,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 25,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 25
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 2
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 950,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 20,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 20
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 3
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 960,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 22,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 22
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 7
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 970,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 25,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 25
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 980,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 25,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 25
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
    {
        Cost = 990,
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        Fanatics = 20,
        Body = "figure_bandit_01",
        Troops =
        [
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
            Num = 20
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
            Num = 4
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Prophet,
            Num = 1
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
            Num = 8
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
            Num = 5
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
            Num = 6
            },
            {
            Type = this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened,
            Num = 0
            },
        ]
    },
];

function onCostCompare( _t1, _t2 )
{
    if (_t1.Cost < _t2.Cost)
    {
        return -1;
    }
    else if (_t1.Cost > _t2.Cost)
    {
        return 1;
    }

    return 0;
}

function calculateCosts( _p )
{
    foreach( p in _p )
    {
        p.Cost <- 0;

        foreach( t in p.Troops )
        {
            p.Cost += t.Type.Cost * t.Num;
        }

        if (!("MovementSpeedMult" in p))
        {
            p.MovementSpeedMult <- 1.0;
        }

        if (!("VisibilityMult" in p))
        {
            p.VisibilityMult <- 1.0;
        }

        if (!("VisionMult" in p))
        {
            p.VisionMult <- 1.0;
        }
    }

    _p.sort(this.onCostCompare);
}
this.calculateCosts(this.Const.World.Spawn.CultistRoamers);
this.calculateCosts(this.Const.World.Spawn.CultistRaiders);
this.calculateCosts(this.Const.World.Spawn.CultistDefenders);

this.Const.World.Spawn.CultistDefendersBackup <- this.Const.World.Spawn.CultistDefenders
this.Const.World.Spawn.CultistRaidersBackup <- this.Const.World.Spawn.CultistRaiders
this.Const.World.Spawn.CultistRoamersBackup <- this.Const.World.Spawn.CultistRoamers
