# bashconf
A flexible configurator written in bash

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

#### params[$IDX] - required

Contains the name of the parameter.
```
params[$IDX]="backuptype"
```

#### descr[$IDX] - highly recommended

Prosaic description of the parameter
```
descr[$IDX]="Type of backup. Choose an option"
```

#### default[$IDX] - optional

Default value to use if nothing supplied
```
default[$IDX]="local"
```

#### required[$IDX] - optional

Set to 1 if this field must be filled in, set to 0 or leave blank otherwise
```
required[$IDX]=1
```

#### choices[$IDX] - optional

If this is set to a pipe-separated list of choices, then only those choices
will be allowed as possible values
```
choices[$IDX]="s3|ftp|scp|local"
```

#### onlyif[$IDX] - optional

If this is set, it must have a value like "&lt;param&gt;=&lt;value&gt;". When
the condition specified in that value is satisfied, then this field will be 
shown, otherwise it will be hidden and any 'required' setting is ignored
```
onlyif[$IDX]="backuptype=local"
```

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

* $BANNER - override this to change the header from the default. 
* $PROMPT - the prompt which is displayed at the bottom of the parameters list
* $INSTALL_LETTER - if you have no install phase, hence no `${CONF}_install.sh` file, you can set this empty. Otherwise if your install option does not begin with 'I' you might want to change this. Default is `I`.
* $QUIT_LETTER - the letter to quit with, you might change this for i18n reasons. Default is `Q`

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
