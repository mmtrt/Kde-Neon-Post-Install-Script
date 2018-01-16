#!/usr/bin/env bash
#
# Author:
#   mmtrt (Taqi Raza) [mttalpur@gmail.com]
#
# Description:
#   A post-installation bash script KDE Neon
#
# Date: Jan 12 2018
#

chkwgf () {
ls | grep -E 'graphics-drivers|index.html|ppa|xerus-media|mpv-tests|papirus' | wc -l
}

delppas () {
echo -e ''
echo -e '\e[7mRemoving wget PPAs data leftovers.\e[0m'
for f in graphics-drivers index.html ppa xerus-media mpv-tests papirus
do
rm $f
done
echo -e '\e[7mRemoved.\e[0m'
}

delpkgs () {
echo -e ''
echo -e '\e[7mRemoving DEB pkgs & Plasmoids leftovers.\e[0m'
for f in teamviewer-host_amd64.deb gitkraken-amd64.deb steam.deb 174323-Simple_Date_and_Time.plasmoid netspeed-widget-1.4.plasmoid plasma-applet-thermal-monitor.plasmoid p7zip_16.02+dfsg-4_amd64.deb p7zip-full_16.02+dfsg-4_amd64.deb p7zip-rar_16.02-1_amd64.deb
do
rm $f
done
echo -e '\e[7mRemoved.\e[0m'
}

wgetppadata () {
echo -e ''
echo -e '\e[7mGetting PPAs Data for Checking Base OS Exists.\e[0m'
for ppas in https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa https://launchpad.net/~rvm/+archive/ubuntu/smplayer/ https://launchpad.net/~mc3man/+archive/ubuntu/mpv-tests https://launchpad.net/~mc3man/+archive/ubuntu/xerus-media https://launchpad.net/~oibaf/+archive/ubuntu/graphics-drivers https://launchpad.net/~papirus/+archive/ubuntu/papirus
do
wget $ppas &> /dev/null
done
echo -e '\e[7mDone.\e[0m'
}

wgetpkgsNinst () {
echo -e ''
echo -e '\e[7mGetting DEB PKGS.\e[0m'
for pkgdebs in https://download.teamviewer.com/download/linux/teamviewer-host_amd64.deb https://release.gitkraken.com/linux/gitkraken-amd64.deb https://steamcdn-a.akamaihd.net/client/installer/steam.deb https://launchpad.net/ubuntu/+source/p7zip/16.02+dfsg-4/+build/13091326/+files/p7zip_16.02+dfsg-4_amd64.deb https://launchpad.net/ubuntu/+source/p7zip/16.02+dfsg-4/+build/13091326/+files/p7zip-full_16.02+dfsg-4_amd64.deb https://launchpad.net/ubuntu/+source/p7zip-rar/16.02-1/+build/10619354/+files/p7zip-rar_16.02-1_amd64.deb
do
wget $pkgdebs &> /dev/null
done

wget -O bcomp https://www.scootersoftware.com/download.php &> /dev/null
chkbcomv="$(cat bcomp | grep build | sed 's/,//g'|awk '{print $3}')"
chkbcomb="$(cat bcomp | grep build | sed 's/,//g'|awk '{print $5}')"
bcomdebv="$chkbcomv"
bcomdebb="$chkbcomb"
wget https://www.scootersoftware.com/bcompare-${bcomdebv}.${bcomdebb}_amd64.deb &> /dev/null
rm bcomp
chkbcomdeb="$(ls | grep bcompare)"
bcomdeb="$chkbcomdeb"

wget --accept "*.deb" --content-disposition --trust-server-names "https://go.microsoft.com/fwlink/?LinkID=760868" &> /dev/null
chkcodedeb="$(ls | grep -E 'code')"
codedeb="$chkcodedeb"

wget https://www.virtualbox.org/wiki/Linux_Downloads &> /dev/null
chkosc="$(cat Linux_Downloads | grep $(lsb_release -sc) | grep amd64 | wc -l)"
if [ $chkosc -eq 1 ]; then
getvblk="$(cat Linux_Downloads | grep $(lsb_release -sc) | grep amd64 | awk '{print $11}'|sed 's|href="||g;s|"><span||g')"
wget $getvblk &> /dev/null
vbdeb="$(ls | grep virtualbox)"
fi

wget --accept "*.deb" --content-disposition --trust-server-names "https://discordapp.com/api/download?platform=linux&format=deb" &> /dev/null
dcdeb=$(ls | grep discord)
echo -e '\e[7mDone.\e[0m'

echo -e ''
echo -e '\e[7mInstalling DEB PKGS.\e[0m'
for pkgdebins in teamviewer-host_amd64.deb gitkraken-amd64.deb steam.deb ${bcomdeb} ${codedeb} ${vbdeb} ${dcdeb} p7zip_16.02+dfsg-4_amd64.deb p7zip-full_16.02+dfsg-4_amd64.deb p7zip-rar_16.02-1_amd64.deb
do
sudo apt install ./$pkgdebins -y &> /dev/null
done
echo -e '\e[7mDone.\e[0m'

echo -e ''
echo -e '\e[7mInstalling gitkraken dependencies.\e[0m'
sudo apt install libgnome-keyring-common libgnome-keyring-dev -y &> /dev/null
echo -e '\e[7mDone.\e[0m'

echo -e ''
echo -e '\e[7mInstalling steam dependencies.\e[0m'
sudo apt install xterm libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 -y &> /dev/null
echo -e '\e[7mDone.\e[0m'

rm ${bcomdeb} ${codedeb} ${vbdeb} ${dcdeb} Linux_Downloads

echo -e ''
echo -e '\e[7mInstalling KDE Plasmoids.\e[0m'
for plasmoidsins in 174323-Simple_Date_and_Time.plasmoid netspeed-widget-1.4.plasmoid plasma-applet-thermal-monitor.plasmoid
do
plasmapkg2 -i $plasmoidsins &> /dev/null
done
echo -e '\e[7mDone.\e[0m'
}

endgreet () {
echo -e ''
echo -e '\e[7mFinished With the All Downloads & Installing Debs & Plasmoids.\e[0m'
echo -e '\e[7mIm done Now you go Enjoy KDE Neon.\e[0m'
echo -e ''
}

divertpkgs () {
echo -e ''
echo -e '\e[7mDpkg is Diverting VLC & libdrm-amdgpu pkgs for new upgrade.\e[0m'
sudo dpkg-divert --package libdrm-common --divert /usr/share/libdrm/amdgpu.ids.divert --rename /usr/share/libdrm/amdgpu.ids &> /dev/null
sudo dpkg-divert --package vlc --divert /usr/bin/qvlc.divert --rename /usr/bin/qvlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/bin/cvlc.divert --rename /usr/bin/cvlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/bin/nvlc.divert --rename /usr/bin/nvlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/bin/rvlc.divert --rename /usr/bin/rvlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/bin/vlc.divert --rename /usr/bin/vlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/bin/vlc-wrapper.divert --rename /usr/bin/vlc-wrapper &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/share/apport/package-hooks/source_vlc.py.divert --rename /usr/share/apport/package-hooks/source_vlc.py &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/share/zsh/vendor-completions/_vlc.divert --rename /usr/share/zsh/vendor-completions/_vlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/share/man/man1/vlc-wrapper.1.gz.divert --rename /usr/share/man/man1/vlc-wrapper.1.gz &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/share/man/man1/vlc.1.gz.divert --rename /usr/share/man/man1/vlc.1.gz &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/share/man/man1/cvlc.1.gz.divert --rename /usr/share/man/man1/cvlc.1.gz &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/share/man/man1/nvlc.1.gz.divert --rename /usr/share/man/man1/nvlc.1.gz &> /dev/null
sudo dpkg-divert --package vlc-nox  --divert /usr/share/man/man1/rvlc.1.gz.divert --rename /usr/share/man/man1/rvlc.1.gz &> /dev/null
echo -e '\e[7mDone.\e[0m'
}

rmdivertpkgs () {
echo -e ''
echo -e '\e[7mRemoving VLC & libdrm-amdgpu Diverts to properly function after upgrades.\e[0m'
sudo dpkg-divert --package libdrm-common --remove --rename /usr/share/libdrm/amdgpu.ids &> /dev/null
sudo dpkg-divert --package vlc --remove --rename /usr/bin/qvlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/bin/cvlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/bin/nvlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/bin/rvlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/bin/vlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/bin/vlc-wrapper &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/share/apport/package-hooks/source_vlc.py &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/share/zsh/vendor-completions/_vlc &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/share/man/man1/vlc-wrapper.1.gz &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/share/man/man1/vlc.1.gz &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/share/man/man1/cvlc.1.gz &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/share/man/man1/nvlc.1.gz &> /dev/null
sudo dpkg-divert --package vlc-nox  --remove --rename /usr/share/man/man1/rvlc.1.gz &> /dev/null
echo -e '\e[7mDone.\e[0m'
}

kdecustomcfgs () {
echo -e ''
echo -e '\e[7mInstalling kde custom configs.\e[0m'

killall dolphin &> /dev/null
killall kwrite &> /dev/null

cd ~/.config

sed -i -e 's|ksplashrc_ksplash_theme=Breeze|ksplashrc_ksplash_theme=None|g;s|ksplashrc_ksplash_engine=KSplashQML|ksplashrc_ksplash_engine=None|g' startupconfig

sed -i -e 's|extraItems=org.kde.discovernotifier,org.kde.kdeconnect,org.kde.plasma.battery,org.kde.plasma.bluetooth,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.mediacontroller,org.kde.plasma.networkmanagement,org.kde.plasma.notifications,org.kde.plasma.printmanager,org.kde.plasma.vault,org.kde.plasma.volume|extraItems=org.kde.plasma.clipboard,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.devicenotifier,org.kde.plasma.bluetooth,org.kde.plasma.notifications,org.kde.plasma.mediacontroller,org.kde.discovernotifier|g;s|knownItems=org.kde.discovernotifier,org.kde.kdeconnect,org.kde.plasma.battery,org.kde.plasma.bluetooth,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.mediacontroller,org.kde.plasma.networkmanagement,org.kde.plasma.notifications,org.kde.plasma.printmanager,org.kde.plasma.vault,org.kde.plasma.volume|knownItems=org.kde.plasma.clipboard,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.devicenotifier,org.kde.plasma.vault,org.kde.plasma.bluetooth,org.kde.plasma.notifications,org.kde.plasma.printmanager,org.kde.plasma.mediacontroller,org.kde.plasma.battery,org.kde.discovernotifier,org.kde.kdeconnect|g;s|plugin=org.kde.plasma.taskmanager|plugin=org.kde.plasma.icontasks|g;s|plugin=org.kde.plasma.kickoff|plugin=org.kde.plasma.kicker|g' plasma-org.kde.plasma.desktop-appletsrc
echo "showAllItems=true" >> plasma-org.kde.plasma.desktop-appletsrc
echo "" >> plasma-org.kde.plasma.desktop-appletsrc
echo "[Containments][2][Applets][5][Configuration][General]" >> plasma-org.kde.plasma.desktop-appletsrc
echo "launchers=applications:systemsettings.desktop,applications:org.kde.kinfocenter.desktop,applications:org.kde.ksysguard.desktop,applications:org.kde.dolphin.desktop,applications:org.kde.konsole.desktop" >> plasma-org.kde.plasma.desktop-appletsrc
echo "showToolTips=false" >> plasma-org.kde.plasma.desktop-appletsrc

echo "[IconsMode]" > dolphinrc
echo "FontWeight=50" >> dolphinrc
echo "IconSize=48" >> dolphinrc

echo "[Theme]" > plasmarc
echo "name=breeze-dark" >> plasmarc

echo "[Main]" > systemsettingsrc
echo "ActiveView=icon_mode" >> systemsettingsrc

echo "[Keyboard]" > kcminputrc
echo "NumLock=0" >> kcminputrc

echo "[KSplash]" > ksplashrc
echo "Engine=none" >> ksplashrc
echo "Theme=None" >> ksplashrc

echo "[Show]" > kservicemenurc
echo "bluedevilfileitemaction=false" >> kservicemenurc
echo "compressfileitemaction=true" >> kservicemenurc
echo "extractfileitemaction=true" >> kservicemenurc
echo "installFont=true" >> kservicemenurc
echo "kactivitymanagerd_fileitem_linking_plugin=false" >> kservicemenurc
echo "kdeconnectsendfile=false" >> kservicemenurc
echo "openTerminalHere=true" >> kservicemenurc
echo "runInKonsole=true" >> kservicemenurc
echo "slideshow=false" >> kservicemenurc

echo "[Appearance]" > my.profile
echo "ColorScheme=WhiteOnBlack" >> my.profile
echo "Font=Hack,11,-1,7,50,0,0,0,0,0,Regular" >> my.profile
echo "" >> my.profile
echo "[General]" >> my.profile
echo "Name=my" >> my.profile
echo "Parent=FALLBACK/" >> my.profile
echo "" >> my.profile
echo "[Scrolling]" >> my.profile
echo "ScrollBarPosition=2" >> my.profile
mkdir -p ~/.local/share/konsole/
mv my.profile ~/.local/share/konsole/

echo "[Desktop Entry]" > konsolerc
echo "DefaultProfile=my.profile" >> konsolerc
echo "" >> konsolerc
echo "[Favorite Profiles]" >> konsolerc
echo "Favorites=my.profile" >> konsolerc
echo "" >> konsolerc
echo "[KonsoleWindow]" >> konsolerc
echo "ShowMenuBarByDefault=false" >> konsolerc
echo "" >> konsolerc
echo "[TabBar]" >> konsolerc
echo "TabBarVisibility=ShowTabBarWhenNeeded" >> konsolerc

echo "[BusyCursorSettings]" > klaunchrc
echo "Blinking=false" >> klaunchrc
echo "Bouncing=false" >> klaunchrc

echo "[Confirmations]" > kiorc
echo "ConfirmDelete=true" >> kiorc
echo "ConfirmTrash=false" >> kiorc
echo "" >> kiorc
echo "[Executable scripts]" >> kiorc
echo "behaviourOnLaunch=open" >> kiorc

cat > kded5rc <<'EOF'
[Module-appmenu]
autoload=true

[Module-baloosearchmodule]
autoload=true

[Module-bluedevil]
autoload=true

[Module-device_automounter]
autoload=true

[Module-freespacenotifier]
autoload=true

[Module-kded_printmanager]
autoload=false

[Module-keyboard]
autoload=true

[Module-khotkeys]
autoload=true

[Module-kscreen]
autoload=true

[Module-ksysguard]
autoload=true

[Module-ktimezoned]
autoload=true

[Module-kwrited]
autoload=true

[Module-networkmanagement]
autoload=true

[Module-networkstatus]
autoload=true

[Module-plasmavault]
autoload=false

[Module-proxyscout]
autoload=true

[Module-solidautoeject]
autoload=true

[Module-statusnotifierwatcher]
autoload=true

[Module-touchpad]
autoload=false
EOF

echo "" >> kateschemarc
echo "[Normal]" >> kateschemarc
echo "dummy=prevent-empty-group" >> kateschemarc
echo "" >> kateschemarc
echo "[my]" >> kateschemarc
echo "Font=Hack,12,-1,7,50,0,0,0,0,0,Regular" >> kateschemarc
echo "dummy=prevent-empty-group" >> kateschemarc

echo "[General Options]" > kwriterc
echo "ShowMenuBar=false" >> kwriterc
echo "ShowPath=false" >> kwriterc
echo "ShowStatusBar=true" >> kwriterc

cat > katepartrc <<'EOF1'
[Document]
Allow End of Line Detection=true
BOM=false
Backup Flags=0
Backup Prefix=
Backup Suffix=~
Encoding=UTF-8
End of Line=0
Indent On Backspace=true
Indent On Tab=true
Indent On Text Paste=false
Indentation Mode=normal
Indentation Width=4
Keep Extra Spaces=false
Line Length Limit=0
Newline at End of File=true
On-The-Fly Spellcheck=false
Overwrite Mode=false
PageUp/PageDown Moves Cursor=false
Remove Spaces=0
ReplaceTabsDyn=true
Show Spaces=false
Show Tabs=true
Smart Home=true
Swap Directory=
Swap File Mode=1
Swap Sync Interval=15
Tab Handling=2
Tab Width=4
Trailing Marker Size=1
Word Wrap=false
Word Wrap Column=80

[Editor]
Encoding Prober Type=1
Fallback Encoding=ISO-8859-15

[Renderer]
Animate Bracket Matching=true
Schema=my
Show Indentation Lines=true
Show Whole Bracket Expression=true
Word Wrap Marker=false

[View]
Allow Mark Menu=true
Auto Brackets=false
Auto Center Lines=0
Auto Completion=true
Bookmark Menu Sorting=0
Default Mark Type=1
Dynamic Word Wrap=true
Dynamic Word Wrap Align Indent=80
Dynamic Word Wrap Indicators=1
Fold First Line=false
Folding Bar=true
Folding Preview=true
Icon Bar=false
Input Mode=0
Keyword Completion=true
Line Modification=true
Line Numbers=true
Maximum Search History Size=100
Persistent Selection=false
Scroll Bar Marks=false
Scroll Bar Mini Map All=false
Scroll Bar Mini Map Width=60
Scroll Bar MiniMap=true
Scroll Bar Preview=true
Scroll Past End=false
Search/Replace Flags=140
Show Scrollbars=1
Show Word Count=false
Smart Copy Cut=false
Vi Input Mode Steal Keys=false
Vi Relative Line Numbers=false
Word Completion=true
Word Completion Minimal Word Length=3
Word Completion Remove Tail=true
EOF1

cat > kdeglobals << 'EOF2'
[$Version]
update_info=fonts_global.upd:Fonts_Global,fonts_global_toolbar.upd:Fonts_Global_Toolbar

[ColorEffects:Disabled]
Color=
ColorAmount=
ColorEffect=
ContrastAmount=
ContrastEffect=
IntensityAmount=
IntensityEffect=

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=
ColorAmount=
ColorEffect=
ContrastAmount=
ContrastEffect=
Enable=false
IntensityAmount=
IntensityEffect=

[Colors:Button]
BackgroundAlternate=77,77,77
BackgroundNormal=49,54,59
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=189,195,199
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[Colors:Complementary]
BackgroundAlternate=59,64,69
BackgroundNormal=49,54,59
DecorationFocus=30,146,255
DecorationHover=61,174,230
ForegroundActive=246,116,0
ForegroundInactive=175,176,179
ForegroundLink=61,174,230
ForegroundNegative=237,21,21
ForegroundNeutral=201,206,59
ForegroundNormal=239,240,241
ForegroundPositive=17,209,22
ForegroundVisited=61,174,230

[Colors:Selection]
BackgroundAlternate=29,153,243
BackgroundNormal=61,174,233
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=252,252,252
ForegroundInactive=239,240,241
ForegroundLink=253,188,75
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=189,195,199

[Colors:Tooltip]
BackgroundAlternate=77,77,77
BackgroundNormal=49,54,59
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=189,195,199
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[Colors:View]
BackgroundAlternate=49,54,59
BackgroundNormal=35,38,41
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=189,195,199
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[Colors:Window]
BackgroundAlternate=77,77,77
BackgroundNormal=49,54,59
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=189,195,199
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[General]
ColorScheme=Breeze Dark
Name=Breeze
XftAntialias=true
XftHintStyle=hintmedium
XftSubPixel=none
shadeSortColumn=true
widgetStyle=Breeze

[Icons]
Theme=breeze

[KDE]
ColorScheme=Breeze
contrast=4
widgetStyle=Breeze

[KFileDialog Settings]
Automatically select filename extension=true
Breadcrumb Navigation=true
Decoration position=0
LocationCombo Completionmode=5
PathCombo Completionmode=5
Previews=false
Show Bookmarks=false
Show Full Path=false
Show Preview=false
Show Speedbar=true
Show hidden files=false
Sort by=Name
Sort directories first=true
Sort reversed=false
Speedbar Width=90
View Style=Simple
listViewIconSize=0

[WM]
activeBackground=49,54,59
activeBlend=255,255,255
activeForeground=239,240,241
inactiveBackground=49,54,59
inactiveBlend=75,71,67
inactiveForeground=127,140,141

EOF2

cat > gtkrc << 'EOF3'
# created by KDE Plasma, Sun Jan 14 19:24:51 2018
#
# If you do not want Plasma to override your GTK settings, select
# Colors in the System Settings and disable the checkbox
# "Apply colors to non-Qt applications"
#
#
include "/usr/share/themes/Breeze/gtk-2.0/gtkrc"

gtk-theme-name="Breeze"

style "default"
{
  bg[NORMAL] = { 0.192, 0.212, 0.231 }
  bg[SELECTED] = { 0.239, 0.682, 0.914 }
  bg[INSENSITIVE] = { 0.192, 0.212, 0.231 }
  bg[ACTIVE] = { 0.169, 0.184, 0.204 }
  bg[PRELIGHT] = { 0.192, 0.212, 0.231 }

  base[NORMAL] = { 0.137, 0.149, 0.161 }
  base[SELECTED] = { 0.239, 0.682, 0.914 }
  base[INSENSITIVE] = { 0.192, 0.212, 0.231 }
  base[ACTIVE] = { 0.239, 0.682, 0.914 }
  base[PRELIGHT] = { 0.239, 0.682, 0.914 }

  text[NORMAL] = { 0.937, 0.941, 0.945 }
  text[SELECTED] = { 0.937, 0.941, 0.945 }
  text[INSENSITIVE] = { 0.169, 0.184, 0.204 }
  text[ACTIVE] = { 0.937, 0.941, 0.945 }
  text[PRELIGHT] = { 0.937, 0.941, 0.945 }

  fg[NORMAL] = { 0.937, 0.941, 0.945 }
  fg[SELECTED] = { 0.937, 0.941, 0.945 }
  fg[INSENSITIVE] = { 0.169, 0.184, 0.204 }
  fg[ACTIVE] = { 0.937, 0.941, 0.945 }
  fg[PRELIGHT] = { 0.937, 0.941, 0.945 }
}

class "*" style "default"

style "ToolTip"
{
  bg[NORMAL] = { 0.937, 0.941, 0.945 }
  base[NORMAL] = { 0.988, 0.988, 0.988 }
  text[NORMAL] = { 0.192, 0.212, 0.231 }
  fg[NORMAL] = { 0.192, 0.212, 0.231 }
}

widget "gtk-tooltip" style "ToolTip"
widget "gtk-tooltips" style "ToolTip"

style "MenuItem"
{
  bg[PRELIGHT] = { 0.239, 0.682, 0.914 }
  fg[PRELIGHT] = { 0.937, 0.941, 0.945 }
}

class "*MenuItem" style "MenuItem"
EOF3

cat > gtkrc-2.0 << 'EOF4'
# created by KDE Plasma, Sun Jan 14 19:24:51 2018
#
# If you do not want Plasma to override your GTK settings, select
# Colors in the System Settings and disable the checkbox
# "Apply colors to non-Qt applications"
#
#

gtk-alternative-button-order = 1

style "default"
{
  bg[NORMAL] = { 0.192, 0.212, 0.231 }
  bg[SELECTED] = { 0.239, 0.682, 0.914 }
  bg[INSENSITIVE] = { 0.192, 0.212, 0.231 }
  bg[ACTIVE] = { 0.169, 0.184, 0.204 }
  bg[PRELIGHT] = { 0.192, 0.212, 0.231 }

  base[NORMAL] = { 0.137, 0.149, 0.161 }
  base[SELECTED] = { 0.239, 0.682, 0.914 }
  base[INSENSITIVE] = { 0.192, 0.212, 0.231 }
  base[ACTIVE] = { 0.239, 0.682, 0.914 }
  base[PRELIGHT] = { 0.239, 0.682, 0.914 }

  text[NORMAL] = { 0.937, 0.941, 0.945 }
  text[SELECTED] = { 0.937, 0.941, 0.945 }
  text[INSENSITIVE] = { 0.169, 0.184, 0.204 }
  text[ACTIVE] = { 0.937, 0.941, 0.945 }
  text[PRELIGHT] = { 0.937, 0.941, 0.945 }

  fg[NORMAL] = { 0.937, 0.941, 0.945 }
  fg[SELECTED] = { 0.937, 0.941, 0.945 }
  fg[INSENSITIVE] = { 0.169, 0.184, 0.204 }
  fg[ACTIVE] = { 0.937, 0.941, 0.945 }
  fg[PRELIGHT] = { 0.937, 0.941, 0.945 }
}

class "*" style "default"

style "ToolTip"
{
  bg[NORMAL] = { 0.937, 0.941, 0.945 }
  base[NORMAL] = { 0.988, 0.988, 0.988 }
  text[NORMAL] = { 0.192, 0.212, 0.231 }
  fg[NORMAL] = { 0.192, 0.212, 0.231 }
}

widget "gtk-tooltip" style "ToolTip"
widget "gtk-tooltips" style "ToolTip"

style "MenuItem"
{
  bg[PRELIGHT] = { 0.239, 0.682, 0.914 }
  fg[PRELIGHT] = { 0.937, 0.941, 0.945 }
}

class "*MenuItem" style "MenuItem"
EOF4
cd ..
kquitapp5 plasmashell &> /dev/null
sleep 3
kstart5 plasmashell &> /dev/null
sleep 3
echo -e '\e[7mDone.\e[0m'
}

chkpp1 () {
cat graphics-drivers | grep $(lsb_release -sc) | sed -n 1p | grep $(lsb_release -sc) | wc -l
}


chkpp2 () {
cat index.html | grep $(lsb_release -sc) | sed -n 1p | grep $(lsb_release -sc) | wc -l
}

chkpp3 () {
cat ppa | grep $(lsb_release -sc) | sed -n 1p | grep $(lsb_release -sc) | wc -l
}

chkpp4 () {
cat xerus-media | grep $(lsb_release -sc) | sed -n 1p | grep $(lsb_release -sc) | wc -l
}

chkpp5 () {
cat mpv-tests | grep $(lsb_release -sc) | sed -n 1p | grep $(lsb_release -sc) | wc -l
}

chkpp6 () {
cat papirus | grep $(lsb_release -sc) | sed -n 1p | grep $(lsb_release -sc) | wc -l
}

if [ ! $(chkwgf) -eq 6 ]; then
wgetppadata
fi

kdecustomcfgs
divertpkgs

echo -e ''
echo -e '\e[7mChecking PPAs Data if this OS codename exists then Adding PPAs.\e[0m'
if [ $(chkpp1) -eq 1 ]; then
sudo add-apt-repository ppa:oibaf/graphics-drivers -y &> /dev/null
fi

if [ $(chkpp2) -eq 1 ]; then
echo -e ''
echo -e '\e[7mInstalling Smplayer.\e[0m'
sudo add-apt-repository ppa:rvm/smplayer -y &> /dev/null && sudo apt update &> /dev/null && sudo apt install smplayer -y &> /dev/null
echo -e '\e[7mDone.\e[0m'
fi

if [ $(chkpp3) -eq 1 ]; then
echo -e ''
echo -e '\e[7mInstalling Nvidia Proprietary drivers.\e[0m'
sudo add-apt-repository ppa:graphics-drivers/ppa -y &> /dev/null && sudo apt update &> /dev/null && sudo apt install --no-install-recommends nvidia-384 nvidia-settings nvidia-opencl-icd-384 ocl-icd-libopencl1 libvulkan1 libvdpau1 -y &> /dev/null
echo -e '\e[7mDone.\e[0m'
fi

if [ $(chkpp4) -eq 1 ]; then
sudo add-apt-repository ppa:mc3man/xerus-media -y &> /dev/null
fi

if [ $(chkpp5) -eq 1 ]; then
echo -e ''
echo -e '\e[7mInstalling mpv.\e[0m'
sudo add-apt-repository ppa:mc3man/mpv-tests -y &> /dev/null && sudo apt update &> /dev/null && sudo apt install mpv -y &> /dev/null
echo -e '\e[7mDone.\e[0m'
fi

if [ $(chkpp6) -eq 1 ]; then
echo -e ''
echo -e '\e[7mInstalling adapta-kde arc-kde papirus-icon-theme.\e[0m'
sudo add-apt-repository ppa:papirus/papirus -y &> /dev/null && sudo apt update &> /dev/null && sudo apt install --no-install-recommends adapta-kde arc-kde papirus-icon-theme -y &> /dev/null
echo -e '\e[7mDone.\e[0m'
fi
echo -e ''
echo -e '\e[7mDone with PPAs and Installing their Packages.\e[0m'
echo -e ''
echo -e '\e[7mAPT purge & autoremove > FireFox & VIM.\e[0m'
sudo apt purge firefox* vim -y &> /dev/null && sudo apt autoremove -y &> /dev/null
echo -e '\e[7mDone.\e[0m'
echo -e ''
echo -e '\e[7mAPT update & upgrade with new PPAs.\e[0m'
sudo apt update &> /dev/null && sudo apt upgrade -y &> /dev/null
echo -e '\e[7mDone.\e[0m'
echo -e ''
echo -e '\e[7mAPT install -f & autoremove if any FOUND.\e[0m'
sudo apt install -f -y &> /dev/null && sudo apt autoremove -y &> /dev/null
echo -e '\e[7mDone.\e[0m'

rawplasmoidscnv () {
echo -e ''
echo -e '\e[7mExtracting Plasmoids from this Script for Installing.\e[0m'

SDT64="174323-Simple_Date_and_Time.b64"
NW64="netspeed-widget-1.4.b64"
PATM64="plasma-applet-thermal-monitor.b64"
SDT="174323-Simple_Date_and_Time.plasmoid"
NW="netspeed-widget-1.4.plasmoid"
PATM="plasma-applet-thermal-monitor.plasmoid"

cat > 174323-Simple_Date_and_Time.b64 <<'EOF'
UEsDBAoAAAAAADk0bEcAAAAAAAAAAAAAAAAVABwAU2ltcGxlX0RhdGVfYW5kX1RpbWUvVVQJAAMt
h0RWLodEVnV4CwABBOgDAAAEZAAAAFBLAwQUAAAACAA5NGxHd9J88DYBAABMAgAAJQAcAFNpbXBs
ZV9EYXRlX2FuZF9UaW1lL21ldGFkYXRhLmRlc2t0b3BVVAkAAy2HRFYuh0RWdXgLAAEE6AMAAARk
AAAAjVHJTsMwEL3nK/wB2FVvXCxRtQEVCopoQZUQB8eehlHiBdsJSr8eJ1RlyYWj3zJ+8+ZlBaGO
1pHcRN+/ZrmRVqGp+NPuml5mD0ID36J2DZCViECEUWSHGrJd7xIDvkMJ2Vpaw52HA3gwEgINfYig
aRyUS6s1mMjP/gElCoNrRA+KoEkoEWXpocOkUeRgvRaRZXt6t8pp0bQVmrU5WLpo45v1/JaRxzbW
9iPUOBXlWmDDjyW4eLyqhgeTVk91m5TcBOA3xWZKjotbX7FaQbKncrBkYSxCpYxpjXG3ffKIoAUt
vO1QQTh73IizQXXxBxsGTH9cJrSyvue/e57onsEHTHXP2fxEnq4wXCTwrzyzhUtJ43e+RbHmCmQj
vIjYgRjpID26H6J7gWY7YrzFWWrOsHfd/DvqJ1BLAwQKAAAAAACsYAZHAAAAAAAAAAAAAAAAHgAc
AFNpbXBsZV9EYXRlX2FuZF9UaW1lL2NvbnRlbnRzL1VUCQAD1JPDVRvGQ1Z1eAsAAQToAwAABGQA
AABQSwMECgAAAAAAlIVrRwAAAAAAAAAAAAAAACEAHABTaW1wbGVfRGF0ZV9hbmRfVGltZS9jb250
ZW50cy91aS9VVAkAA9fEQ1YbxkNWdXgLAAEE6AMAAARkAAAAUEsDBBQAAAAIAGBmO0foplQ+egAA
AMYAAAApABwAU2ltcGxlX0RhdGVfYW5kX1RpbWUvY29udGVudHMvdWkvbWFpbi5xbWxVVAkAA4Ms
CFYbxkNWdXgLAAEE6AMAAARkAAAAbYxNCsJADIX3OUVOEKxLt10JLlpvEKZBQp1mmEkXUnr3jn+g
4ts8+N6PxmTZsfd+1jDinnagX4hOfLPZCzbUvCPLFxoHoXTlEvlppsPn+qcSLMs9Ri7YPVBbCSAc
XSIsgFXd66aWY+LgZ0lZikzOrjYdsP2HcVlhhQ1QSwMEFAAAAAgASYRrR6B0l+hxAQAAUgMAADoA
HABTaW1wbGVfRGF0ZV9hbmRfVGltZS9jb250ZW50cy91aS9Db21wYWN0UmVwcmVzZW50YXRpb24u
cW1sVVQJAANqwkNWG8ZDVnV4CwABBOgDAAAEZAAAAI1Sz2vCMBS+96949KRsxFZ26m1shwkKygY7
jCFZ8rTBJinJ6+YY/u9LW1urTFgOLXnv+5H38ZQurSNY0apSYgdTlkTqrMTm/NtW5CFladeybst2
EllZcK85EzaUDZoACnwIh3tYNr2HvnWV67BjtWfAdRhBNCPU0U9Ut5TMwFlLUXNrH8ZKhxt0DuWr
kpRnAJITrgv+gQX7qksAN3AX8JMJTKHcg92Ax5I7TsoaGEppvle60p3QFak/zZ9QbXPKhoy8KV0y
jh4dHq4wGsopB/bIiT/byglsOm0eXSaXh5TGtXeiB6HZKoPnwLhGxT1EWGNQEMrWxdfgt3huBS/i
95ObIXSfvBhKpUmSDIVDzmlIWMCoRKesBLIQYnLo83EjdGi+ZxN2WxK2LQTxjxFPqfUwwj1dAlfE
NtZpTiE/fAkDj/pwWJDgrBmQdd1biKWUsFgsIPzyTGu4X8Yw7j24Ebl1ngmsg5iZ2i+sUrgdJztE
v1BLAwQUAAAACADFhWtHFeobaFkAAACKAAAARAAcAFNpbXBsZV9EYXRlX2FuZF9UaW1lL2NvbnRl
bnRzL3VpLy5Db21wYWN0UmVwcmVzZW50YXRpb24ucW1sLmthdGUtc3dwVVQJAAMxxUNWG8ZDVnV4
CwABBOgDAAAEZAAAAGNgYBDyTixJVQguTyxQcMvMSVUw0jNgYGAQebP6/Kz+n3tbeV/+smfKnas1
ZfeZbcFBQBlOIDYBYi9XMFcYiHWA2MM12BOJy5iC4OuC+IkI5SC+HqpuXVcAUEsBAh4DCgAAAAAA
OTRsRwAAAAAAAAAAAAAAABUAGAAAAAAAAAAQAO1BAAAAAFNpbXBsZV9EYXRlX2FuZF9UaW1lL1VU
BQADLYdEVnV4CwABBOgDAAAEZAAAAFBLAQIeAxQAAAAIADk0bEd30nzwNgEAAEwCAAAlABgAAAAA
AAEAAAC0gU8AAABTaW1wbGVfRGF0ZV9hbmRfVGltZS9tZXRhZGF0YS5kZXNrdG9wVVQFAAMth0RW
dXgLAAEE6AMAAARkAAAAUEsBAh4DCgAAAAAArGAGRwAAAAAAAAAAAAAAAB4AGAAAAAAAAAAQAO1B
5AEAAFNpbXBsZV9EYXRlX2FuZF9UaW1lL2NvbnRlbnRzL1VUBQAD1JPDVXV4CwABBOgDAAAEZAAA
AFBLAQIeAwoAAAAAAJSFa0cAAAAAAAAAAAAAAAAhABgAAAAAAAAAEADtQTwCAABTaW1wbGVfRGF0
ZV9hbmRfVGltZS9jb250ZW50cy91aS9VVAUAA9fEQ1Z1eAsAAQToAwAABGQAAABQSwECHgMUAAAA
CABgZjtH6KZUPnoAAADGAAAAKQAYAAAAAAABAAAAtIGXAgAAU2ltcGxlX0RhdGVfYW5kX1RpbWUv
Y29udGVudHMvdWkvbWFpbi5xbWxVVAUAA4MsCFZ1eAsAAQToAwAABGQAAABQSwECHgMUAAAACABJ
hGtHoHSX6HEBAABSAwAAOgAYAAAAAAABAAAAtIF0AwAAU2ltcGxlX0RhdGVfYW5kX1RpbWUvY29u
dGVudHMvdWkvQ29tcGFjdFJlcHJlc2VudGF0aW9uLnFtbFVUBQADasJDVnV4CwABBOgDAAAEZAAA
AFBLAQIeAxQAAAAIAMWFa0cV6htoWQAAAIoAAABEABgAAAAAAAAAAACkgVkFAABTaW1wbGVfRGF0
ZV9hbmRfVGltZS9jb250ZW50cy91aS8uQ29tcGFjdFJlcHJlc2VudGF0aW9uLnFtbC5rYXRlLXN3
cFVUBQADMcVDVnV4CwABBOgDAAAEZAAAAFBLBQYAAAAABwAHAAoDAAAwBgAAAAA=
EOF

cat > netspeed-widget-1.4.b64 <<'EOF1'
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
AABjb250ZW50cy9VVAUAA0RNmlZ1eAsAAQToAwAABGQAAABQSwECHgMKAAAAAACDpehKAAAAAAAA
AAAAAAAADAAYAAAAAAAAABAA7UHeAQAAY29udGVudHMvdWkvVVQFAAP2J2FZdXgLAAEE6AMAAARk
AAAAUEsBAh4DFAAAAAgAgKXoSm6rFPT+CAAAHjAAACUAGAAAAAAAAQAAAKSBJAIAAGNvbnRlbnRz
L3VpL0NvbXBhY3RSZXByZXNlbnRhdGlvbi5xbWxVVAUAA+8nYVl1eAsAAQToAwAABGQAAABQSwEC
HgMKAAAAAACNpuhKAAAAAAAAAAAAAAAAEwAYAAAAAAAAABAA7UGBCwAAY29udGVudHMvdWkvY29u
ZmlnL1VUBQAD6ilhWXV4CwABBOgDAAAEZAAAAFBLAQIeAxQAAAAIALV+Y0jaQec/RgMAAOMGAAAg
ABgAAAAAAAEAAACkgc4LAABjb250ZW50cy91aS9jb25maWcvQXBwUGlja2VyLnFtbFVUBQAD9U/Y
VnV4CwABBOgDAAAEZAAAAFBLAQIeAxQAAAAIADdwY0i6AgNWsgUAACESAAAkABgAAAAAAAEAAAC2
gW4PAABjb250ZW50cy91aS9jb25maWcvQXBwTWVudURpYWxvZy5xbWxVVAUAA7k12FZ1eAsAAQTo
AwAABGQAAABQSwECHgMUAAAACADqU2NIW43mz3MDAAAIBwAAIgAYAAAAAAABAAAApIF+FQAAY29u
dGVudHMvdWkvY29uZmlnL0NvbG9yUGlja2VyLnFtbFVUBQADaATYVnV4CwABBOgDAAAEZAAAAFBL
AQIeAxQAAAAIACF6YkgmcWi0ZwUAAN0WAAAkABgAAAAAAAEAAACkgU0ZAABjb250ZW50cy91aS9j
b25maWcvQ29uZmlnR2VuZXJhbC5xbWxVVAUAA9711lZ1eAsAAQToAwAABGQAAABQSwECHgMUAAAA
CADopehKl65DNoUFAACCEQAAJQAYAAAAAAABAAAApIESHwAAY29udGVudHMvdWkvY29uZmlnL0Nv
bmZpZ0FkdmFuY2VkLnFtbFVUBQADsyhhWXV4CwABBOgDAAAEZAAAAFBLAQIeAxQAAAAIADG650oD
C8yaKgUAAIISAAAUABgAAAAAAAEAAACkgfYkAABjb250ZW50cy91aS9tYWluLnFtbFVUBQADbvpf
WXV4CwABBOgDAAAEZAAAAFBLAQIeAwoAAAAAAEOr50oAAAAAAAAAAAAAAAAQABgAAAAAAAAAEADt
QW4qAABjb250ZW50cy9jb25maWcvVVQFAANO4F9ZdXgLAAEE6AMAAARkAAAAUEsBAh4DFAAAAAgA
N6/nSoHuGNm7AQAACwgAABgAGAAAAAAAAQAAAKSBuCoAAGNvbnRlbnRzL2NvbmZpZy9tYWluLnht
bFVUBQADuudfWXV4CwABBOgDAAAEZAAAAFBLAQIeAxQAAAAIAEV/Y0hFj4tftQAAAHoBAAAaABgA
AAAAAAEAAACkgcUsAABjb250ZW50cy9jb25maWcvY29uZmlnLnFtbFVUBQADAVHYVnV4CwABBOgD
AAAEZAAAAFBLBQYAAAAADgAOADYFAADOLQAAAAA=
EOF1

cat > plasma-applet-thermal-monitor.b64 <<'EOF2'
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
AAAAAAAAIICkgbgHAABjb250ZW50cy9jb2RlL3RlbXBlcmF0dXJlLXV0aWxzLmpzCgAgAAAAAAAB
ABgAAOFfNwca0wEA4V83BxrTAQDhXzcHGtMBUEsBAj8DFAMAAAAAwQYVSwAAAAAAAAAAAAAAABAA
JAAAAAAAAAAQgO1BFQkAAGNvbnRlbnRzL2NvbmZpZy8KACAAAAAAAAEAGAAA4V83BxrTAYC0W3aP
ptABAOFfNwca0wFQSwECPwMUAwAACAASbXxI6UuJOfMAAAAyAgAAGgAkAAAAAAAAACCApIFDCQAA
Y29udGVudHMvY29uZmlnL2NvbmZpZy5xbWwKACAAAAAAAAEAGAAAEtmk5ojRAQAS2aTmiNEBABLZ
pOaI0QFQSwECPwMUAwAACADBBhVL5VdIf9ABAADGBgAAGAAkAAAAAAAAACCApIFuCgAAY29udGVu
dHMvY29uZmlnL21haW4ueG1sCgAgAAAAAAABABgAAOFfNwca0wEA4V83BxrTAQDhXzcHGtMBUEsB
Aj8DFAMAAAAAkADPRgAAAAAAAAAAAAAAAA8AJAAAAAAAAAAQgO1BdAwAAGNvbnRlbnRzL2ZvbnRz
LwoAIAAAAAAAAQAYAIDB4BbuptABgMHgFu6m0AGAweAW7qbQAVBLAQI/AxQDAAAIAAwXkkYy8K4R
cxMBAOzcAQAsACQAAAAAAAAAIICkgaEMAABjb250ZW50cy9mb250cy9mb250YXdlc29tZS13ZWJm
b250LTQuMy4wLnR0ZgoAIAAAAAAAAQAYAAAs8n1yedABgMHgFu6m0AGAweAW7qbQAVBLAQI/AxQD
AAAAAG+l1EYAAAAAAAAAAAAAAAAQACQAAAAAAAAAEIDtQV4gAQBjb250ZW50cy9pbWFnZXMvCgAg
AAAAAAABABgAgB7Y/4ir0AGAHtj/iKvQAYAe2P+Iq9ABUEsBAj8DFAMAAAgATpPQRqnLMA6WCgAA
IjAAACMAJAAAAAAAAAAggO2BjCABAGNvbnRlbnRzL2ltYWdlcy90aGVybWFsLW1vbml0b3Iuc3Zn
CgAgAAAAAAABABgAgHt/MVGo0AGAHtj/iKvQAYAe2P+Iq9ABUEsBAj8DFAMAAAAAbQwVSwAAAAAA
AAAAAAAAAAwAJAAAAAAAAAAQgO1BYysBAGNvbnRlbnRzL3VpLwoAIAAAAAAAAQAYAAAz9P8MGtMB
gLRbdo+m0AEAM/T/DBrTAVBLAQI/AxQDAAAIAG0MFUvyc566hgQAAKoLAAAfACQAAAAAAAAAIICk
gY0rAQBjb250ZW50cy91aS9UZW1wZXJhdHVyZUl0ZW0ucW1sCgAgAAAAAAABABgAADP0/wwa0wEA
M/T/DBrTAQAz9P8MGtMBUEsBAj8DFAMAAAAAmQ0VSwAAAAAAAAAAAAAAABMAJAAAAAAAAAAQgO1B
UDABAGNvbnRlbnRzL3VpL2NvbmZpZy8KACAAAAAAAAEAGAAAxR9QDhrTAYC0W3aPptABAMUfUA4a
0wFQSwECPwMUAwAACACMlIVIluCn1+ABAABgCQAAJwAkAAAAAAAAACCApIGBMAEAY29udGVudHMv
dWkvY29uZmlnL0NvbmZpZ0FwcGVhcmFuY2UucW1sCgAgAAAAAAABABgAgF0wSlmP0QGAXTBKWY/R
AYBdMEpZj9EBUEsBAj8DFAMAAAgAwQYVS42gW3dDAgAAxQgAACEAJAAAAAAAAAAggKSBpjIBAGNv
bnRlbnRzL3VpL2NvbmZpZy9Db25maWdNaXNjLnFtbAoAIAAAAAAAAQAYAADhXzcHGtMBAOFfNwca
0wEA4V83BxrTAVBLAQI/AxQDAAAIAJkNFUskzMOLyQwAACBKAAApACQAAAAAAAAAIICkgSg1AQBj
b250ZW50cy91aS9jb25maWcvQ29uZmlnVGVtcGVyYXR1cmVzLnFtbAoAIAAAAAAAAQAYAADFH1AO
GtMBAMUfUA4a0wEAxR9QDhrTAVBLAQI/AxQDAAAIADcLFUurhMD2uQsAAMYvAAAUACQAAAAAAAAA
IICkgThCAQBjb250ZW50cy91aS9tYWluLnFtbAoAIAAAAAAAAQAYAAA5P6YLGtMBADk/pgsa0wEA
OT+mCxrTAVBLAQI/AxQDAAAIAFunWErG3APdZwIAAGMFAAAQACQAAAAAAAAAIICkgSNOAQBtZXRh
ZGF0YS5kZXNrdG9wCgAgAAAAAAABABgAgJSjCtCO0gGAlKMK0I7SAYCUowrQjtIBUEsFBgAAAAAU
ABQAXQgAALhQAQAAAA==
EOF2

base64 -d $SDT64 > $SDT
base64 -d $NW64 > $NW
base64 -d $PATM64 > $PATM

rm $SDT64 $NW64 $PATM64
echo -e '\e[7mDone.\e[0m'
}

rmdivertpkgs
rawplasmoidscnv
wgetpkgsNinst
delpkgs
delppas
endgreet
