# bashconf
A flexible configurator written in bash

## Features

* Accept an arbitrary number of parameters and allow editing of their
values, and finally write out a configuration file and optionally run
an install phase
* Allow showing/hiding of some parameters based on [the value of other
parameters](#onlyifidx---optional)
* Allow constraining of responses to [certain values](#choicesidx---optional)
* (soon) [Internationalisation support](/marsbard/bashconf/issues/2)
* (soon) [Wizard mode](/marsbard/bashconf/issues/1)

## Usage

As a submodule: 
```
  git submodule add https://github.com/marsbard/bashconf.git
  git submodule init
  git submodule update
```

## Basic minimal configuration

We will assume in the following examples that an envar `CONF` 
has been set to be the prefix for this configuration. For example, 
in https://github.com/marsbard/puppet-alfresco which uses this 
configurator you can see that `CONF=config/ootb` refers to files
in the `config/` folder with prefix `ootb_` - see 
https://github.com/marsbard/puppet-alfresco/tree/develop/config

None of the configuration files are required to be executable
since they are included using the "source" command from within
bashconf.sh

### Parameters file `${CONF}_params.sh` - required

This file is named `${CONF}_params.sh`.

You will set up a number of arrays in this file, each array index, 
e.g. 0, 1, 2, etc. will refer to an individual parameter. The following
parameters can or must be used:

#### `params[$IDX]` - required

Contains the name of the parameter.
```
params[$IDX]="backuptype"
```

#### `descr[$IDX]` - highly recommended

Prosaic description of the parameter
```
descr[$IDX]="Type of backup. Choose an option"
```

#### `default[$IDX]` - optional

Default value to use if nothing supplied
```
default[$IDX]="local"
```

#### `required[$IDX]` - optional

Set to 1 if this field must be filled in, set to 0 or leave blank otherwise
```
required[$IDX]=1
```

#### `choices[$IDX]` - optional

If this is set to a pipe-separated list of choices, then only those choices
will be allowed as possible values
```
choices[$IDX]="s3|ftp|scp|local"
```

#### `onlyif[$IDX]` - optional

If this is set, it must have a value like "&lt;param&gt;=&lt;value&gt;". When
the condition specified in that value is satisfied, then this field will be 
shown, otherwise it will be hidden and any 'required' setting is ignored
```
onlyif[$IDX]="backuptype=local"
```
To be clear, the left hand side of the condition cannot be any envar, it must
be a parameter, in other words, its value will be checked using `get_param <param-name>`

### Example parameters file

Here is a short example illustrating the parameters settings:
```
IDX=0
params[$IDX]="backuptype"
descr[$IDX]="Type of backup. Choose one of the options and then configure the appropriate setti
default[$IDX]="local"
required[$IDX]=1
choices[$IDX]="s3|ftp|scp|local"

IDX=$(( $IDX + 1 ))
params[$IDX]="local_backup_folder"
descr[$IDX]="Local backup folder. If you are using this you have probably mounted a remote back
default[$IDX]="/mnt/backup"
required[$IDX]=1
onlyif[$IDX]="backuptype=local"

```


### Output file - `${CONF}_output.sh` - required

This file should produce your output file from the supplied parameter values.

You have access to all the methods in the bashconf script since it uses "source"
to include your output file.


### Pre file - `${CONF}_pre.sh` - optional

If it exists this will be run before the configurator menu is shown.

It allows you to override some envars in order to change the behaviour of the configurator.
You have access to the colours `${GREEN}`, `${BLUE}`, etc. as well as the other vars and 
methods from bashconf.sh.

* `$BANNER` - override this to change the header from the default. 
* `$PROMPT` - the prompt which is displayed at the bottom of the parameters list
* `$INSTALL_LETTER` - if you have no install phase, hence no `${CONF}_install.sh` file, you can set this empty. Otherwise if your install option does not begin with 'I' you might want to change this. Default is `I`.
* `$QUIT_LETTER` - the letter to quit with, you might change this for i18n reasons. Default is `Q`
* `$WRITE_ON_QUIT` - Whether we write the files when we quit. Default is 1, use 0 to not write.

#### Example pre file
```
INSTALL_LETTER=A
PROMPT="Please choose an index number to edit, A to apply configuration, or Q to quit"
```

### Install file - `${CONF}_install.sh` - optional

If you want to run an install phase you may optionally create this script which 
will be run when the user presses the $INSTALL_LETTER.

Like all the other scripts it is included via "source" and so may reference 
any other part of the global scope.

If this file is not found, but an INSTALL_LETTER is defined, you will be 
warned when starting the configurator and if you eventually attempt to install
you will see an error and no install will be attempted

#### Sample install file
Perhaps not the best example as it does not refer to any internal methods
or vars but at least it does show that it is just a normal bash script.

```
source ../install/inc-puppet.sh

if [ "`which puppet`" = "" ]
then
  install_puppet
fi

./install/modules-for-vagrant.sh

puppet apply --modulepath=modules go.pp

if [ $? != 0 ]; then exit 99; fi

echo
echo Completed, please allow some time for alfresco to start
echo You may tail the logs at ${tomcat_home}/logs/catalina.out
echo
echo Note that you can reapply the puppet configuration from this directory with:
echo "  puppet apply --modulepath=modules go.pp"
echo
echo You can also run the tests with:
echo "  puppet apply --modulepath=modules test.pp"
echo
```

## Useful methods and envars

### In bashconf.sh

#### Variables

These are not really meant to be overridden in your code, apart from in a 
recognised extension point like the pre script, where the overrides are 
documented.

Overriding other variables may have unpredictable effects. Don't do it. 
It's hacky. Treat them as read only please. If you do change one, e.g.
`${RES_COL}` please change it back ASAP.

* Colours and other ANSI escapes (e.g. `echo -e "${YELLOW}Hello${RESET}"`)
  * `$YELLOW`
  * `$PURPLE`
  * `$WHITE`
  * `$GREEN`
  * `$BLUE`
  * `$CYAN`
  * `$RED`
  * `$MOVE_TO_COL` - moves to column $RES_COL, set RES_COL first if you want to change it, default is 35, please set it back when done!
  * `$RES_COL` - current column number that $MOVE_TO_COL moves to (not an ANSI escape)
  * `$RESET` - reset all ANSI colours back to default
* 'Chrome' overridable in pre script
  * `$BANNER` - shown at the top of the parameter list
  * `$INSTALL_LETTER` - Letter to press to start install phase, default `I`
  * `$QUIT_LETTER` - Letter to press to quit, default `Q`
  * `$PROMPT` - Prompt shown at bottom of parameter list
* Miscellaneous
  * `$ANS_FILE` - where the answer file is stored

#### Methods

Actually most of the methods in here are for internal use and probably not 
that useful outside. 

* `paramloop` - runs the REPL
* `banner` - display whatever we set `$BANNER` to
* `read_entry` - read an entry and either take some action (`INSTALL_LETTER`, `QUIT_LETTER`) or else edit the parameter represented by the entry
* `write_answers` - save whatever answers have been input into a data file
* `read_answers` - read a previously saved data file
* `edit_param` - accept a value for a parameter, checking `allowed_choice` as required
* `check_required` - see if all required parameters have values, return 0 if yes, or else return the number of parameters which don't have values

### In funcs.sh

#### Methods
These might be useful inside an output or install script

* `allowed_choice $IDX $ANSWER` - echo `true` if the supplied answer is among the allowed choices, `false` otherwise
  * e.g. `allowed_choice 3 blue` would echo `false` if `$choices[3]="red|green|yellow"`
* `count_effective_params` - echoes the number of parameters that are not hidden due to `onlyif` clauses
* `get_effective_idx $IDX` - given an apparent index number, with some options hidden due to `onlyif` clauses, return the real index number, as if `onlyif` was not being considered.
* `get_effective_answer $IDX` - given an apparent index number, get its answer. calls `get_effective_idx`
* `get_answer $IDX` - get answer for real index number (not affected by `onlyif`)
* `get_param $NAME` - get the value (answer) of this named parameter
  * e.g. `get_param backuptype` might return `scp`
* `get_onlyif $IDX` - echo `true` if the `onlyif` clause for this $IDX is satisfied, otherwise echo `false`
  * so if `$onlyif[5]="backuptype=scp"` then if `get_param backuptype` is not "scp" this will echo `false`, or `true` if it is

