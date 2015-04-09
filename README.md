# bashconf
A flexible configurator written in bash

## Usage

As a submodule: 
```
  git submodule add https://github.com/marsbard/bashconf.git
```

## Basic minimal configuration

We will assume in the following examples that an envar `CONF` 
has been set to be the prefix for this configuration. For example, 
in https://github.com/marsbard/puppet-alfresco which uses this 
configurator you can see that `CONF=config/ootb` refers to files
in the `config/` folder with prefix `ootb_`

None of the configuration files are required to be executable
since they are included using the "source" command from within
bashconf.sh

### Parameters file

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

