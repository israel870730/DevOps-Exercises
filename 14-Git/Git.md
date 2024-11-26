# Notas GIT

## Para ver todos los commit de una forma mas grafica:
- git log --all --graph --decorate --oneline
 
## Para hacer un alias y poder ver todo lo anterior en una palabra:
- alias arbolito="git log --all --graph --decorate --oneline"

Para ver las ramas locales y remotas:
git branch -a

Para comenzar el repo
git init
 
Para ver la configuracion que tiene por defecto GIT:
git config --list
git config -l
 
Para ver donde estan los ficheros con la informacion de la configuracion:
git config --list --show-origin
 
Para cambiar el nombre y el mail del usuario en las configuraciones globales:
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
 
Para hacer un commit:
git commit -m "Mi primer commit del curso"
 
Para agregar ficheros y luego poder hacer el commit:
git add .
 
Para saber el estado:
git status
 
Para ver todos los commit:
git log
git log nombre_del_fihero
 
Para ver los cambios que ha tenido un fichero, con este comando podemos ver todo lo qu ha sido eliminado en rojo y lo agregado en verde:
git show historia.txt
 
Para comparar 2 commit y ver la diferencia de los ficheros:
git diff id_commit_#1 id_commit_#2
 
Para ver los cambios especificos que se han hecho en cada commit:
git log --stat
 
Ejemplo para regresar a un commit determinado, con --hard regresamos completo y borramos todos los otros commit, con --soft volvemos al commit deseado pero dejamos todo lo que esta en staging.
git reset id_commit --hard
git reset id_commit --soft
 
Si quiero regresar a un estado especifico de uno de los ficheros del repositorio, con esto solo regreso al ese estado al fichero history.txt los demas ficheros se mantienen integros:
Con esta opcion podemos movernos hacia cualquier estado que queramos del fichero:
git checkout id_commit historia.txt
git checkout master historia.txt
 
Crear una rama:
git branch nombre_cabecera
 
Ver las ramas:
git branch
 
Para cambiarme de rama uso  git checkout, ejemplo:
git checkout cabecera
 
Eliminar rama:
git branch -D cabecera
git branch --delete cabecera
 
Para unir 2 ramas usamos git merge, por ejemplo se queremos traer todos los cambios de cabecera hacia la rama master:
git merge cabecera
 
Agregar un repo remoto a mi git local:
git remote add origin https://github.com/israel870730/hyperblog.git
 
Para ver los remotos que tenemos usamos:
git remote
git remote -v
 
Para hacer push a un servidor remoto:
git push origin master
 
Cuando voy a sincronizar el repo remoto con el git local usando (git push origin master) y me da un error pq no perminte sincronizar las historias, debo usar:
git pull origin master --allow-unrelated-histories
 
 
Nota importante: si estoy trabajando con mi repo local y luego quiero agregarlo a un repo remoto como Github, puede que tenga que cambiar el nombre de la rama Head de Main a Master para que me funione de forma correcta
 
Para ver los tag que existen:
git tag
 
Ejemplo de como crear un tag:
git tag -a v0.1 -m "Resultado de las Primeras clases del curso" b3901b7
 
Para ver a que commit esta agregado el tag:
git show-ref --tags
 
Enviar los tag hacia el servidor remoto:
git push origin --tags
 
 
Es una buena practica hacer "git pull origin master" antes de hacer el push
 
 
Para eliminar un tag pero que se siga viendo desde la web:
git tag -d v0.2
 
Para eliminar un tag de forma completa:
git push origin :refs/tags/v0.2
 
Para ver la historia de las cabeceras:
git show-branch
git show-branch --all
  
Para ver la info de las ramas desde la interfaz grafica:
gitk
 
Para enviar otra cabecera hacia github:
git push origin cabecera
git push origin header
git push origin footer
 
 
El Pull requests lo que permite es que alguien revise o apruebe el codigo antes de hacer un "git merge" de otra rama a la master
 
 
"rebase" reescribe la historia del repositorio, cambia la historia de donde comenzó la rama y solo debe ser usado de manera local.
Primero se hace el git rebase desde la rama que quiero eliminar y luego desde la rama master
git rebase master
 
 
git clean --dry-run
 
git clean -f
 
El parametro -d ayuda con el borrado de carpetas untracked. Por ejemplo: git clean -df hubiera borrado la carpeta “css - copia”
 
Para traer un commit viejo de una rama hacia la rama master usamos:
git cherry-pick id_commit
 
Reconstruir commits en Git con amend
Cuando hago un commit y en ese commit hay trabajos que no he realizado, lo quepuedo hacer es un "git commit --amend", con esto lo que hago es agregar los cambios al commit anterior, no me crea un commit nuevo, si no que agrega los cambios al commit anterior
 
Buscar en archivos y commits de Git con Grep y log
Por ejemplo si quiero buscar la cantidad de vece que aparece la palabra color y en que lineas:
git grep -n color
got grep color
 
Para contar cuantas veces aparece la palabra ec2:
git grep -c ec2
 
Ejemplo usando git log, para saber cuantas veces aparece la rama cabecera:
git log -S "cabecera"
 
 
Para ver quienes han hecho todos los cambiososbre un fichero:
git blame -c blogpost.html
 
Para ver la ayuda de los comandos:
git blame --help
 
Para ver las ramas remotas:
git branch -r
 
Ver las ramas remotas y las locales:
git branch -a
 
 
git config --global alias.platzi "shortlog"
 
************************************************************************************************************************************************************
Comandos y recursos colaborativos en Git y GitHub:
 
git shortlog -sn = muestra cuantos commit han hecho cada miembros del equipo.
git shortlog -sn --all = muestra cuantos commit han hecho cada miembros del equipo hasta los que han sido eliminado
git shortlog -sn --all --no-merge = muestra cuantos commit han hecho cada miembros quitando los eliminados sin los merges
git blame ARCHIVO = muestra quien hizo cada cosa linea por linea
git COMANDO --help = muestra como funciona el comando.
git blame ARCHIVO -Llinea_inicial,linea_final= muestra quien hizo cada cosa linea por linea indicándole desde que linea ver ejemplo -L35,50
**git branch -r **= se muestran todas las ramas remotas
git branch -a = se muestran todas las ramas tanto locales como remotas
 
************************************************************************************************************************************************************
 
Git Reset y Reflog: úsese en caso de emergencia
 
Git guarda todos los cambios aunque decidas borrarlos, al borrar un cambio lo que estás haciendo sólo es actualizar la punta del branch, para gestionar éstas puntas existe un mecanismo llamado registros de referencia o reflogs.
.
La gestión de estos cambios es mediante los hash’es de referencia (o ref) que son apuntadores a los commits.
.
Los recoges registran cuándo se actualizaron las referencias de Git en el repositorio local (sólo en el local), por lo que si deseas ver cómo has modificado la historia puedes utilizar el comando:
 
git reflog
Muchos comandos de Git aceptan un parámetro para especificar una referencia o “ref”, que es un puntero a una confirmación sobre todo los comandos:
 
git checkout Puedes moverte sin realizar ningún cambio al commit exacto de la ref
 
git checkout eff544f
git reset: Hará que el último commit sea el pasado por la ref, usar este comando sólo si sabes exactamente qué estás haciendo
 
git reset --hard eff544f # Perderá todo lo que se encuentra en staging y en el Working directory y se moverá el head al commit eff544f
git reset --soft eff544f # Te recuperará todos los cambios que tengas diferentes al commit eff544f, los agregará al staging area y moverá el head al commit eff544f
git merge: Puedes hacer merge de un commit en específico, funciona igual que con una branch, pero te hace el merge del estado específico del commit mandado
 
git checkout master
git merge eff544f # Fusionará en un nuevo commit la historia de master con el momento específico en el que vive eff544f
************************************************************************************************************************************************************
git stash: es para guardar los cambios que he realizado en una rama, asi puedo cambiar a otra sin perder los cambios
Stashed:
El stashed nos sirve para guardar cambios para después, Es una lista de estados que nos guarda algunos cambios que hicimos en Staging para poder cambiar de rama sin perder el trabajo que todavía no guardamos en un commit
 
Ésto es especialmente útil porque hay veces que no se permite cambiar de rama, ésto porque porque tenemos cambios sin guardar, no siempre es un cambio lo suficientemente bueno como para hacer un commit, pero no queremos perder ese código en el que estuvimos trabajando.
 
El stashed nos permite cambiar de ramas, hacer cambios, trabajar en otras cosas y, más adelante, retomar el trabajo con los archivos que teníamos en Staging pero que podemos recuperar ya que los guardamos en el Stash.
 
git stash
El comando git stash guarda el trabajo actual del Staging en una lista diseñada para ser temporal llamada Stash, para que pueda ser recuperado en el futuro.
 
Para agregar los cambios al stash se utiliza el comando:
 
git stash
Podemos poner un mensaje en el stash, para asi diferenciarlos en git stash list por si tenemos varios elementos en el stash. Ésto con:
 
git stash save "mensaje identificador del elemento del stashed"
Obtener elelmentos del stash
El stashed se comporta como una Stack de datos comportándose de manera tipo LIFO (del inglés Last In, First Out, «último en entrar, primero en salir»), así podemos acceder al método pop.
 
El método pop recuperará y sacará de la lista el último estado del stashed y lo insertará en el staging area, por lo que es importante saber en qué branch te encuentras para poder recuperarlo, ya que el stash será agnóstico a la rama o estado en el que te encuentres, siempre recuperará los cambios que hiciste en el lugar que lo llamas.
 
Para recuperar los últimos cambios desde el stash a tu staging area utiliza el comando:
 
git stash pop
Para aplicar los cambios de un stash específico y eliminarlo del stash:
 
git stash pop stash@{<num_stash>}
Para retomar los cambios de una posición específica del Stash puedes utilizar el comando:
 
git stash apply stash@{<num_stash>}
Donde el <num_stash> lo obtienes desden el git stash list
 
Listado de elementos en el stash
Para ver la lista de cambios guardados en Stash y así poder recuperarlos o hacer algo con ellos podemos utilizar el comando:
 
git stash list
Retomar los cambios de una posición específica del Stash || Aplica los cambios de un stash específico
 
Crear una rama con el stash
Para crear una rama y aplicar el stash mas reciente podemos utilizar el comando
 
git stash branch <nombre_de_la_rama>
Si deseas crear una rama y aplicar un stash específico (obtenido desde git stash list) puedes utilizar el comando:
 
git stash branch nombre_de_rama stash@{<num_stash>}
Al utilizar estos comandos crearás una rama con el nombre <nombre_de_la_rama>, te pasarás a ella y tendrás el stash especificado en tu staging area.
 
Eliminar elementos del stash
Para eliminar los cambios más recientes dentro del stash (el elemento 0), podemos utilizar el comando:
 
git stash drop
Pero si en cambio conoces el índice del stash que quieres borrar (mediante git stash list) puedes utilizar el comando:
 
git stash drop stash@{<num_stash>}
Donde el <num_stash> es el índice del cambio guardado.
 
Si en cambio deseas eliminar todos los elementos del stash, puedes utilizar:
 
git stash clear
Consideraciones:
 
El cambio más reciente (al crear un stash) SIEMPRE recibe el valor 0 y los que estaban antes aumentan su valor.
Al crear un stash tomará los archivos que han sido modificados y eliminados. Para que tome un archivo creado es necesario agregarlo al Staging Area con git add [nombre_archivo] con la intención de que git tenga un seguimiento de ese archivo, o también utilizando el comando git stash -u (que guardará en el stash los archivos que no estén en el staging).
Al aplicar un stash este no se elimina, es buena práctica eliminarlo.
 
************************************************************************************************************************************************************
Algunos comandos que pueden ayudar cuando colaboren con proyectos muy grandes de github:
 
git log --oneline - Te muestra el id commit y el título del commit.
git log --decorate- Te muestra donde se encuentra el head point en el log.
git log --stat - Explica el número de líneas que se cambiaron brevemente.
git log -p- Explica el número de líneas que se cambiaron y te muestra que se cambió en el contenido.
git shortlog - Indica que commits ha realizado un usuario, mostrando el usuario y el titulo de sus commits.
git log --graph --oneline --decorate y
git log --pretty=format:"%cn hizo un commit %h el dia %cd" - Muestra mensajes personalizados de los commits.
git log -3 - Limitamos el número de commits.
git log --after=“2018-1-2” ,
git log --after=“today” y
git log --after=“2018-1-2” --before=“today” - Commits para localizar por fechas.
git log --author=“Name Author” - Commits realizados por autor que cumplan exactamente con el nombre.
git log --grep=“INVIE” - Busca los commits que cumplan tal cual está escrito entre las comillas.
git log --grep=“INVIE” –i- Busca los commits que cumplan sin importar mayúsculas o minúsculas.
git log – index.html- Busca los commits en un archivo en específico.
git log -S “Por contenido”- Buscar los commits con el contenido dentro del archivo.
git log > log.txt - guardar los logs en un archivo txt
 
************************************************************************************************************************************************************
Git reset y git rm son comandos con utilidades muy diferentes, pero aún así se confunden muy fácilmente.
 
git rm
Este comando nos ayuda a eliminar archivos de Git sin eliminar su historial del sistema de versiones. Esto quiere decir que si necesitamos recuperar el archivo solo debemos “viajar en el tiempo” y recuperar el último commit antes de borrar el archivo en cuestión.
 
Recuerda que git rm no puede usarse así nomás. Debemos usar uno de los flags para indicarle a Git cómo eliminar los archivos que ya no necesitamos en la última versión del proyecto:
 
git rm --cached: Elimina los archivos de nuestro repositorio local y del área de staging, pero los mantiene en nuestro disco duro. Básicamente le dice a Git que deje de trackear el historial de cambios de estos archivos, por lo que pasaran a un estado untracked.
git rm --force: Elimina los archivos de Git y del disco duro. Git siempre guarda todo, por lo que podemos acceder al registro de la existencia de los archivos, de modo que podremos recuperarlos si es necesario (pero debemos usar comandos más avanzados).
git reset
Este comando nos ayuda a volver en el tiempo. Pero no como git checkout que nos deja ir, mirar, pasear y volver. Con git reset volvemos al pasado sin la posibilidad de volver al futuro. Borramos la historia y la debemos sobreescribir. No hay vuelta atrás.
 
Este comando es muy peligroso y debemos usarlo solo en caso de emergencia. Recuerda que debemos usar alguna de estas dos opciones:
 
Hay dos formas de usar git reset: con el argumento --hard, borrando toda la información que tengamos en el área de staging (y perdiendo todo para siempre). O, un poco más seguro, con el argumento --soft, que mantiene allí los archivos del área de staging para que podamos aplicar nuestros últimos cambios pero desde un commit anterior.
 
git reset --soft: Borramos todo el historial y los registros de Git pero guardamos los cambios que tengamos en Staging, así podemos aplicar las últimas actualizaciones a un nuevo commit.
git reset --hard: Borra todo. Todo todito, absolutamente todo. Toda la información de los commits y del área de staging se borra del historial.
¡Pero todavía falta algo!
 
git reset HEAD: Este es el comando para sacar archivos del área de staging. No para borrarlos ni nada de eso, solo para que los últimos cambios de estos archivos no se envíen al último commit, a menos que cambiemos de opinión y los incluyamos de nuevo en staging con git add, por supuesto.
¿Por qué esto es importante?
Imagina el siguiente caso:
 
Hacemos cambios en los archivos de un proyecto para una nueva actualización. Todos los archivos con cambios se mueven al área de staging con el comando git add. Pero te das cuenta de que uno de esos archivos no está listo todavía. Actualizaste el archivo, pero ese cambio no debe ir en el próximo commit por ahora.
 
¿Qué podemos hacer?
 
Bueno, todos los cambios están en el área de Staging, incluido el archivo con los cambios que no están listos. Esto significa que debemos sacar ese archivo de Staging para poder hacer commit de todos los demás.
 
¡Al usar git rm lo que haremos será eliminar este archivo completamente de git! Todavía tendremos el historial de cambios de este archivo, con la eliminación del archivo como su última actualización. Recuerda que en este caso no buscábamos eliminar un archivo, solo dejarlo como estaba y actualizarlo después, no en este commit.
 
En cambio, si usamos git reset HEAD, lo único que haremos será mover estos cambios de Staging a Unstaged. Seguiremos teniendo los últimos cambios del archivo, el repositorio mantendrá el archivo (no con sus últimos cambios pero sí con los últimos en los que hicimos commit) y no habremos perdido nada.
 
Conclusión: Lo mejor que puedes hacer para salvar tu puesto y evitar un incendio en tu trabajo es conocer muy bien la diferencia y los riesgos de todos los comandos de Git.
 
 
************************************************************************************************************************************************************
Forks o Bifurcaciones
Es una característica única de GitHub en la que se crea una copia exacta del estado actual de un repositorio directamente en GitHub, éste repositorio podrá servir como otro origen y se podrá clonar (como cualquier otro repositorio), en pocas palabras, lo podremos utilizar como un git cualquiera
.
Un fork es como una bifurcación del repositorio completo, tiene una historia en común, pero de repente se bifurca y pueden variar los cambios, ya que ambos proyectos podrán ser modificados en paralelo y para estar al día un colaborador tendrá que estar actualizando su fork con la información del original.
.
Al hacer un fork de un poryecto en GitHub, te conviertes en dueñ@ del repositorio fork, puedes trabajar en éste con todos los permisos, pero es un repositorio completamente diferente que el original, teniendo alguna historia en común.
.
Los forks son importantes porque es la manera en la que funciona el open source, ya que, una persona puede no ser colaborador de un proyecto, pero puede contribuír al mismo, haciendo mejor software que pueda ser utilizado por cualquiera.
.
Al hacer un fork, GitHub sabe que se hizo el fork del proyecto, por lo que se le permite al colaborador hacer pull request desde su repositorio propio.
 
Trabajando con más de 1 repositorio remoto
Cuando trabajas en un proyecto que existe en diferentes repositorios remotos (normalmente a causa de un fork) es muy probable que desees poder trabajar con ambos repositorios, para ésto puedes crear un remoto adicional desde consola.
 
git remote add <nombre_del_remoto> <url_del_remoto> 
git remote upstream https://github.com/freddier/hyperblog
Al crear un remoto adicional podremos, hacer pull desde el nuevo origen (en caso de tener permisos podremos hacer fetch y push)
 
git pull <remoto> <rama>
git pull upstream master
Éste pull nos traerá los cambios del remoto, por lo que se estará al día en el proyecto, el flujo de trabajo cambia, en adelante se estará trabajando haciendo pull desde el upstream y push al origin para pasar a hacer pull request.
 
git pull upstream master
git push origin master
