# Pointer to all the "extra" repos that are produced from Rocky builds

config_opts['dnf.conf'] += """
[RockyDevelBaseOS]
name=Rocky Devel Build Dependencies for BaseOS
baseurl=https://rocky.lowend.ninja/RockyDevel/BaseOS_devel/
enabled=1
gpgcheck=0
priority=200
#module_hotfixes=1


[RockyDevelAppStream]
name=Rocky Devel Build Dependencies for AppStream
baseurl=https://rocky.lowend.ninja/RockyDevel/AppStream_devel/
enabled=1
gpgcheck=0
priority=200
#module_hotfixes=1


[RockyDevelPowerTools]
name=Rocky Devel Build Artifacts from PowerTools
baseurl=https://rocky.lowend.ninja/RockyDevel/PowerTools_devel/
enabled=1
gpgcheck=0
priority=200
#module_hotfixes=1


[RockyDevelExternalDeps]
name=External Dependencies for Rocky Builds
baseurl=https://rocky.lowend.ninja/RockyDevel/External_Deps/
enabled=1
gpgcheck=0
priority=200
#module_hotfixes=1


# Adding our produced packages as of build pass 6:
[RockyBaseOS]
name=Rocky BaseOS Packages
baseurl=https://rocky.lowend.ninja/RockyDevel/BaseOS_final/
enabled=1
gpgcheck=0
priority=210
#module_hotfixes=1


[RockyAppStream]
name=Rocky AppStream Packages
baseurl=https://rocky.lowend.ninja/RockyDevel/AppStream_final/
enabled=1
gpgcheck=0
priority=210
#module_hotfixes=1


[RockyPowerTools]
name=Rocky PowerTools Packages
baseurl=https://rocky.lowend.ninja/RockyDevel/PowerTools_final/
enabled=1
gpgcheck=0
priority=210
#module_hotfixes=1



################################################################


#[RockyDependencies]
#name=Rocky External Build Dependencies
#baseurl=https://download.copr.fedorainfracloud.org/results/nalika/rockylinux-tools/epel-8-$basearch/
#enabled=0
#gpgkey=https://download.copr.fedorainfracloud.org/results/nalika/rockylinux-tools/pubkey.gpg
#priority=150



#[CentOSHighAvailability]
#name=CentOS High Availability Repo
#baseurl=http://mirror.centos.org/centos/8/HighAvailability/x86_64/os/
#enabled=0
#gpgcheck=0
#priority=160



# Another possibility from raven_kg : https://pkgs.dyn.su/el8/bootstrap/x86_64/
#
#[RockyBootstrap]
#name=Rocky Bootstrap Devel
#baseurl=https://pkgs.dyn.su/rocky-8/bootstrap/x86_64/
#enabled=0
#gpgcheck=0

"""


# This is used for enabling a proper non-default module for compiling bind
#config_opts['module_setup_commands'] = [
#('disable', 'idm'),
#('enable',  'idm:DL1'),
#]


#  ('install', 'nodejs:13/development'),
#  ('disable', 'nodejs'),
#]

