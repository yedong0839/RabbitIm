#!/bin/bash

#作者：康林
#参数:
#    $1:编译目标(android、windows_msvc、windows_mingw、unix)
#    $2:源码的位置 

#运行本脚本前,先运行 build_$1_envsetup.sh 进行环境变量设置,需要先设置下面变量:
#   RABBITIM_BUILD_TARGERT   编译目标（android、windows_msvc、windows_mingw、unix)
#   RABBITIM_BUILD_PREFIX=`pwd`/../${RABBITIM_BUILD_TARGERT}  #修改这里为安装前缀
#   RABBITIM_BUILD_SOURCE_CODE    #源码目录
#   RABBITIM_BUILD_CROSS_PREFIX   #交叉编译前缀
#   RABBITIM_BUILD_CROSS_SYSROOT  #交叉编译平台的 sysroot

set -e
HELP_STRING="Usage $0 PLATFORM (android|windows_msvc|windows_mingw|unix) [SOURCE_CODE_ROOT_DIRECTORY]"

case $1 in
    android|windows_msvc|windows_mingw|unix)
    RABBITIM_BUILD_TARGERT=$1
    ;;
    *)
    echo "${HELP_STRING}"
    exit 1
    ;;
esac

#运行本脚本前,先运行 build_${RABBITIM_BUILD_TARGERT}_envsetup.sh 进行环境变量设置,需要先设置下面变量:
#   PREFIX= #修改这里为安装前缀
#   QMAKE=  #设置用于相应平台编译的 QMAKE
#   JOM=    #QT 自带的类似 make 的工具
#if [ -z "${PREFIX}" -o -z "${QMAKE}" -o -z "${JOM}" ]; then
    echo ". `pwd`/build_envsetup_${RABBITIM_BUILD_TARGERT}.sh"
    . `pwd`/build_envsetup_${RABBITIM_BUILD_TARGERT}.sh
#fi

if [ -n "$2" ]; then
    RABBITIM_BUILD_SOURCE_CODE=$2
else
    RABBITIM_BUILD_SOURCE_CODE=${RABBITIM_BUILD_PREFIX}/../src/qzxing
fi

CUR_DIR=`pwd`

#下载源码:
if [ ! -d ${RABBITIM_BUILD_SOURCE_CODE} ]; then
    VERSION=2.3
    if [ "TRUE" = "$RABBITIM_USE_REPOSITORIES" ]; then
        echo "git clone git://git.code.sf.net/p/qzxing/code ${RABBITIM_BUILD_SOURCE_CODE}"
        #git clone git://git.code.sf.net/p/qzxing/code ${RABBITIM_BUILD_SOURCE_CODE}
        git clone -q git@github.com:KangLin/qzxing.git ${RABBITIM_BUILD_SOURCE_CODE}
    else
        mkdir -p ${RABBITIM_BUILD_SOURCE_CODE}
        cd ${RABBITIM_BUILD_SOURCE_CODE}
        wget -q http://sourceforge.net/projects/qzxing/files/v${VERSION}/QZXing_sourceV${VERSION}.zip/download
        unzip download #${RABBITIM_BUILD_SOURCE_CODE}
    fi
fi

if [ -d "${RABBITIM_BUILD_SOURCE_CODE}/source" ]; then
    RABBITIM_BUILD_SOURCE_CODE=${RABBITIM_BUILD_SOURCE_CODE}/source
fi
cd ${RABBITIM_BUILD_SOURCE_CODE}

mkdir -p build_${RABBITIM_BUILD_TARGERT}
cd build_${RABBITIM_BUILD_TARGERT}
if [ -n "$RABBITIM_CLEAN" ]; then
    rm -fr *
fi

echo ""
echo "RABBITIM_BUILD_TARGERT:${RABBITIM_BUILD_TARGERT}"
echo "RABBITIM_BUILD_SOURCE_CODE:$RABBITIM_BUILD_SOURCE_CODE"
echo "CUR_DIR:`pwd`"
echo "RABBITIM_BUILD_PREFIX:$RABBITIM_BUILD_PREFIX"
echo "RABBITIM_BUILD_HOST:$RABBITIM_BUILD_HOST"
echo "RABBITIM_BUILD_CROSS_HOST:$RABBITIM_BUILD_CROSS_HOST"
echo "RABBITIM_BUILD_CROSS_PREFIX:$RABBITIM_BUILD_CROSS_PREFIX"
echo "RABBITIM_BUILD_CROSS_SYSROOT:$RABBITIM_BUILD_CROSS_SYSROOT"
echo "RABBITIM_BUILD_STATIC:$RABBITIM_BUILD_STATIC"
echo ""

case $RABBITIM_BUILD_TARGERT in
    android)
        PARA="-r -spec android-g++"
        case $TARGET_OS in
            MINGW* | CYGWIN* | MSYS*)
                MAKE="$ANDROID_NDK/prebuilt/${RABBITIM_BUILD_HOST}/bin/make ${RABBITIM_MAKE_JOB_PARA} VERBOSE=1" #在windows下编译
                ;;
            *)
            ;;
         esac
         ;;
    unix)
        ;;
    windows_msvc)
        PARA="-r -spec win32-msvc2013"
        MAKE=nmake
        ;;
    windows_mingw)
        PARA="-r -spec win32-g++" # CROSS_COMPILE=${RABBITIM_BUILD_CROSS_PREFIX}"
        ;;
    *)
        echo "Usage $0 PLATFORM(android/windows_msvc/windows_mingw/unix) SOURCE_CODE_ROOT"
        cd $CUR_DIR
        exit 2
        ;;
esac

PARA="${PARA} .. -o Makefile INCLUDEPATH+=${RABBITIM_BUILD_PREFIX}/include"
PARA="${PARA} LIBS+=-L${RABBITIM_BUILD_PREFIX}/lib QXMPP_USE_VPX=1"
DEBUG_PARA="${PARA} CONFIG+=debug"
RELEASE_PARA="${PARA} CONFIG+=release"
if [ "$RABBITIM_BUILD_STATIC" = "static" -o "$RABBITIM_BUILD_TARGERT" = "android" ]; then
    DEBUG_PARA="${DEBUG_PARA} CONFIG+=staticlib"
    RELEASE_PARA="${RELEASE_PARA} CONFIG+=staticlib"
fi

echo "$QMAKE ${RELEASE_PARA}"
$QMAKE ${RELEASE_PARA}

${MAKE} -f Makefile 

MAKE_PARA=" INSTALL_ROOT=\"${RABBITIM_BUILD_PREFIX}\""
${MAKE} -f Makefile install  ${MAKE_PARA}

cd $CUR_DIR
