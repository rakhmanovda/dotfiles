#!/bin/bash
ln -f ~/.bashrc bash/.bashrc
ln -f ~/.xmonad/xmonad.hs xmonad/xmonad.hs
ln -f ~/.config/polybar/config polybar/config
ln -f ~/.config/polybar/launch.sh polybar/launch.sh
ln -f ~/.config/autostart.sh autostart/autostart.sh
if [ $1 ]; then
    git add --all
    git commit -m "update configs"
    git push
fi
