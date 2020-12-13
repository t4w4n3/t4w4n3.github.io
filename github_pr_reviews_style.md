Reviewer de gros fichers dans les Pull-Request Github
=====================================================

Quand on review une pull-request dans Github, l'onglet "files changed" nous montre les fichiers modifés.  
Mais il les tronque à la même largeur que le reste de l'interface :confused:

![](github_review_files.png)

De plus gros fichiers sont moins facile à reviewer.

## Le responsable :

![](responsable_max_width.png)

## max-width: none;

![](max_width_none.png)

Ahhhhh, on y voit plus clair :relaxed:

## Automatiser le change-style

Sous Firefox ou Chrome : Plugin Stylus

### Installation

![![](https://addons.mozilla.org/fr/firefox/addon/styl-us/)](stylus_firefox.png)

![![](https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne)](stylus_chrome.png)

* [Recommandé](https://support.mozilla.org/fr/kb/programme-extensions-recommandees#w_comment-les-extensions-recommandaees-sont-elles-saelectionnaees) par Mozilla
* [Open Source](https://github.com/openstyles/stylus)

> :warning: 
> Open Source = Les sources du logiciel sont ouvertes  
> Libre       = Le logiciel respecte vos libertés  
> [Open Source is not Free](https://www.gnu.org/philosophy/open-source-misses-the-point.fr.html)

### Configuration

#### 1. New style

![](stylus_new_style.png)

#### 2. Style css code

![](stylus_style_code.png)

```css
.container-lg {
    max-width: none;
}
```

#### 3. Url matching

![](stylus_style_regex.png)

`https://github.com/.*/files`

#### 4. Enregistrer

#### 5. Tadaaaaa
