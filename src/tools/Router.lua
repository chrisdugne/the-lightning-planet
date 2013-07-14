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