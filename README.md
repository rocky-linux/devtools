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
    rockyget curl
    rockybuild curl
```

This will create a directory structure at `~/rocky/` and you will be able
to find the RPM sources as well as the build directory, logs, and
artificats there.

## Creating a local patch CFG file
If you find that you need to modify the configuration of the package, there
are some helper scripts you can use:

```
    rockymkpatch curl
```

Once you have made your patch directory, you can create the `*.cfg` file in
the `~/rocky/patch/curl.git/ROCKY/CFG/` directory. Any supporting files or
patches you need to create should be put in the `_supporting/` directory.

After you have made your changes there, you should remember to `git commit -a`
these files and then you can rerun the following get and build scripts:
```
    rockyget curl
    rockybuild curl
```

More documentation about the format of the Proto3 CFG file can be found here:
https://wiki.rockylinux.org/en/team/development/debranding/how-to

note: You need to rerun the `rockyget` tool to integrate the CFG changes which
will be applied to all branches of the package automatically. You can verify
that before calling `rockybuild` in the `~/rocky/rpms/curl/r8/` directory.
