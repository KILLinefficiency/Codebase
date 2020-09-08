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

If you don't want to add ``cbase`` to the PATH Variable, you can copy the ``cbase`` executable file into your project directory and use it locally. You'll be able to call Codebase in that directory using:
```
$ ./cbase
```

### Codebase Commands
Codebase works with the following commands:
> * help
> * construct
> * destruct
> * save
> * history
> * goto
> * div
> * ndiv
> * trigger
> * smoosh
> * cut

You can get help about the different Codebase commands by running:
```
$ cbase help
```

#### construct

``construct`` will create an empty codebase in the current working directory.

Using ``construct``:
```
$ cbase construct
```

#### destruct

``destruct`` will remove the existing codebase from the current working directory.U

Using ``destruct``:
```
$ cbase destruct
```

#### save
``save`` makes a copy of the specified file and saves it as a part of the codebase. Every copy is given a unique ID known as "Save ID".

Every save can also be given a save message optionally so that it becomes easy to identify the save.

All the saves go to the ``root`` division of the codebase by default.

Using ``save``:
```
$ cbase save <file_name> <optional_save_message>
```

Like:
```
$ echo "print('Hello World')" > hello.py

$ ls
hello.py

$ cbase save file.py "a hello to the world"
```

This will save the snapshot of the file ``hello.py`` in the directory's codebase.

Multiple saves for multiple files can be made.

#### history

All the saves made in the current division of your codebase can be seen by using ``history``.

Using ``history``:
```
$ cbase history
```

Like:
```
$ ls
hello.py

$ cbase histoy

Save History:

  1 --> hello.py : a hello to the world

```

Here, ``1`` is the Save ID, ``hello.py`` is the file saved and ``a hello to the world`` is the save message.

```
$ cat hello.py
print('Hello World')

$ echo "print('Hello\nWorld')" > hello.py

$ cat hello.py
print('Hello\nWorld')

$ cbase save hello.py "added a new line"

Save History:

  1 --> hello.py : a hello to the world

  2 --> hello.py : added a new line

```

#### goto

``goto`` is used to go back to a previously made save. ``goto`` requires only a Save ID.

Using ``goto``:
```
$ cbase goto <save_id>
```

Let's make one more save:
```
$ echo "print('Hello World. How are you?')" > hello.py

$ cbase save hello.py "greet and ask"

$ cbase history

Save History:

  1 --> hello.py : a hello to the world

  2 --> hello.py : added a new line

  3 --> hello.py : greet and ask

```

Here ``1``, ``2`` and ``3`` are the Save IDs for the previous and current versions of the file ``hello.py``.

The file ``hello.py`` is at the latest save now (save ``3``).

You can go back to save ``2`` or save ``1`` easily using ``goto``.
Like:

```
$ cat hello.py
print('Hello World. How are you?')

$ cbase goto 2

$ cat hello.py
print('Hello\nWorld')

$ cbase goto 1

$ cat hello.py
print('Hello World')
```

The file ``hello.py`` was reverted back to a previous save, save ``2`` and then to save ``1``.

The file ``hello.py`` can be brought to the latest save, save ``3`` too.
```
$ cbase goto 3

$ cat hello.py
print('Hello World. How are you?')
```

#### div

``div`` creates a new division. A division is just another copy of your code, or in other terms, it's a branch.

There is only one default division callled ``root`` in your codebase. But more divisions can be created.

Using ``div``:
```
$ cbase div <division_name>
```

Like,
```
$ cbase div feature
```
This will create a new division named ``feature``.

#### ndiv

``ndiv`` helps you to see the total number of divisions and the current working division.

Using ``ndiv``:
```
$ cbase ndiv
```

Like,
```
$ cbase ndiv
--> root

$ cbase div feature

$ cbase div batman

$ cbase ndiv
    batman
    feature
--> root
```

The arrow, ``-->`` points to the currently active division.
