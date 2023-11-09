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


## Getting and building a Rocky Linux package
Once these tools are installed, you will be able to do the following:

```
    rockyget sed
    rockybuild sed
```

This will create a directory structure at `~/rocky/` and you will be able
to find the RPM sources as well as the build directory, logs, and
arifiacts there.

## Debugging and patching packages
When build errors happen, and you need to create a patch for a package,
you can use the following example to get you going:

```
    # Creates a working directory, will take optional branch
    rockyprep sed
    cd ~/rocky/_work/sed/*

    # A build error exists when running in nspawn container on the builder
    # for this test, so let's "exit 0" near the top...
    vim testsuite/inplace-selinux.sh

    # Create a patch configuration from the working directory and name the
    # patch file. This will create the patch, integrate it into the SPEC
    # file, and "reget" the sed package. If you need to edit or view the
    # Proto3 config and patch, it can be found here: ~/rocky/patch/sed/r8/
    rockypatch inplace-selinux-notest.patch

    # Now you can test your build
    rockybuild sed

```

## Container use


Build a container and tag it. Mock cannot run in an unprivileged container with
simple isolation due to userns issues, so any calls to mock must be performed
outside the build step.

```
podman build -t localhost/build-bash --build-arg PACKAGE=bash .
```

Tag it any way you want, then run it. By default it will run '/entrypoint.sh
build' which reads $BRANCH and $PACKAGE from the environment, set by previous
build stages. 

```
podman run -v "$PWD/artifacts:/artifacts:z,rw" --privileged localhost/build-bash:latest prep build
```

Without any other intervention, this will pull sources from git.rockylinux.org and process them using srpmproc to apply patches, if available, from git.rockylinux.org/staging/patch/. If no patch repo exists upstream, one will be created. Alternatively, volume mount a local patch repo (with the latest patches from git.r.o if applicable) to /root/rocky/patch/<package>.git.

Builds artifacts are copied to /artifacts, which you should mount read write and with any selinux flags where necessary. The default example above mounts $PWD/artifacts to /artifacts with selinux (z) and read-write (rw) flags.


The commands `rockyget`, `rockyprep`, and `rockybuild`, as well as `srpmproc` are available in the PATH, and will read the PACKAGE and BRANCH environment variables by default, unless overriden by different args. Additionally, aliases `get`, `prep`, and `build` are set in /root/.bashrc for ease of use in interactive sessions.
