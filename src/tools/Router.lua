-----------------------------------------------------------------------------------------
--
-- router.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function openAppHome()
	storyboard.gotoScene( "src.views.AppHome" )
end

---------------------------------------------

function openPlayground()
	storyboard.gotoScene( "src.views.Playground" )
end

---------------------------------------------

function openSelection()
	if(game.mode == game.COMBO) then
		openLevelSelection()
	end

	if(game.mode == game.KAMIKAZE) then
		openKamikazeSelection()
	end

	if(game.mode == game.TIMEATTACK) then
		openTimeAttackSelection()
	end
end

function openLevelSelection()
	storyboard.gotoScene( "src.views.LevelSelection" )
end

function openKamikazeSelection()
	storyboard.gotoScene( "src.views.KamikazeSelection" )
end

function openTimeAttackSelection()
	storyboard.gotoScene( "src.views.TimeAttackSelection" )
end

---------------------------------------------

function openScore()
	storyboard.gotoScene( "src.views.Score" )
end

---------------------------------------------

function openBuy()
	storyboard.gotoScene( "src.views.Buy" )
end