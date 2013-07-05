-----------------------------------------------------------------------------------------
--
-- router.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function openAppHome()
	storyboard.gotoScene( "views.AppHome" )
end

function openPlayground()
	storyboard.gotoScene( "views.Playground" )
end

function openLevelSelection()
	storyboard.gotoScene( "views.LevelSelection" )
end

---------------------------------------------