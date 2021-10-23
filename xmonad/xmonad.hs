import XMonad
import Data.Monoid
import System.Exit
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicWorkspaces
import System.IO
import XMonad.Layout.Fullscreen
    ( fullscreenEventHook, fullscreenManageHook, fullscreenSupport, fullscreenFull )
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Hooks.WallpaperSetter
import XMonad.Layout.ShowWName
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWindows
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.FadeInactive
--import XMonad.Layout.IndependentScreens

import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Simplest
import XMonad.Layout.TwoPane
import XMonad.Layout.Combo

import XMonad.Layout.StackTile

import XMonad.Layout.MultiToggle 
import XMonad.Layout.MultiToggle.Instances 

import Graphics.X11.ExtraTypes.XF86 (xF86XK_AudioLowerVolume, xF86XK_AudioRaiseVolume, xF86XK_AudioMute,  xF86XK_AudioPlay, xF86XK_AudioPrev, xF86XK_AudioNext, xF86XK_AudioStop)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
--import qualified XMonad.Actions.DynamicWorkspaceOrder as DO

import XMonad.Layout.Master

--to test that it ln's
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    =  ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

myFont = "xft:Hack Nerd Font Mono:regular:size=12:antialias=true:hinting=true"
-- GridSelect
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("key-mapper", "key-mapper-gtk")
            , ("Strawberry", "strawberry")
            , ("Discord",    "discord")
            , ("Vivaldi",    "vivaldi-stable")
            , ("Telegram",   "telegram-desktop")
            , ("Steam",      "steam")
            , ("Calc",       "rofi -show calc -modi calc -no-show-match -no-sort")
            , ("Files",      "nautilus")
            ]


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_a     ), spawn myLauncher)

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((mod1Mask          , xK_F4    ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    --audio keys
    , ((0                 , xF86XK_AudioPlay), spawn "playerctl play-pause")
    , ((0                 , xF86XK_AudioPrev), spawn "playerctl previous")
    , ((0                 , xF86XK_AudioNext), spawn "playerctl next")
    , ((0                 , xF86XK_AudioStop), spawn "playerctl stop")
    , ((0                 , xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume 0 +5%")
    , ((0                 , xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume 0 -5%")
    , ((0                 , xF86XK_AudioMute), spawn "pactl set-sink-mute 0 toggle")

    --CycleWS

    , ((modm,               xK_Down),  nextWS)
    , ((modm,               xK_Up),    prevWS)
    , ((modm .|. shiftMask, xK_Down),  shiftToNext >> nextWS)
    , ((modm .|. shiftMask, xK_Up),    shiftToPrev >> prevWS)
    , ((modm,               xK_Right), nextScreen)
    , ((modm,               xK_Left),  prevScreen)
    , ((modm .|. shiftMask, xK_Right), shiftNextScreen >> nextScreen)
    , ((modm .|. shiftMask, xK_Left),  shiftPrevScreen >> prevScreen)
    , ((modm,               xK_z),     toggleWS)

    , ((modm .|. controlMask, xK_Return), windows W.shiftMaster)


    --grid select
    -- KB_GROUP Grid Select (CTR-g followed by a key)
    , ((modm .|. controlMask, xK_g), spawnSelected' myAppGrid)                 -- grid select favorite apps
    , ((modm .|. controlMask, xK_f), goToSelected $ mygridConfig myColorizer)  -- goto selected window
    , ((modm .|. controlMask, xK_h), bringSelected $ mygridConfig myColorizer) -- bring selected window

    --change keyboard layout
    
    --, ((controlMask  , xK_space), spawn "/home/gazavat/bin/change_layout.sh")

    , ((mod1Mask , xK_Tab), spawn "rofi -show window -show-icons -theme ~/git/dotfiles/rofi/styles/cloud_custom.rasi")
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)


    -- screenshots
    -- , ((modm .|. shiftMask  , xK_s     ), spawn "maim -s | xclip -selection clipboard -t image/png")
    -- , ((modm .|. controlMask, xK_s     ), spawn "maim ~/pics/screenshots/$(date +%s).png")
    -- , ((modm .|. mod1Mask   , xK_s     ), spawn "maim -i $(xdotool getactivewindow) ~/pics/screenshots/$(date +%s).png")

    --files
    --, ((modm  , xK_e   ), spawn "nautilus")

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), spawn "xfce4-session-logout")

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
--    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
        ]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

myTabTheme = def {
	activeBorderColor = "#7C7C7C",
	activeTextColor = "#CEFFAC",
	activeColor = "#000000",
	inactiveBorderColor = "#7C7C7C",
	inactiveTextColor = "#EEEEEE",
	inactiveColor = "#000000"
}
tabbedLayout = windowNavigation $ subTabbed $ smartBorders $ simpleTabbed--tabbed shrinkText myTabConfig
-- tabbedLayout2 = tabbed shrinkText 
tallDef = Tall nmaster delta ratio 
    where
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
masterTab = avoidStruts $ smartBorders $ TwoPane resizeRate defaultSplit--mastered resizeRate defaultSplit Full 
-- ^ Layout using tabbed for everything that is not master
  where resizeRate = (1/50)
        defaultSplit = (1/2)
myFull = avoidStruts $ smartBorders $ Full

myVLCFull = avoidStruts $ noBorders $ Full

myTwoPane = avoidStruts 
          $ smartBorders 
          $ combineTwo (TwoPane 0.03 0.5) masterTab masterTab


try =  StackTile 1 (3/100) (1/2)

tiled = avoidStruts $ smartBorders $ subLayout [] (Simplest) $ tallDef


myLayout =  masterTab ||| tiled ||| myFull -- ||| myTwoPane


------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ fullscreenManageHook
    , manageDocks
    , isFullscreen --> doFullFloat
    , className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , (className =? "Steam"  <&&> resource =? "Dialog")        --> doFloat
    , (className =? "Steam"  <&&> title =? "Friends List")        --> doFloat
    , className =? "vlc"            --> hasBorder False
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , manageHook defaultConfig
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
-- myLogHook = return ()
-- myLogHook = fadeWindowsLogHook myFadeHook
-- myFadeHook = composeAll [opaque -- default to opaque
--                         , isUnfocused --> opacity 1.0
--                         , isDialog --> opaque            
--                         ]

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount 
    where fadeAmount = 0.95

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()
	-- spawn "/home/gazavat/.config/polybar/launch.sh"
	-- spawn "feh --bg-fill --randomize ~/git/dotfiles/wallpapers/Winter/*"
	-- spawn "/home/gazavat/.config/autostart.sh"

------------------------------------------------------------------------
-- launcher

myLauncher = "rofi -no-lazy-grab -show drun -modi drun,window -hover-select -me-select-entry '' -me-accept-entry MousePrimary -theme ~/git/dotfiles/rofi/styles/sidetab_custom.rasi"
dmenuLauncher = "dmenu_run"

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#bb1c1f24"
    , swn_color             = "#bbffffff"
    }

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad $ fullscreenSupport $ docks $ ewmh defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = showWName' myShowWNameTheme $ myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }


