# Description #

SDDM Hills Theme is based on two themes :

* [Maui](https://github.com/sddm/sddm/tree/master/data/themes/maui)
* [Numix](https://github.com/intialonso/intialonso.github.io)

and contains performance fix for Intel i915 video card that removes freezes and reduces unjustified CPU utilization (at least, on my ASUS Eee PC 1215P).

If QML works fine on your mashine, or SDDM works without freezes with any theme, you will not feel the difference.

SDDM Hills Theme also supports looped video background.


# Instalation. #



# Configuration #

Open ```/etc/sddm.conf``` in your favorite text editor and change follow strings :

```
[Theme]
# Current theme name
Current=hills
```

# Video Background #

## Default ##

SDDM Hills theme supports video background. To setup default theme video you need follow:

Go to the installed theme folder, for example ```cd /usr/share/sddm/themes/hills```

Start script to fetch video:

``` 
chmod +x ./fetchvideo.sh
./fetchvideo 
```

Script will download and save video file as ``` ./resources/background/background.mp4 ``` 

Open file ```theme.conf``` in your favorite text editor by root.

Change lines like follows:

```
[General]
background_video=resources/background/background.mp4
background_image=resources/background/background.jpg

#if 'true' then show background_video in loop, else show background_image.
use_video_instead_image=true
```

## Custom ##

Unfortunly, on moment of theme creation, Qt QML does not allow smooth video loops using standart QML API. To prevent this, I decide to place 'dummy' image as a background. If you decide to use your video file, you should do the same. 

Go to the installed theme folder, for example ```cd /usr/share/sddm/themes/hills```

Save your video file as ```./resources/background/background.mp4```

Start script to extract last video frame. **ATTENTION!!!** Script requires **ffmpeg** to work. 
```
chmod +x ./lastframe.sh
./lastframe.sh ./resources/background/background.mp4
```

Open file ```theme.conf``` in your favorite text editor by root.

Change lines like follows:

```
[General]
background_video=resources/background/background.mp4
background_image=resources/background/background.jpg

#if 'true' then show background_video in loop, else show background_image.
use_video_instead_image=true
```


# Links #
* Background video : http://churchmediadesign.tv/painted-hillside-free-looping-background/
* IconSet from Numix and Maui theme. See links in **Description**