# Extraire des gif de longues vidéos sans logiciel d'édition

Vous écrivez votre prochain article/talk tech, et une métaphore vous vient en tête !  
Ça tombe bien, il était temps de faire un trait d'humour pour garder l'attention.

Vous avez une réplique de film bien précise en tête et vous aimeriez la coller, juste là.

## Exemple avec le concept "Découpage forcé"

L'image qui me vient, c'est le petit robot fourbe du film Transformers 2, quand il sort sa scie circulaire pour extraire le cerveau du personnage principal.  
Après quelques recherches, je découvre le nom de ce petit robot : Scalpel !  
Pas de gif à l'horizon :(

Peu importe, je vais me le créer en 2-2 !

Par chance, je trouve la scène en question sur [youtube](https://www.youtube.com/watch?v=9j7GRlbvXQ4).  
J'installe le plugin Firefox [VideoDownloadHelper](https://addons.mozilla.org/fr/firefox/addon/video-downloadhelper/), et je DL la scène en 720p.

## Je sors mon couteau suisse du son et de la vidéo : **ffmpeg**

```bash
sudo apt install ffmpeg
```
Des releases sont disponibles sur toutes les plateformes, et le code source est ouvert.  
[http://ffmpeg.org/download.html](http://ffmpeg.org/download.html)

Habituellement je l'utilise pour transformer des tracks audio en [Ogg Opus](http://opus-codec.org/static/comparison/quality.png) (my favorite audio codec). Bref.

### Raw command

```shell
ffmpeg -ss 1:21 -t 4 -i Scalpel.mp4 -vf "fps=20,crop=1280:530:0:100,scale=500:-1,drawtext=enable='between(t,1,4)':text='Coupe-coupe \!': fontcolor=white: fontsize=24: box=1: boxcolor=black@0.5:boxborderw=5: x=(w-text_w)/2: y=h-text_h" -gifflags -y output.gif
```

#### Cibler la séquence

* `-ss 1:21` pour commencer le gif à partir de 1 min 20
* `-t 4` pour ne prendre que les 4 secondes qui suivent

#### Indiquer le fichier d'entrée

`-i Scalpel.mp4`

#### Indiquer les frames par secondes

`-vf "fps=20"`

#### Redécouper la vidéo

Je souhaite retirer l'incrustation de la barre noire du bas.  
Je dois d'abord connaitre la taille de la vidéo d'origine :
```shell
ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 Scalpel.mp4
1280x720
```

Je retire 100 pixels en haut et en bas :
`-vf "crop=1280:520:0:100"`

##### Prévisualiuser les params de Découpage
`ffplay -i Scalpel.mp4 -vf "crop=1280:520:0:100"`

#### Redimensionner la vidéo (découpée) à 500 pixels de long
`-vf "scale=500:-1"`

#### Incruster la subtile réplique
`-vf "drawtext=enable='between(t,1,4)':text='Coupe-coupe \!': fontcolor=white: fontsize=24: box=1: boxcolor=black@0.5:boxborderw=5: x=(w-text_w)/2: y=h-text_h"`

##### À partir de 1s jusqu'à la fin
`"enable='between(t,1,4)'"`

##### Le contenu
`"text='Coupe-coupe \!'"`

##### La couleur de la font
`"fontcolor=white"`

##### La taille de la font
`"fontsize=24"`

##### La taille du background
`"box=1"`

##### La couleur de background
`"boxcolor=black"`

##### L'opacité du background
`"@0.5"`

##### La taille des bordures du background
`"boxborderw=5"`

##### Les coordonnées du text
`"x=(w-text_w)/2: y=h-text_h"`

### Encodage différentiel

Il y a 2 manières de coder les images d'un gif :
* Encoder entièrement chaque image
* Encode uniquement le delta entra chaque image

Le mode delta (cumulative layers) est activé par l'option `-gifflags`

### Résultat

![](cut-cut.gif)

## Source
J'ai découvert cette feature de ffmpeg grâce à [cet article](http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html).

## Pour aller plus loin

Pour gagner en qualité on peut changer la palette de couleurs utilisée pour générer le gif.  
Cela se fait en 2 étapes :
* On génère la palette (avec plein de parametres disponibles)
* On transcode la vidéo en utilisant cette palette

```shell
#Étape 1
ffmpeg -ss 1:21 -t 4 -i Scalpel.mp4 -vf "crop=1280:530:0:100,scale=500:-1:flags=lanczos,palettegen" -y palette.png

#Étape 2
ffmpeg -ss 1:21 -t 4 -i Scalpel.mp4 -i palette.png -lavfi "fps=20,crop=1280:530:0:100,scale=500:-1:flags=lanczos,drawtext=enable='between(t,1,4)':text='Coupe-coupe \!': fontcolor=white: fontsize=24: box=1: boxcolor=black@0.5:boxborderw=5: x=(w-text_w)/2: y=h-text_h,paletteuse" -y output.gif
```
ffmpeg -ss 1:21 -t 4 -i Scalpel.mp4 -vf "fps=20,crop=1280:530:0:100,scale=500:-1,drawtext=enable='between(t,1,4)':text='Coupe-coupe \!': fontcolor=white: fontsize=24: box=1: boxcolor=black@0.5:boxborderw=5: x=(w-text_w)/2: y=h-text_h" -gifflags -y output.gif
