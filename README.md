# Codebase

Codebase is a Source Control Management tool. Codebase will save all the changes that you specify to it.

Codebase is just a fun and experimental project and is written entirely in a Bash Script.

There is no network activity over Codebase which means that all the changes and saves stay on your machine.

Any directory can be made into an empty codebase. Codebase allows you make and delete codebases (repositories), save the changes made to the files, go back to the previous ones, show the history of changes, make divisions (branches), trigger (switch) divisions, smoosh (merge) divisions and to cut them out.

### Getting Codebase
Codebase can be clone via ``git``:
```
git clone https://www.github.com/KILLinefficiency/Codebase
```
### Requirements:
Since Codebase is written in Bash Script, ``bash`` is an important requirement. Codebase also requies common Linux tools like ``ls``, ``cat``, ``awk``, etc.

### Setting Codebase up:
The ``cbase.sh`` file in the repository is the main file containing all the code.

There's also an ``install.sh`` file to automate the setting up process. ``install.sh`` makes a directory ``~/.CB`` copies ``cbase.sh`` to ``~/.CB`` as ``cbase`` and adds that directory to the PATH variable.

You can also setup Codebase without using ``install.sh``:
1] Copy ``cbase.sh`` as ``cbase`` because it's inconvinient to type ``.sh`` everytime you write ``cbase``.
```
$ cp cbase.sh cbase
```

2] Change the permissions of the ``cbase`` file to executable.
```
$ chmod 755 cbase
```

3] Copy ``cbase`` file to your desired directory.
```
$ cp cbase <your_desired_directory>
```

4] Add it to the PATH Variable.
```
$ echo "export PATH='<your_desired_directory:$PATH>'" >> ~/.bashrc
```

5] Restart your terminal. Codebase can now be called by running ``cbase``.

You can get help about the different Codebase commands by running:
```
cbase help
```
