Explorer ses volumes docker unbinded en 1 alias
======================================

L'instruction `VOLUME` du Dockerfile permet de monter un dossier du conteneur dans son hôte.  
Sur mon environnement, ils sont montés par défaut dans `/var/lib/docker/volumes/`, si je ne fournis pas de paramêtre de binding dans la commande `run`.

## Exemple
Le Dockerfile suivant construit une image helloworld. C'est probablement le tout premier dockerfile que vous aviez construit en suivant la doc officielle.
```
FROM ubuntu
RUN mkdir /myvol
RUN echo "hello world" > /myvol/greeting
VOLUME /myvol
```
Je le construit :
```shell
docker build -t hello-world .
```
Je le run **sans aucun binding** :
```shell
docker run --rm -it hello-world
```
(Grâce au paramêtre `--rm`, le volume sera supprimé dès l'arrêt du conteneur).  
Dans le conteneur, je regarde le contenu de /myvol :
```shell
ls /myvol
greeting
```
Je me détache du conteneur sans le quitter : `ctrl + p + q`.  
Et là, depuis l'hôte, j'aimerais aller explorer le volume.

## Docker volume
```shell
docker volume ls
```
```
DRIVER              VOLUME NAME
local               574b5d1846a2608a682ba4d6d7405c7c05870c2a858d0d16c0be40fe55035766
local               f235c4a14e4e66fbdd6664d373864608b77be0bf706e23b1c3d924ea469190bf
local               server
```
Et là, misère, lequel est mon volume ??  
Ils sont bien triés par ordre de dernière utilisation, mais vous imaginez que la situation pourrait être bien pire...  
S'ensuit alors une série de `docker volume inspect` et de copié-collés, jusqu'à trouver celui qui nous intéresse.

## Un pitit alias

Je me suis alors créé l'alias `dkvls` (DocKerVolumeLS).  
Il dépend de [jq](https://stedolan.github.io/jq/).

```shell
function dkvls() {
    if [ -z "$1" ]; then
        docker volume ls
        return 0
    fi
    if [ "$1" == "all" ]; then
        docker volume ls | awk '{print $2}' | grep -v VOLUME | xargs docker volume inspect | jq '.[].Mountpoint' | xargs sudo ls
        return 0
    fi
    inspected="$(dkvls | awk '{print $2}' | grep "^$1" | head -n1)"
    if [ -z "$inspected" ]; then
        return 0
    fi
    docker volume inspect "$inspected" | jq '.[0].Mountpoint' | xargs sudo ls
}
```

### Usage
```shell
dkvls #Revient à faire docker volume ls
dkvls all #Fait un ls dans chaque volume
dkvls <volume_id> # Fait un ls dans le volume dont l'id commence par volume_id
```
<video controls width="640">
    <source src="dkvls_cut.webm" type="video/webm">
</video>
<!-- ![](dkvls_cut.webm) -->
