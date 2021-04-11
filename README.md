A quick helper for getting a Rocky package maintainer build development
configuration setup.

## Installation
From this source directory, run the following commands:


```
    make
    sudo make install
```

This installation will automatically install `nginx` and will configure a
local repository to be run and usable at: /usr/share/nginx/html/repo

note: The permissions on this repository are wide open, so please tune if
you are on a shared system.


## Using these tools
Once these tools are installed, you will be able to do the following:

```
    mkdir -p $HOME/rocky
    cd $HOME/rocky
    rockyget curl
    cd curl/r8
    rockybuild
```

All of the built RPMs and logs can be found in the current directory and
will be also made available in the package repository mentioned above.

## Debugging module streams
Mock supports enabling custom build options as well as module streams for
specific builds. To do this, you will need to edit the configuration file
that is installed to `/etc/mock/templates/myrocky.tpl` and add/modify the
build macros as well as add or comment out the module stream needed for
that build.
