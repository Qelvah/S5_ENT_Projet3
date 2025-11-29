## Le projet
### Introduction
Nous planifions faire un jeu similaire à Frogger.




## Utilisation de l'IA
### Structure des dossiers du projet
Avant de commencer à coder, afin d'avoir une semblance de cohérence dans le projet, nous avons demandé à ChatGPT de nous suggérer une architecture pour nos fichiers. Nous avons aussi créé des scènes vides dans les dossiers suggérés au départ du projet pour suivre l'architecture suggérée.

### Création du menu principal
Durant la création du menu principal, nous avons demandé à l'IA de nous appliquer différentes choses, comme la différence entre les options de buttons, la façon d'afficher une image d'arrière-plan (CanvasLayer, TextureRect, etc.), et les façons d'utiliser les sons. Les boutons sont censés avoir un sprite différent lorsqu'on appuie dessus, mais nous n’avions pas été capables de les faire marcher même avec l'IA et nous commencions à mettre trop de temps sur à simple bouton.

### Création du menu settings
Nous utilisé l'IA pour comprendre comment utilisé un fichier config et interagir avec selon les options affectées et pour la résolution de bogues. Nous devions utiliser Vector2i plutôt que Vector2 pour la résolution. Parfois l'IA nous donnait de fausses informations, même si la version de Godot avait été mentionnée.