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
Mock supports enabling and using Module Streams as part of the build
process. Devtools supports this and integrates the various mock configs
a developer would need for any configuration (these configs are still
being built now).

To use this, do the following:
```
    mkdir -p $HOME/rocky
    cd $HOME/rocky
    rockyget apache-ivy
    cd apache-ivy/r8-stream-201801
    rockybuild javapackages-tools:201801
```

note: Apache-Ivy has two c8-stream modules to choose from (at the time of
this writing they are: `r8-stream-201801` and `r8-stream-201902`). Each
of them correlate to the `javapackages-tools` module with the respective
streams of `201801` and `201902`. When we call `rockybuild` we need to
include the module:stream that we want this package built for.
