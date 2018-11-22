# Biter-Attack-Waves


Funding is stored unchanged so future mod settings changes will be re-applied fully. This means that cost setting changes will be applied to all previous funding and not just future funding.


Streamer Names Setting
----------
a list of the streamer ingame names that funding can go against. compulsory for funding to be applied.
{ "Streamer 1 Name", "Streamer 2 Name"}


Spawn Location Setting
---------------
position can include/exclude the x and y specification in the position table: {100, 0} or {x=100, y=0}
Example Spawn Location Setting:
{ top = { position = {0,200}, facing = "south" }, bottom = { position = {0,-200}, facing = "north" } }


Evolution Scale Setting
--------------
Evolution is entirely set by command and money donations. Config to set evolution per streamer per financial amount. If config key is empty or nil then no evolution override is done, example: 
{ {maxEvo = 0.25, cost = 100, increase = 0.005}, {maxEvo = 0.375, cost = 200, increase = 0.005}, {maxEvo = 0.5, cost = 1000, increase = 0.005} }




Remote Call Examples:

Fund Biter Wave:
/c remote.call("BiterAttackWaves", "FundBiterSquad", "Streamer 1 Name", "10", "top", "sponsor 1") remote.call("BiterAttackWaves", "FundBiterSquad", "Streamer 1 Name", "100", "bottom", "sponsor 2") remote.call("BiterAttackWaves", "FundBiterSquad", "Streamer 2 Name", "150", "top", "sponsor 1") remote.call("BiterAttackWaves", "FundBiterSquad", "Streamer 2 Name", "250", "top", "sponsor 2")

Fund Evolution:
/c remote.call("BiterAttackWaves", "FundIncreaseEvolution", "Streamer 1 Name", 1500, "sponsor 1") remote.call("BiterAttackWaves", "FundIncreaseEvolution", "Streamer 1 Name", 6000, "sponsor 2") remote.call("BiterAttackWaves", "FundIncreaseEvolution", "Streamer 2 Name", 2000, "sponsor 1")

Fund Biter Attack Size:
/c remote.call("BiterAttackWaves", "FundIncreaseAttackSize", "Streamer 1 Name", 5, "sponsor 1")