
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# FILE: /home/rbyers/bin/.jenkinsEL6Build.sh
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# This script runs the jenkinsEL6Build-*.sh scripts from scratch.
#
# NOTES:
#
# Any pre-existing coretracer directory must be deleted prior to
# running this script. This script refuses to do anything if
# the directory already exists.
#
# THIS HERE SCRIPT FILE MUST BE SOURCED (so that functions defined
# at login are still defined)
#
# If RESTORE_BUILDSCRIPT_SOURCE_DIR is defined and the directory
# it points to exists, the jenkinsEL6build*.sh scripts from that
# location *WILL* be copied to the working directory. This occurs
# immediately following 'git clean'
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    JENKINS_BUILD_SH=jenkinsEL6Build.sh
    JENKINS_BUILD_COMMON_SH=jenkinsEL6Build-common.sh
    JENKINS_BUILD_CTSIM_SH=jenkinsEL6Build-ctsim.sh
    JENKINS_BUILD_SIM_SH=jenkinsEL6Build-sim.sh
    C_ONE_DIR=/jenkins/workspace/repos/c1
    CTDIR=$C_ONE_DIR/coretracer
    TARGARCH="--host x86_64-redhat-linux"
    #VERBOSE="--verbose"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# If this is defined and the directory to which its value points exists,
# the jenkinsEL6build*.sh scripts from that location *WILL* be copied to
# the working directory. This occurs immediately following 'git clean'

    RESTORE_BUILDSCRIPT_SOURCE_DIR=/home/rbyers/working_directory/today

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function INFO()
{
    date +"[INFO] [%Y-%m%d-%H%M%S.%N] $*"
}

function ENTER()
{
    INFO === Entering $*
}

function LEAVE()
{
    INFO === Leaving $*
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
prepare()
{
    ENTER prepare
    module purge
    module load como/tools/git/ como/tools/emacs/26.1 como/python/3.6.1
    [ -d $CTDIR ] && { echo "Punting ($CTDIR already exists)"; exit; }
    [ -d $C_ONE_DIR ] && { echo "Punting ($C_ONE_DIR already exists)"; exit; }
    LEAVE prepare
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
git_clone_coretracer()
{
    ENTER git_clone_coretracer
    mkdir -p $CTDIR
    pushd $C_ONE_DIR
    git clone --recursive git@git.dsp.eus.mediatek.inc:coretracer.git
    [ -d $RESTORE_BUILDSCRIPT_SOURCE_DIR ] && {
        echo RESTORING WORKING VERSIONS OF build scripts...
        cp -nf $RESTORE_BUILDSCRIPT_SOURCE_DIR/jenkinsEL6Build-* $CTDIR 
        chmod +x $RESTORE_BUILDSCRIPT_SOURCE_DIR/jenkinsEL6Build-* $CTDIR 
        /bin/ls -l $RESTORE_BUILDSCRIPT_SOURCE_DIR/jenkinsEL6Build-* $CTDIR 
    }
    popd
    LEAVE git_clone_coretracer
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
jenkinsEL6Build()
{
    ENTER jenkinsEL6Build
    pushd $CTDIR
    INFO Calling $JENKINS_BUILD_SH with the following args..
    INFO "     VERBOSE: $VERBOSE"
    INFO "    TARGARCH: $TARGARCH"
    ./$JENKINS_BUILD_SH $VERBOSE $TARGARCH
    popd
    LEAVE jenkinsEL6Build
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
jenkinsEL6Build_ctsim()
{
    ENTER jenkinsEL6Build_ctsim
    pushd $CTDIR
    INFO Calling $JENKINS_BUILD_CTSIM_SH with the following args..
    INFO "     VERBOSE: $VERBOSE"
    INFO "    TARGARCH: $TARGARCH"
    ./$JENKINS_BUILD_CTSIM_SH $VERBOSE $TARGARCH
    popd
    LEAVE jenkinsEL6Build_ctsim
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
jenkinsEL6Build_sim()
{
    ENTER jenkinsEL6Build_sim
    pushd $CTDIR
    INFO Calling $JENKINS_BUILD_SIM_SH with the following args..
    INFO "     VERBOSE: $VERBOSE"
    INFO "    TARGARCH: $TARGARCH"
    ./$JENKINS_BUILD_SIM_SH $VERBOSE $TARGARCH
    popd
    LEAVE jenkinsEL6Build_sim
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  * * *  M A I N  * * *

prepare
git_clone_coretracer
#jenkinsEL6Build_sim
#jenkinsEL6Build_ctsim
jenkinsEL6Build

