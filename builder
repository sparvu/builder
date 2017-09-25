#!/bin/sh
#
#  Kronometrix Development tools, builder the master script engine 
#
#  Copyright (c) 2017 Stefan Parvu (www.kronometrix.org).
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software Foundation,
#  Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#  (http://www.gnu.org/copyleft/gpl.html)

# VERSION: 3.6

usage() {

cat << END
Usage: $0 [-ht] [-p prefix_path]
          [-b build_number] [-m module_name] 
          [-a appliance] pkg version
pkg:
   recording, auth, avimet, kernel, mesg, mon
version:
   1.0.0

OPTIONS
  -a appliance: x64, arm
  -b build_number: 01, 10, 102
  -m module_name: perl, openssl, idn, curl,  wcurl, sysstat, scripts
  -p prefix_path: /opt/kronometrix
  -t test_mode
  -h help

  eg, builder recording 1.0.0       # build recording 0.73
      builder auth 1.0.0            # build analytics auth 1.0.0
      builder -a arm auth 1.0.0     # build arm analytics auth 1.0.0
      builder kernel 1.0.0          # build analytics kernel 1.0.0
      builder mon 1.0.17            # build appliance mon 1.0.17

Notes:
   Make sure you have defined WORKSPACE_PREFIX variable before running
   builder
END
exit 1
}


# ######### #
# MAIN BODY #
# ######### #

## recording
perl_sem=0
lidn_sem=0
lcrl_sem=0
lwcl_sem=0
wrec_sem=0
recs_sem=0
test_sem=0
nrec_sem=0
ossl_sem=0
syss_sem=0
libusb_sem=0
rec1_sem=0
rpm_sem=0
deb_sem=0
fbsd_pkg_sem=0

idn_done=0
libusb_done=0
perl_done=0
ossl_done=0
curl_done=0
cares_done=0
wrec_done=0
recs_done=0
nrec_done=0
tests_done=0
wwwcurl_done=0
netcurl_done=0
x509_done=0
procdaemon_done=0
perlssl_done=0
deviceusb_done=0
deviceserial_done=0
sysstat_done=0
tar_pkg_done=0
deb_pkg_done=0
rpm_pkg_done=0
fbsd_pkg_done=0
##

##appliance
x64_sem=0
arm_sem=0
##

##auth
auth_redis_done=0
auth_openresty_done=0
auth_luatz_done=0
auth_lua_resty_template_done=0
auth_lua_inspect_done=0
auth_lua_router_done=0
auth_lua_resty_http_simple_done=0
auth_fin_done=0
auth_config_done=0
auth_tar_pkg_done=0
auth_deb_pkg_done=0
auth_rpm_pkg_done=0
auth_fbsd_pkg_done=0
##

##avimet
avimet_openresty_done=0
avimet_luatz_done=0
avimet_lua_resty_template_done=0
avimet_lua_inspect_done=0
avimet_lua_router_done=0
avimet_lua_resty_http_simple_done=0
avimet_fin_done=0
avimet_config_done=0
avimet_tar_pkg_done=0
avimet_deb_pkg_done=0
avimet_rpm_pkg_done=0
avimet_fbsd_pkg_done=0
##

##kernel
kernel_openresty_done=0
kernel_luafs_done=0
kernel_luazlib_done=0
kernel_struct_done=0
kernel_zipwriter_done=0
kernel_luatz_done=0
kernel_lua_resty_template_done=0
kernel_lua_router_done=0
kernel_lua_resty_http_done=0
kernel_lua_resty_http_simple_done=0
kernel_lua_resty_prettycjson_done=0
kernel_lua_inspect_done=0
kernel_libdate_done=0
kernel_redis_done=0
kernel_fin_done=0
kernel_config_done=0
kernel_tar_pkg_done=0
kernel_deb_pkg_done=0
kernel_rpm_pkg_done=0
kernel_fbsd_pkg_done=0
##

##mesg
mesg_openresty_done=0
mesg_lua_resty_template_done=0
mesg_lua_inspect_done=0
mesg_lua_router_done=0
mesg_lua_resty_smtp_done=0
mesg_fin_done=0
mesg_config_done=0
mesg_tar_pkg_done=0
mesg_deb_pkg_done=0
mesg_rpm_pkg_done=0
mesg_fbsd_pkg_done=0
##

##mon
mon_perl_done=0
mon_curl_done=0
mon_wwwcurl_done=0
mon_ossl_done=0
mon_netssl_done=0
mon_procdaemon_done=0
mon_pkg_done=0
mon_tar_pkg_done=0
mon_tests_done=0
mon_done=0



# Source Global SDR Settings
PWD=`dirname $0`
. ${PWD}/setenv

while getopts ":a:b:m:p:ht" arg
do
    case "${arg}" in

    a)
        appliance=$OPTARG

        case "$appliance" in
            x64)
                x64_sem=1
            ;;

            arm)
                arm_sem=1
            ;;

            *)
                echo "Not supported appliance type!"
                usage
            ;;
        esac
    ;;

    b)
        build_num=$OPTARG
    ;;


    h)
        usage
    ;;

    p)
        iprefix=$OPTARG
        if [ ! -d $iprefix ]; then
            usage
        fi
    ;;

    m)
        module=$OPTARG
        case "$module" in
            
            perl)
                perl_sem=1
            ;;

            openssl)
                ossl_sem=1
            ;;

            curl)
                lcrl_sem=1
            ;;
 
            nrec)
                nrec_sem=1
            ;;

            sysstat)
              if [ "$OS_NAME" != "linux" ]; then
                echo "Error: sysstat is a Linux specific pkg !\n"
                exit 1
              fi
              syss_sem=1
            ;;

            scripts)
                recs_sem=1
            ;;

            rec1)
		rec1_sem=1
            ;;

            rpm)
                rpm_sem=1
            ;;

            deb)
                deb_sem=1
            ;;

            pkg)
                fbsd_pkg_sem=1
            ;;

            libusb)
                libusb_sem=1
            ;;

            *)
                echo "Not supported module!"
                usage
            ;;
        esac
    ;;
    
    t)
        test_sem=1
    ;;

    esac
done

shift `expr $OPTIND - 1`

# check arguments
if [ $# -lt 2 -o $# -gt 2 ]; then
    usage
fi

version=$2
module=$1


# check workspace variable

if [ ! -z "$WORKSPACE_PREFIX" ]; then
   WORKSPACE="${WORKSPACE_PREFIX}"
else
   usage
fi


# Status File
STATFILE="build.${module}.${PT_NAME}.${HOSTNAME}"
BUILD_LOG="${module}.${PT_NAME}.${HOSTNAME}.${version}.log"

# status file
if [ -f /var/tmp/${STATFILE} ]; then
    echo "Error: already running, status file: build.${module}.${PT_NAME}.${HOSTNAME}"
    exit 1
else
    touch /var/tmp/${STATFILE}
fi


case "$OS_NAME" in
    sunos)
         
	# source here the engine for Solaris
        case "$module" in
	 recording)

             iprefix=${iprefix:-/opt/kronometrix}
             iuser=krmx

             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"
             case "$version" in
                 1.[0-4]*)
                  . ${PWD}/engine.rec.solaris.10x
                  ;;
               
                 *)
                   usage
                 ;;
             esac
         ;;

         *)
            usage
         ;;
        esac
    ;;

    linux)

        case "$module" in
         recording)

             iprefix=${iprefix:-/opt/kronometrix}
             iuser=krmx

             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-4]*)
                  . ${PWD}/engine.rec.linux.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;

         auth)

             # default appliance
             if [ -z "$appliance" ]; then
                 if [ "$PT_NAME" = "armv6l" ]; then
                     appliance="arm"
                     arm_sem=1
                 else
                     appliance="x64"
                     x64_sem=1
                 fi
             fi

             iprefix=${iprefix:-/opt/kronometrix/auth}
             iuser=krmx

             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-4]*)
                  . ${PWD}/engine.auth.linux.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;

         avimet)
   
             # default appliance
             if [ -z "$appliance" ]; then
                 if [ "$PT_NAME" = "armv6l" ]; then
                     appliance="arm"
                     arm_sem=1
                 else
                     appliance="x64"
                     x64_sem=1
                 fi
             fi

             iprefix=${iprefix:-/opt/kronometrix/avimet}
             iuser=krmx

             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"
            
             case "$version" in
                 1.[0-4]*)
                  . ${PWD}/engine.avimet.linux.10x
                  ;;
             
                 *)
                   usage
                 ;;
             esac
         ;;

         mesg)

             # default appliance
             if [ -z "$appliance" ]; then
                 if [ "$PT_NAME" = "armv6l" ]; then
                     appliance="arm"
                     arm_sem=1
                 else
                     appliance="x64"
                     x64_sem=1
                 fi
             fi

             iprefix=${iprefix:-/opt/kronometrix/mesg}
             iuser=krmx

             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-4]*)
                  . ${PWD}/engine.mesg.linux.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;

         kernel)

             # default appliance
             if [ -z "$appliance" ]; then
                 if [ "$PT_NAME" = "armv6l" ]; then
                     appliance="arm"
                     arm_sem=1
                 else
                     appliance="x64"
                     x64_sem=1
                 fi
             fi
      
             iprefix=${iprefix:-/opt/kronometrix/kernel}
             iuser=krmx
             
             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-4]*)
                  . ${PWD}/engine.kernel.linux.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;

         *)
            usage
         ;;
        esac

    ;;


    freebsd)

        case "$module" in
         recording)

             iprefix=${iprefix:-/opt/kronometrix}
             iuser=krmx

             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-6]*)
                  . ${PWD}/engine.rec.freebsd.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;

         auth)

             # default appliance
             if [ -z "$appliance" ]; then
                 if [ "$PT_NAME" = "armv6" ]; then
                     appliance="armv6"
                     arm_sem=1
                 else
                     appliance="x64"
                     x64_sem=1
                 fi
             fi
      
             iprefix=${iprefix:-/opt/kronometrix/auth}
             iuser=krmx
             
             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-6]*)
                  . ${PWD}/engine.auth.freebsd.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;

         avimet)
            
             # default appliance
             if [ -z "$appliance" ]; then
                 if [ "$PT_NAME" = "armv6" ]; then
                     appliance="armv6"
                     arm_sem=1
                 else
                     appliance="x64"
                     x64_sem=1
                 fi
             fi

             iprefix=${iprefix:-/opt/kronometrix/avimet}
             iuser=krmx

             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-6]*)
                  . ${PWD}/engine.avimet.freebsd.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;



         mesg)

             # default appliance
             if [ -z "$appliance" ]; then
                 if [ "$PT_NAME" = "armv6" ]; then
                     appliance="armv6"
                     arm_sem=1
                 else
                     appliance="x64"
                     x64_sem=1
                 fi
             fi

             iprefix=${iprefix:-/opt/kronometrix/mesg}
             iuser=krmx

             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-6]*)
                  . ${PWD}/engine.mesg.freebsd.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;

         kernel)

             # default appliance
             if [ -z "$appliance" ]; then
                 if [ "$PT_NAME" = "armv6" ]; then
                     appliance="armv6"
                     arm_sem=1
                 else
                     appliance="x64"
                     x64_sem=1
                 fi
             fi
      
             iprefix=${iprefix:-/opt/kronometrix/kernel}
             iuser=krmx
             
             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-6]*)
                  . ${PWD}/engine.kernel.freebsd.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;

         mon)

             iprefix=${iprefix:-/opt/kronometrix/mon}
             iuser=krmx

             WORKSPACE="${WORKSPACE_PREFIX}/kronometrix"

             case "$version" in
                 1.[0-6]*)
                  . ${PWD}/engine.mon.freebsd.10x
                  ;;

                 *)
                   usage
                 ;;
             esac
         ;;


         *)
            usage
         ;;

        esac

    ;;

    *)
        WORKSPACE=
	echo "Not supported module!"
        usage
    ;;

esac

if [ ! -d ${WORKSPACE} ]; then
    echo "Error: Invalid workspace structure: build"
    exit 1
fi

if [ -d ${WORKSPACE}/${module} ]; then
    cd ${WORKSPACE}/${module}
else
    echo "Error: Invalid workspace structure: wrong module"
    exit 1
fi


if [ "$OS_NAME" = "sunos" ]; then
    start=`nawk 'BEGIN{print srand()}'`
else
    start=`date +%s`
fi

echo ""
echo "#################################################################"
echo "# Build Engine                                                  #"
echo "#################################################################"
echo "# Start: `date`"
if [ ! -z "$appliance" ]; then
    echo "# Appliance: $appliance"
fi
echo "# Target: ${OS_NAME} ${PT_NAME}"
echo "# Module: $module"
echo "# Version: $version"
echo "#################################################################"

case "$module" in
    recording)
    echo "" > ${BUILD_PATH}/${BUILD_LOG}

    if [ $libusb_sem -eq 1 ]; then
        build_rec_deviceusb
    elif [ $ossl_sem -eq 1 ]; then
        build_rec_ossl
    elif [ $rpm_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xrhel" -o "x${DIST_ID}" = "xcentos" -o "x${DIST_ID}" = "xsles" ]; then
            build_rec_pkg
        else
            echo "Error: not a RPM installation, cannot build rpm pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $deb_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xdebian" -o \
             "x${DIST_ID}" = "xubuntu" -o \
             "x${DIST_ID}" = "xraspbian" ]; then
            build_rec_pkg
        else
            echo "Error: not a DEB installation, cannot build deb pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $fbsd_pkg_sem -eq 1 ]; then
        build_rec_pkg
    else 
        build_rec_perl
        build_rec_ossl
        build_rec_perlssl
        build_rec_deviceserial
        if [ "$PT_NAME" = "armv7l" -o \
             "$PT_NAME" = "armv6"  ]; then
            build_rec_deviceusb
        fi
        #build_rec_cares
        build_rec_curl
        build_rec_wcurl
        build_rec_ncurl
        build_rec_x509
        if [ "$OS_NAME" = "linux" ]; then
            build_rec_sysstat
        fi
        build_rec_klib
  
        build_rec_scripts
        
        test_rec_scripts

        # currently we support Linux deb, rpm
        if [ "$OS_NAME" = "linux" -o \
             "$OS_NAME" = "freebsd"  ]; then
            build_rec_pkg
        fi
    fi
    ;;


 auth)
    echo "" > ${BUILD_PATH}/${BUILD_LOG}

    if [ $rpm_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xrhel" -o "x${DIST_ID}" = "xcentos" ]; then
            build_auth_pkg
        else
            echo "Error: not a RPM installation, cannot build rpm pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $deb_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xdebian" -o \
             "x${DIST_ID}" = "xubuntu" -o \
             "x${DIST_ID}" = "xraspbian" ]; then
            build_auth_pkg
        else
            echo "Error: not a DEB installation, cannot build deb pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $fbsd_pkg_sem -eq 1 ]; then
        build_auth_pkg 
    else 
        build_auth_openresty
        build_auth_template
        build_auth_router
        build_auth_httpsimple
        build_auth_luatz

        if [ ! -z "$build_num" ]; then
            build_auth_inspect
        fi

        build_auth_redis
        build_auth_config
        build_auth_fin

        # currently we support Linux(deb,rpm), FreeBSD(pkg)
        if [ "$OS_NAME" = "linux" -o \
             "$OS_NAME" = "freebsd"  ]; then
            build_auth_pkg
        fi

    fi
    ;;

 avimet)
    echo "" > ${BUILD_PATH}/${BUILD_LOG}

    if [ $rpm_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xrhel" -o "x${DIST_ID}" = "xcentos" ]; then
            build_avimet_pkg
        else
            echo "Error: not a RPM installation, cannot build rpm pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $deb_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xdebian" -o \
             "x${DIST_ID}" = "xubuntu" -o \
             "x${DIST_ID}" = "xraspbian" ]; then
            build_auth_pkg
        else
            echo "Error: not a DEB installation, cannot build deb pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $fbsd_pkg_sem -eq 1 ]; then
        build_avimet_pkg
    else
        build_avimet_openresty
        build_avimet_template
        build_avimet_router
        build_avimet_luatz

        if [ ! -z "$build_num" ]; then
            build_avimet_inspect
        fi

        build_avimet_config
        build_avimet_fin

        # currently we support Linux(deb,rpm), FreeBSD(pkg)
        if [ "$OS_NAME" = "linux" -o \
             "$OS_NAME" = "freebsd"  ]; then
            build_avimet_pkg
        fi

    fi
    ;;


 mesg)
    echo "" > ${BUILD_PATH}/${BUILD_LOG}

    if [ $rpm_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xrhel" -o "x${DIST_ID}" = "xcentos" ]; then
            build_mesg_pkg
        else
            echo "Error: not a RPM installation, cannot build rpm pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $deb_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xdebian" -o \
             "x${DIST_ID}" = "xubuntu" -o \
             "x${DIST_ID}" = "xraspbian" ]; then
            build_mesg_pkg
        else
            echo "Error: not a DEB installation, cannot build deb pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $fbsd_pkg_sem -eq 1 ]; then
        build_mesg_pkg 
    else 
        build_mesg_openresty
        build_mesg_router
        build_mesg_smtp

        if [ ! -z "$build_num" ]; then
            build_mesg_inspect
        fi

        build_mesg_config
        build_mesg_fin

        # currently we support Linux(deb,rpm), FreeBSD(pkg)
        if [ "$OS_NAME" = "linux" -o \
             "$OS_NAME" = "freebsd"  ]; then
            build_mesg_pkg
        fi

    fi
    ;;

 kernel)
    echo "" > ${BUILD_PATH}/${BUILD_LOG}

    if [ $rpm_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xrhel" -o "x${DIST_ID}" = "xcentos" ]; then
            build_kernel_pkg
        else
            echo "Error: not a RPM installation, cannot build rpm pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $deb_sem -eq 1 ]; then
        if [ "x${DIST_ID}" = "xdebian" -o \
             "x${DIST_ID}" = "xubuntu" -o \
             "x${DIST_ID}" = "xraspbian" ]; then
            build_kernel_pkg
        else
            echo "Error: not a DEB installation, cannot build deb pkg"
            rm /var/tmp/${STATFILE}
            exit 3
        fi
    elif [ $fbsd_pkg_sem -eq 1 ]; then
        build_kernel_pkg 
    else 
        build_kernel_openresty
        build_kernel_fs
        build_kernel_template
        build_kernel_router
        build_kernel_libdate
        build_kernel_httpsimple
        build_kernel_luatz
        build_kernel_prettycjson
        build_kernel_zlib
        build_kernel_struct
        build_kernel_zip
        build_kernel_http

        if [ ! -z "$build_num" ]; then
            build_kernel_inspect
        fi

        build_kernel_redis
        build_kernel_config
        build_kernel_fin

        # currently we support Linux deb, rpm
        if [ "$OS_NAME" = "linux" -o \
             "$OS_NAME" = "freebsd"  ]; then
            build_kernel_pkg
        fi
    fi
    ;;

 mon)
    echo "" > ${BUILD_PATH}/${BUILD_LOG}

    if [ $fbsd_pkg_sem -eq 1 ]; then
        build_mon_pkg 
    else 
        build_mon_perl
        # build_mon_procdaemon
        build_mon_ossl
        build_mon_netssl
        #build_mon_curl
        #build_mon_wwwcurl
        build_mon_scripts
        #build_mon_config
        build_mon_pkg
    fi
    ;;

 *) 
    usage
 ;;

esac


# FINAL INTEGRATION MESSAGE

echo "#################################################################"
echo "# SUMMARY"
echo "# Target:  ${OS_NAME} ${PT_NAME}"
if [ ! -z "$appliance" ]; then
    echo "# Appliance: $appliance"
fi
if [ ! -z "$COMPILER" ]; then
    echo "# Compiler: ${COMPILER}"
fi
echo "# Built on: ${OS_NAME} ${KERNEL}"
echo "#################################################################"
echo "# Module: ${module}"
echo "# Version: ${version}"
echo "# Build Date: `date`"

case "$module" in

 recording)

    if [ $perl_done -eq 1 ]; then
        echo "# perl: ok"
    else
        if [ $perl_done -eq 90 ]; then
            echo "# perl: failed"
        fi
    fi

    if [ $procdaemon_done -eq 1 ]; then
        echo "# proc-daemon: ok"
    else
        if [ $procdaemon_done -eq 90 ]; then
            echo "# proc-daemon: failed"
        fi
    fi

    if [ $ossl_done -eq 1 ]; then
        echo "# openssl: ok"
    else
        if [ $ossl_done -eq 90 ]; then
            echo "# openssl: failed"
        fi
    fi

    if [ $perlssl_done -eq 1 ]; then
        echo "# Net-SSLeay: ok"
    else
        if [ $perlssl_done -eq 90 ]; then
            echo "# Net-SSLeay: failed"
        fi
    fi

    if [ $deviceserial_done -eq 1 ]; then
        echo "# deviceserial: ok"
    else
        if [ $deviceserial_done -eq 90 ]; then
            echo "# deviceserial: failed"
        fi
    fi

    if [ $deviceusb_done -eq 1 ]; then
        echo "# deviceusb: ok"
    else
        if [ $deviceusb_done -eq 90 ]; then
            echo "# deviceusb: failed"
        fi
    fi

    if [ $cares_done -eq 1 ]; then
        echo "# cares: ok"
    else
        if [ $cares_done -eq 90 ]; then
            echo "# cares: failed"
        fi
    fi

    if [ $curl_done -eq 1 ]; then
        echo "# curl: ok"
    else
        if [ $curl_done -eq 90 ]; then
            echo "# curl: failed"
        fi
    fi

    if [ "$OS_NAME" = "linux" ]; then
        if [ $sysstat_done -eq 1 ]; then
            echo "# sysstat: ok"
        else
            if [ $sysstat_done -eq 90 ]; then
                echo "# sysstat: failed"
            fi
        fi
    fi

    if [ $wwwcurl_done -eq 1 ]; then
        echo "# wcurl: ok"
    else
        if [ $wwwcurl_done -eq 90 ]; then
            echo "# wcurl: failed"
        fi
    fi

    if [ $x509_done -eq 1 ]; then
        echo "# X509: ok"
    else
        if [ $x509_done -eq 90 ]; then
            echo "# X509: failed"
        fi
    fi

    if [ $klib_done -eq 1 ]; then
        echo "# webrec, svcrec: ok"
    else
        if [ $klib_done -eq 90 ]; then
            echo "# webrec, svcrec: failed"
        fi
    fi

    if [ $wrec_done -eq 1 ]; then
        echo "# webrec: ok"
    else
        if [ $wrec_done -eq 90 ]; then
            echo "# webrec: failed"
        fi
    fi


    if [ $tests_done -eq 1 ]; then
        echo "# tests: ok"
    else
        if [ $tests_done -eq 90 ]; then
            echo "# tests: failed"
        fi
    fi


    if [ $tar_pkg_done -eq 1 ]; then
        echo "# tar pkg: ok"
    else
        if [ $tar_pkg_done -eq 90 ]; then
            echo "# tar pkg: failed"
        fi
    fi

    if [ $rpm_pkg_done -eq 1 ]; then
        echo "# rpm pkg: ok"
    else
        if [ $rpm_pkg_done -eq 90 ]; then
            echo "# rpm pkg: failed"
        fi
    fi

    if [ $deb_pkg_done -eq 1 ]; then
        echo "# deb pkg: ok"
    else
        if [ $deb_pkg_done -eq 90 ]; then
            echo "# deb pkg: failed"
        fi
    fi

    if [ $fbsd_pkg_done -eq 1 ]; then
        echo "# freebsd pkg: ok"
    else
        if [ $fbsd_pkg_done -eq 90 ]; then
            echo "# freebsd pkg: failed"
        fi
    fi

    if [ $recs_done -eq 1 ]; then
        echo "# FINALIZE: ok"
    else
        if [ $recs_done -eq 90 ]; then
            echo "# FINALIZE: failed"
        fi
    fi

 ;;


 auth)

    if [ $auth_openresty_done -ne 0 ]; then
        if [ $auth_openresty_done -eq 1 ]; then
            echo "# openresty: built and integrated"
        else
            if [ $auth_openresty_done -eq 90 ]; then
                echo "# openresty: not integrated"
            fi
        fi
    fi

    if [ $auth_lua_resty_template_done -ne 0 ]; then
        if [ $auth_lua_resty_template_done -eq 1 ]; then
            echo  "# lib lua-resty-template: built and integrated"
        else
            if [ $auth_lua_resty_template_done -eq 90 ]; then
                echo  "# lib lua-resty-template: not integrated"
            fi
        fi
    fi

    if [ $auth_lua_router_done -ne 0 ]; then
        if [ $auth_lua_router_done -eq 1 ]; then
            echo  "# lib router.lua: built and integrated"
        else
            if [ $auth_lua_router_done -eq 90 ]; then
                echo  "# lib router.lua: not integrated"
            fi
        fi
    fi

    if [ $auth_lua_resty_http_simple_done -ne 0 ]; then
        if [ $auth_lua_resty_http_simple_done -eq 1 ]; then
            echo  "# lib simple.lua: built and integrated"
        else
            if [ $auth_lua_resty_http_simple_done -eq 90 ]; then
                echo  "# lib simple.lua: not integrated"
            fi
        fi
    fi

    if [ $auth_luatz_done -ne 0 ]; then
        if [ $auth_luatz_done -eq 1 ]; then
            echo  "# lib luatz: built and integrated"
        else
            if [ $auth_luatz_done -eq 90 ]; then
                echo  "# lib luatz: not integrated"
            fi
        fi
    fi

    if [ ! -z "$build_num" ]; then
        if [ $auth_lua_inspect_done -ne 0 ]; then
            if [ $auth_lua_inspect_done -eq 1 ]; then
                echo  "# lib inspect.lua: built and integrated"
            else
                if [ $auth_lua_inspect_done -eq 90 ]; then
                    echo  "# lib inspect.lua: not integrated"
                fi
            fi
        fi
    fi

    if [ $auth_redis_done -ne 0 ]; then
        if [ $auth_redis_done -eq 1 ]; then
            echo  "# redis: built and integrated"
        else
            if [ $auth_redis_done -eq 90 ]; then
                echo  "# redis: not integrated"
            fi
        fi
    fi

    if [ $auth_config_done -ne 0 ]; then
        if [ $auth_config_done -eq 1 ]; then
            echo  "# analytics-auth nginx.conf: done"
        else
            if [ $auth_config_done -eq 90 ]; then
                echo  "# analytics-auth nginx.conf: not done"
            fi
        fi
    fi

    if [ $auth_tar_pkg_done -eq 1 ]; then
        echo "# tar pkg: ok"
    else
        if [ $auth_tar_pkg_done -eq 90 ]; then
            echo "# tar pkg: failed"
        fi
    fi

    if [ $auth_rpm_pkg_done -eq 1 ]; then
        echo "# rpm pkg: ok"
    else
        if [ $auth_rpm_pkg_done -eq 90 ]; then
            echo "# rpm pkg: failed"
        fi
    fi

    if [ $auth_deb_pkg_done -eq 1 ]; then
        echo "# deb pkg: ok"
    else
        if [ $auth_deb_pkg_done -eq 90 ]; then
            echo "# deb pkg: failed"
        fi
    fi

    if [ $auth_fbsd_pkg_done -eq 1 ]; then
        echo "# freebsd pkg: ok"
    else
        if [ $auth_fbsd_pkg_done -eq 90 ]; then
            echo "# freebsd pkg: failed"
        fi
    fi

    if [ $auth_fin_done -ne 0 ]; then
        if [ $auth_fin_done -eq 1 ]; then
            echo  "# FINALIZE: done"
        else
            if [ $auth_fin_done -eq 90 ]; then
                echo  "# FINALIZE: not done"
            fi
        fi
    fi

 ;;


 avimet)

    if [ $avimet_openresty_done -ne 0 ]; then
        if [ $avimet_openresty_done -eq 1 ]; then
            echo "# openresty: built and integrated"
        else
            if [ $avimet_openresty_done -eq 90 ]; then
                echo "# openresty: not integrated"
            fi
        fi
    fi

    if [ $avimet_lua_resty_template_done -ne 0 ]; then
        if [ $avimet_lua_resty_template_done -eq 1 ]; then
            echo  "# lib lua-resty-template: built and integrated"
        else
            if [ $avimet_lua_resty_template_done -eq 90 ]; then
                echo  "# lib lua-resty-template: not integrated"
            fi
        fi
    fi

    if [ $avimet_lua_router_done -ne 0 ]; then
        if [ $avimet_lua_router_done -eq 1 ]; then
            echo  "# lib router.lua: built and integrated"
        else
            if [ $avimet_lua_router_done -eq 90 ]; then
                echo  "# lib router.lua: not integrated"
            fi
        fi
    fi

    if [ $avimet_lua_resty_http_simple_done -ne 0 ]; then
        if [ $avimet_lua_resty_http_simple_done -eq 1 ]; then
            echo  "# lib simple.lua: built and integrated"
        else
            if [ $avimet_lua_resty_http_simple_done -eq 90 ]; then
                echo  "# lib simple.lua: not integrated"
            fi
        fi
    fi

    if [ $avimet_luatz_done -ne 0 ]; then
        if [ $avimet_luatz_done -eq 1 ]; then
            echo  "# lib luatz: built and integrated"
        else
            if [ $avimet_luatz_done -eq 90 ]; then
                echo  "# lib luatz: not integrated"
            fi
        fi
    fi

    if [ ! -z "$build_num" ]; then
        if [ $avimet_lua_inspect_done -ne 0 ]; then
            if [ $avimet_lua_inspect_done -eq 1 ]; then
                echo  "# lib inspect.lua: built and integrated"
            else
                if [ $avimet_lua_inspect_done -eq 90 ]; then
                    echo  "# lib inspect.lua: not integrated"
                fi
            fi
        fi
    fi

    if [ $avimet_config_done -ne 0 ]; then
        if [ $avimet_config_done -eq 1 ]; then
            echo  "# analytics-avimet nginx.conf: done"
        else
            if [ $avimet_config_done -eq 90 ]; then
                echo  "# analytics-avimet nginx.conf: not done"
            fi
        fi
    fi

    if [ $avimet_tar_pkg_done -eq 1 ]; then
        echo "# tar pkg: ok"
    else
        if [ $avimet_tar_pkg_done -eq 90 ]; then
            echo "# tar pkg: failed"
        fi
    fi

    if [ $avimet_rpm_pkg_done -eq 1 ]; then
        echo "# rpm pkg: ok"
    else
        if [ $avimet_rpm_pkg_done -eq 90 ]; then
            echo "# rpm pkg: failed"
        fi
    fi

    if [ $avimet_deb_pkg_done -eq 1 ]; then
        echo "# deb pkg: ok"
    else
        if [ $avimet_deb_pkg_done -eq 90 ]; then
            echo "# deb pkg: failed"
        fi
    fi

    if [ $avimet_fbsd_pkg_done -eq 1 ]; then
        echo "# freebsd pkg: ok"
    else
        if [ $avimet_fbsd_pkg_done -eq 90 ]; then
            echo "# freebsd pkg: failed"
        fi
    fi

    if [ $avimet_fin_done -ne 0 ]; then
        if [ $avimet_fin_done -eq 1 ]; then
            echo  "# FINALIZE: done"
        else
            if [ $avimet_fin_done -eq 90 ]; then
                echo  "# FINALIZE: not done"
            fi
        fi
    fi

 ;;









 mon)

    if [ $mon_perl_done -ne 0 ]; then
        if [ $mon_perl_done -eq 1 ]; then
            echo "# perl: built and integrated"
        else
            if [ $mon_perl_done -eq 90 ]; then
                echo "# perl: not integrated"
            fi
        fi
    fi

    if [ $mon_procdaemon_done -eq 1 ]; then
        echo "# proc-daemon: ok"
    else
        if [ $mon_procdaemon_done -eq 90 ]; then
            echo "# proc-daemon: failed"
        fi
    fi

    if [ $mon_ossl_done -eq 1 ]; then
        echo "# openssl: ok"
    else
        if [ $mon_ossl_done -eq 90 ]; then
            echo "# openssl: failed"
        fi
    fi

    if [ $mon_curl_done -eq 1 ]; then
        echo "# curl: ok"
    else
        if [ $mon_curl_done -eq 90 ]; then
            echo "# curl: failed"
        fi
    fi

    if [ $mon_wwwcurl_done -eq 1 ]; then
        echo "# www-curl: ok"
    else
        if [ $mon_wwwcurl_done -eq 90 ]; then
            echo "# www-curl: failed"
        fi
    fi
        
    if [ $mon_tar_pkg_done -eq 1 ]; then
        echo "# tar pkg: ok"
    else
        if [ $mon_tar_pkg_done -eq 90 ]; then
            echo "# tar pkg: failed"
        fi
    fi

    if [ $mon_pkg_done -eq 1 ]; then
        echo "# freebsd pkg: ok"
    else
        if [ $mon_pkg_done -eq 90 ]; then
            echo "# freebsd pkg: failed"
        fi
    fi

    if [ $mon_tests_done -eq 1 ]; then
        echo "# tests: ok"
    else
        if [ $mon_tests_done -eq 90 ]; then
            echo "# tests: failed"
        fi
    fi      
 ;;

 mesg)

    if [ $mesg_openresty_done -ne 0 ]; then
        if [ $mesg_openresty_done -eq 1 ]; then
            echo "# openresty: built and integrated"
        else
            if [ $mesg_openresty_done -eq 90 ]; then
                echo "# openresty: not integrated"
            fi
        fi
    fi

    if [ $mesg_lua_resty_template_done -ne 0 ]; then
        if [ $mesg_lua_resty_template_done -eq 1 ]; then
            echo  "# lib lua-resty-template: built and integrated"
        else
            if [ $mesg_lua_resty_template_done -eq 90 ]; then
                echo  "# lib lua-resty-template: not integrated"
            fi
        fi
    fi

    if [ $mesg_lua_router_done -ne 0 ]; then
        if [ $mesg_lua_router_done -eq 1 ]; then
            echo  "# lib router.lua: built and integrated"
        else
            if [ $mesg_lua_router_done -eq 90 ]; then
                echo  "# lib router.lua: not integrated"
            fi
        fi
    fi

    if [ $mesg_lua_resty_smtp_done -ne 0 ]; then
        if [ $mesg_lua_resty_smtp_done -eq 1 ]; then
            echo  "# lib smtp.lua: built and integrated"
        else
            if [ $mesg_lua_resty_smtp_done -eq 90 ]; then
                echo  "# lib smtp.lua: not integrated"
            fi
        fi
    fi

    if [ ! -z "$build_num" ]; then
        if [ $mesg_lua_inspect_done -ne 0 ]; then
            if [ $mesg_lua_inspect_done -eq 1 ]; then
                echo  "# lib inspect.lua: built and integrated"
            else
                if [ $mesg_lua_inspect_done -eq 90 ]; then
                    echo  "# lib inspect.lua: not integrated"
                fi
            fi
        fi
    fi

    if [ $mesg_config_done -ne 0 ]; then
        if [ $mesg_config_done -eq 1 ]; then
            echo  "# analytics-mesg nginx.conf: done"
        else
            if [ $mesg_config_done -eq 90 ]; then
                echo  "# analytics-mesg nginx.conf: not done"
            fi
        fi
    fi

    if [ $mesg_tar_pkg_done -eq 1 ]; then
        echo "# tar pkg: ok"
    else
        if [ $mesg_tar_pkg_done -eq 90 ]; then
            echo "# tar pkg: failed"
        fi
    fi

    if [ $mesg_rpm_pkg_done -eq 1 ]; then
        echo "# rpm pkg: ok"
    else
        if [ $mesg_rpm_pkg_done -eq 90 ]; then
            echo "# rpm pkg: failed"
        fi
    fi

    if [ $mesg_deb_pkg_done -eq 1 ]; then
        echo "# deb pkg: ok"
    else
        if [ $mesg_deb_pkg_done -eq 90 ]; then
            echo "# deb pkg: failed"
        fi
    fi

    if [ $mesg_fbsd_pkg_done -eq 1 ]; then
        echo "# freebsd pkg: ok"
    else
        if [ $mesg_fbsd_pkg_done -eq 90 ]; then
            echo "# freebsd pkg: failed"
        fi
    fi

    if [ $mesg_fin_done -ne 0 ]; then
        if [ $mesg_fin_done -eq 1 ]; then
            echo  "# FINALIZE: done"
        else
            if [ $mesg_fin_done -eq 90 ]; then
                echo  "# FINALIZE: not done"
            fi
        fi
    fi

 ;;

 kernel)

    if [ $kernel_openresty_done -ne 0 ]; then
        if [ $kernel_openresty_done -eq 1 ]; then
            echo "# openresty: built and integrated"
        else
            if [ $kernel_openresty_done -eq 90 ]; then
                echo "# openresty: not integrated"
            fi
        fi
    fi

    if [ $kernel_luafs_done -ne 0 ]; then
        if [ $kernel_luafs_done -eq 1 ]; then
            echo  "# lib luafilesystem: built and integrated"
        else
            if [ $kernel_luafs_done -eq 90 ]; then
                echo  "# lib luafilesystem: not integrated"
            fi
        fi
    fi

    if [ $kernel_lua_resty_template_done -ne 0 ]; then
        if [ $kernel_lua_resty_template_done -eq 1 ]; then
            echo  "# lib lua-resty-template: built and integrated"
        else
            if [ $kernel_lua_resty_template_done -eq 90 ]; then
                echo  "# lib lua-resty-template: not integrated"
            fi
        fi
    fi

    if [ $kernel_lua_router_done -ne 0 ]; then
        if [ $kernel_lua_router_done -eq 1 ]; then
            echo  "# lib router.lua: built and integrated"
        else
            if [ $kernel_lua_router_done -eq 90 ]; then
                echo  "# lib router.lua: not integrated"
            fi
        fi
    fi

    if [ $kernel_libdate_done -ne 0 ]; then
        if [ $kernel_libdate_done -eq 1 ]; then
            echo  "# lib date.lua: built and integrated"
        else
            if [ $kernel_libdone_done -eq 90 ]; then
                echo  "# lib date.lua: not integrated"
            fi
        fi
    fi

    if [ $kernel_lua_resty_http_simple_done -ne 0 ]; then
        if [ $kernel_lua_resty_http_simple_done -eq 1 ]; then
            echo  "# lib simple.lua: built and integrated"
        else
            if [ $kernel_lua_resty_http_simple_done -eq 90 ]; then
                echo  "# lib simple.lua: not integrated"
            fi
        fi
    fi

    if [ $kernel_lua_resty_prettycjson_done -ne 0 ]; then
        if [ $kernel_lua_resty_prettycjson_done -eq 1 ]; then
            echo  "# lib prettycjson.lua: built and integrated"
        else
            if [ $kernel_lua_resty_prettycjson_done -eq 90 ]; then
                echo  "# lib prettycjson.lua: not integrated"
            fi
        fi
    fi

    if [ $kernel_luatz_done -ne 0 ]; then
        if [ $kernel_luatz_done -eq 1 ]; then
            echo  "# lib luatz: built and integrated"
        else
            if [ $kernel_luatz_done -eq 90 ]; then
                echo  "# lib luatz: not integrated"
            fi
        fi
    fi

    if [ $kernel_luazlib_done -ne 0 ]; then
        if [ $kernel_luazlib_done -eq 1 ]; then
            echo  "# lib lua-zlib: built and integrated"
        else
            if [ $kernel_luazlib_done -eq 90 ]; then
                echo  "# lib luazlib: not integrated"
            fi
        fi
    fi

    if [ $kernel_struct_done -ne 0 ]; then
        if [ $kernel_struct_done -eq 1 ]; then
            echo  "# lib struct: built and integrated"
        else
            if [ $kernel_struct_done -eq 90 ]; then
                echo  "# lib struct: not integrated"
            fi
        fi
    fi

    if [ $kernel_zipwriter_done -ne 0 ]; then
        if [ $kernel_zipwriter_done -eq 1 ]; then
            echo  "# lib zipwriter: built and integrated"
        else
            if [ $kernel_zipwriter_done -eq 90 ]; then
                echo  "# lib zipwriter: not integrated"
            fi
        fi
    fi

    if [ $kernel_lua_resty_http_done -ne 0 ]; then
        if [ $kernel_lua_resty_http_done -eq 1 ]; then
            echo  "# lib lua-resty-http: built and integrated"
        else
            if [ $kernel_lua_resty_http_done -eq 90 ]; then
                echo  "# lib lua-resty-http: not integrated"
            fi
        fi
    fi

    if [ ! -z "$build_num" ]; then
        if [ $kernel_lua_inspect_done -ne 0 ]; then
            if [ $kernel_lua_inspect_done -eq 1 ]; then
                echo  "# lib inspect.lua: built and integrated"
            else
                if [ $kernel_lua_inspect_done -eq 90 ]; then
                    echo  "# lib inspect.lua: not integrated"
                fi
            fi
        fi
    fi

    if [ $kernel_redis_done -ne 0 ]; then
        if [ $kernel_redis_done -eq 1 ]; then
            echo  "# redis: built and integrated"
        else
            if [ $kernel_redis_done -eq 90 ]; then
                echo  "# redis: not integrated"
            fi
        fi
    fi

    if [ $kernel_config_done -ne 0 ]; then
        if [ $kernel_config_done -eq 1 ]; then
            echo  "# analytics-kernel nginx.conf: done"
        else
            if [ $kernel_config_done -eq 90 ]; then
                echo  "# analytics-kernel nginx.conf: not done"
            fi
        fi
    fi

    if [ $kernel_tar_pkg_done -eq 1 ]; then
        echo "# tar pkg: ok"
    else
        if [ $kernel_tar_pkg_done -eq 90 ]; then
            echo "# tar pkg: failed"
        fi
    fi

    if [ $kernel_rpm_pkg_done -eq 1 ]; then
        echo "# rpm pkg: ok"
    else
        if [ $kernel_rpm_pkg_done -eq 90 ]; then
            echo "# rpm pkg: failed"
        fi
    fi

    if [ $kernel_deb_pkg_done -eq 1 ]; then
        echo "# deb pkg: ok"
    else
        if [ $kernel_deb_pkg_done -eq 90 ]; then
            echo "# deb pkg: failed"
        fi
    fi

    if [ $kernel_fbsd_pkg_done -eq 1 ]; then
        echo "# freebsd pkg: ok"
    else
        if [ $kernel_fbsd_pkg_done -eq 90 ]; then
            echo "# freebsd pkg: failed"
        fi
    fi

    if [ $kernel_fin_done -ne 0 ]; then
        if [ $kernel_fin_done -eq 1 ]; then
            echo  "# FINALIZE: done"
        else
            if [ $kernel_fin_done -eq 90 ]; then
                echo  "# FINALIZE: not done"
            fi
        fi
    fi

 ;;


esac

echo "#################################################################"

elapsed=0
end=0
if [ "$OS_NAME" = "sunos" ]; then
    end=`nawk 'BEGIN{print srand()}'`
else
    end=`date +%s`
fi

elapsed=`expr $end - $start`

h=`expr $elapsed / 3600`
m=`expr  $elapsed / 60 % 60`
s=`expr $elapsed % 60`
echo "# Total Build time: ${h}h:${m}m:${s}s"
echo "#################################################################"


#cleanup
rm /var/tmp/${STATFILE}
