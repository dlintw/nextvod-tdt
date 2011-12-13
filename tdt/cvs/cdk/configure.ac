AC_INIT([tufsbox-cdk],[0])
AC_PREREQ(2.59)

AC_CANONICAL_HOST
host_arch=`which arch > /dev/null 2>&1 && arch || uname -m`
AC_SUBST(host_arch)
AC_CANONICAL_BUILD
AC_SUBST(build)
if test "$target_alias" = "" ; then
	target_alias="sh4-linux"
fi
AC_CANONICAL_TARGET
if test "$target" = "sh4-unknown-linux-gnu" ; then
	target="sh4-linux"
fi
AC_SUBST(target)

AM_INIT_AUTOMAKE([])
AM_MAINTAINER_MODE

AC_PROG_CC

AC_ARG_ENABLE(player131,
	AS_HELP_STRING(--enable-player131,	set up the CDK to use player131),
	[case "${enableval}" in
		yes) PLAYER131=player131 ;;
	esac],[enable_player131=no])
AM_CONDITIONAL(ENABLE_PLAYER131,test "$enable_player131" = "yes")
AC_SUBST(PLAYER131)

AC_ARG_ENABLE(player179,
	AS_HELP_STRING(--enable-player179,	set up the CDK to use player179),
	[case "${enableval}" in
		yes) PLAYER179=player179 ;;
	esac],[enable_player179=no])
AM_CONDITIONAL(ENABLE_PLAYER179,test "$enable_player179" = "yes")
AC_SUBST(PLAYER179)

AC_ARG_ENABLE(player191,
	AS_HELP_STRING(--enable-player191,	set up the CDK to use player191),
	[case "${enableval}" in
		yes) PLAYER191=player191 ;;
	esac],[enable_player191=no])
AM_CONDITIONAL(ENABLE_PLAYER191,test "$enable_player191" = "yes")
AC_SUBST(PLAYER191)

AC_ARG_ENABLE(multicom322,
	AS_HELP_STRING(--enable-multicom322, set up the CDK to use multicom322),
	[case "${enableval}" in
		yes) MULTICOM322=multicom322 ;;
	esac],[enable_multicom322=no])
AM_CONDITIONAL(ENABLE_MULTICOM322,test "$enable_multicom322" = "yes")
AC_SUBST(MULTICOM322)

AC_ARG_ENABLE(multicom324,
	AS_HELP_STRING(--enable-multicom324, set up the CDK to use multicom324),
	[case "${enableval}" in
		yes) MULTICOM324=multicom324 ;;
	esac],[enable_multicom324=no])
AM_CONDITIONAL(ENABLE_MULTICOM324,test "$enable_multicom324" = "yes")
AC_SUBST(MULTICOM324)

AC_ARG_ENABLE(stm22,
	AS_HELP_STRING(--enable-stm22,	set up the CDK to use the STLinux 2.2),
	,[enable_stm22=no])
AM_CONDITIONAL(STM22,test "$enable_stm22" = "yes")

AC_ARG_ENABLE(stm23,
	AS_HELP_STRING(--enable-stm23,	set up the CDK to use the STLinux 2.3),
	,[enable_stm23=no])
AM_CONDITIONAL(STM23,test "$enable_stm23" = "yes")

AC_ARG_ENABLE(havana,
	AS_HELP_STRING(--enable-havana,	set up the CDK to use the STLinux 2.3 Havana),
	,[enable_havana=no])
AM_CONDITIONAL(STM23_HAVANA,test "$enable_havana" = "yes")

AC_ARG_ENABLE(stm24,
	AS_HELP_STRING(--enable-stm24,	set up the CDK to use the STLinux 2.4),
	,[enable_stm24=no])
AM_CONDITIONAL(STM24,test "$enable_stm24" = "yes")

AC_ARG_ENABLE(p0040,
	AS_HELP_STRING(--enable-p0040,	set up the CDK to use the STLinux 2.2 with patchlevel 0040),
	,[enable_p0040=no])
AM_CONDITIONAL(P0040,test "$enable_p0040" = "yes")

AC_ARG_ENABLE(p0041,
	AS_HELP_STRING(--enable-p0041,	set up the CDK to use the STLinux 2.2 with patchlevel 0041),
	,[enable_p0041=no])
AM_CONDITIONAL(P0041,test "$enable_p0041" = "yes")

AC_ARG_ENABLE(p0119,
	AS_HELP_STRING(--enable-p0119,  set up the CDK to use the STLinux 2.3 with patchlevel 0119),
	[case "${enableval}" in
		yes) P0119=p0119 ;;
	esac], [enable_p0119=no])
AM_CONDITIONAL(ENABLE_P0119,test "$enable_p0119" = "yes")
AC_SUBST(P0119)

AC_ARG_ENABLE(p0123,
	AS_HELP_STRING(--enable-p0123,  set up the CDK to use the STLinux 2.3 with patchlevel 0123),
	[case "${enableval}" in
		yes) P0123=p0123 ;;
	esac], [enable_p0123=no])
AM_CONDITIONAL(ENABLE_P0123,test "$enable_p0123" = "yes")
AC_SUBST(P0123)

AC_ARG_ENABLE(p0201,
	AS_HELP_STRING(--enable-p0201,  set up the CDK to use the STLinux 2.4 with patchlevel 0201),
	[case "${enableval}" in
		yes) P0201=p0201 ;;
	esac], [enable_p0201=no])
AM_CONDITIONAL(ENABLE_P0201,test "$enable_p0201" = "yes")
AC_SUBST(P0201)

AC_ARG_ENABLE(p0205,
	AS_HELP_STRING(--enable-p0205,  set up the CDK to use the STLinux 2.4 with patchlevel 0205),
	[case "${enableval}" in
		yes) P0205=p0205 ;;
	esac], [enable_p0205=no])
AM_CONDITIONAL(ENABLE_P0205,test "$enable_p0205" = "yes")
AC_SUBST(P0205)

AC_ARG_ENABLE(p0206,
	AS_HELP_STRING(--enable-p0206,  set up the CDK to use the STLinux 2.4 with patchlevel 0206),
	[case "${enableval}" in
		yes) P0206=p0206 ;;
	esac], [enable_p0206=no])
AM_CONDITIONAL(ENABLE_P0206,test "$enable_p0206" = "yes")
AC_SUBST(P0206)

AC_ARG_ENABLE(p0207,
	AS_HELP_STRING(--enable-p0207,  set up the CDK to use the STLinux 2.4 with patchlevel 0207),
	[case "${enableval}" in
		yes) P0207=p0207 ;;
	esac], [enable_p0207=no])
AM_CONDITIONAL(ENABLE_P0207,test "$enable_p0207" = "yes")
AC_SUBST(P0207)

AC_ARG_ENABLE(p0209,
	AS_HELP_STRING(--enable-p0209,  set up the CDK to use the STLinux 2.4 with patchlevel 0209),
	[case "${enableval}" in
		yes) P0209=p0209 ;;
	esac], [enable_p0209=no])
AM_CONDITIONAL(ENABLE_P0209,test "$enable_p0209" = "yes")
AC_SUBST(P0209)

AC_ARG_ENABLE(havana_p0207_5,
	AS_HELP_STRING(enable-havana-p0207_5,  set up the CDK to use the STLinux 2.4 with Havana patchlevel 0207_5),
	[case "${enableval}" in
		yes) HAVANA_P0207_5=havana_p0207_5 ;;
	esac], [enable_havana_p0207_5=no])
AM_CONDITIONAL(ENABLE_HAVANA_P0207_5,test "$enable_havana_p0207_5" = "yes")
AC_SUBST(HAVANA_P0207_5)

AC_ARG_ENABLE(debug,
	AS_HELP_STRING(--enable-debug,	set up the CDK to use debug kernel configs),
	,[enable_debug=no])
AM_CONDITIONAL(DEBUG,test "$enable_debug" = "yes")

AC_ARG_ENABLE(bleeding_edge,
	AS_HELP_STRING(--enable-bleeding-edge,	Use latest possible version for every package),
	,[enable_bleeding_edge=no])
AM_CONDITIONAL(BLEEDING_EDGE,test "$enable_bleeding_edge" = "yes")

AC_ARG_ENABLE(enable_vdr1711,
	AS_HELP_STRING(--enable-vdr1711,	set up the CDK to use vdr 1.7.11),
	,[enable_vdr1711=no])
AM_CONDITIONAL(ENABLE_VDR1711,test "$enable_vdr1711" = "yes")

AC_ARG_WITH(cpu,
	[  --with-cpu=MODEL        cpu model [[sh4]]],
	[CPU_MODEL="$withval"],[CPU_MODEL="sh4"])
AC_SUBST(CPU_MODEL)

AC_ARG_WITH(targetruleset,
	[  --with-targetruleset=NAME	OBSOLETE, use --[[enable|disable]]-flashrules instead],
	[TARGETRULESET="$withval"],[TARGETRULESET="notset"])

if test "$TARGETRULESET" != "notset"; then
	AC_MSG_WARN([--with-targetruleset is obsolete; use --[[enable|disable]]-flashrules instead]);
fi

AC_ARG_WITH(assume-kernelsources-old,
	[  --with-assume-kernelsources-old	Do not recompile due to new kernel sources],
	[assume_kernelsources_old="yes"],[assume_kernelsources_old="no"])
AM_CONDITIONAL(ASSUME_KERNELSOURCES_OLD,test "$assume_kernelsources_old" = "yes")

AC_ARG_ENABLE(mediafwgstreamer,
	AS_HELP_STRING(--enable-mediafwgstreamer,	set up the CDK to use mediafw gstreamer),
	,[enable_mediafwgstreamer=no])
AM_CONDITIONAL(ENABLE_MEDIAFWGSTREAMER,test "$enable_mediafwgstreamer" = "yes")
AC_SUBST(MEDIAFWGSTREAMER)

AC_ARG_ENABLE(externallcd,
	AS_HELP_STRING(--enable-externallcd,	set up the CDK to use graphlcd),
	,[enable_externallcd=no])
AM_CONDITIONAL(ENABLE_EXTERNALLCD,test "$enable_externallcd" = "yes")
AC_SUBST(EXTERNALLCD)

AC_ARG_ENABLE(flashrules,
	AS_HELP_STRING(--enable-flashrules,	enable rules for creating flash targets),
	,[enable_flashrules=yes])
AM_CONDITIONAL(TARGETRULESET_FLASH,test "$enable_flashrules" = "yes")

if test "$enable_flashrules" = "yes"; then
	INSTALLRULESETFILE="-flash"
else
	INSTALLRULESETFILE=""
fi



if test -z "$CFLAGS" ; then
	CFLAGS="-g -O2"
fi
# CFLAGS="-g -O2 -fno-strict-aliasing"
if test -z "$TARGET_CFLAGS" -o -z "$TARGET_CXXFLAGS"; then
	TARGET_CFLAGS="-O2"
	if test "$enable_flashrules" != "yes"; then
		TARGET_CFLAGS="$TARGET_CFLAGS"
		TARGET_LDFLAGS=""
	else
		TARGET_CFLAGS="$TARGET_CFLAGS"
		TARGET_LDFLAGS=""
	fi
	TARGET_CXXFLAGS="$TARGET_CFLAGS"
fi

AC_ARG_ENABLE(lirc,
	AS_HELP_STRING(--enable-lirc,	include lirc in yadds and images),
	[case "${enableval}" in
		yes) LIRC=lirc ;;
	esac], [enable_lirc=no])
AM_CONDITIONAL(ENABLE_LIRC,test "$enable_lirc" = "yes")
AC_SUBST(LIRC)

AC_ARG_ENABLE(xfs,
	AS_HELP_STRING(--enable-xfs,    include xfs drivers in yauds and images),
	[case "${enableval}" in
		yes) XFSPROGS=xfsprogs ;;
	esac],[enable_xfs=no])
AM_CONDITIONAL(ENABLE_XFS,test "$enable_xfs" = "yes")
AC_SUBST(XFSPROGS)

AC_ARG_ENABLE(ntfs,
	AS_HELP_STRING(--enable-ntfs,    include ntfs drivers in yauds and images),
	[case "${enableval}" in
		yes) NTFS=ntfs ;;
	esac],[enable_ntfs=no])
AM_CONDITIONAL(ENABLE_NTFS,test "$enable_ntfs" = "yes")
AC_SUBST(NTFS)

AC_ARG_ENABLE(nfsserver,
	AS_HELP_STRING(--enable-nfsserver,      enable NFS server),
	[case "${enableval}" in
		yes) NFSSERVER=nfs-utils ;;
	esac],[enable_nfsserver=no])
AM_CONDITIONAL(ENABLE_NFSSERVER,test "$enable_nfsserver" = "yes")
AC_SUBST(NFSSERVER)

AC_ARG_ENABLE(cifs,
	AS_HELP_STRING(--enable-cifs,    enable the samba clients),
	[case "${enableval}" in
		yes) CIFS=samba-client ;;
	esac],[enable_cifs=no])
AM_CONDITIONAL(ENABLE_CIFS,test "$enable_cifs" = "yes")
AC_SUBST(CIFS)

AC_ARG_ENABLE(sg3,
	AS_HELP_STRING(--enable-sg3,    enable the sg3-utils),
	[case "${enableval}" in
		yes) SG3=sg3_utils ;;
	esac],[enable_sg3=no])
AM_CONDITIONAL(ENABLE_SG3,test "$enable_sg3" = "yes")
AC_SUBST(SG3)

AC_ARG_ENABLE(var,
	AS_HELP_STRING(--enable-var,    move stock and libs into var),
	[case "${enableval}" in
		yes) VAR=var ;;
	esac],[enable_var=no])
AM_CONDITIONAL(ENABLE_VAR,test "$enable_var" = "yes")
AC_SUBST(VAR)

AC_ARG_WITH(rootpartitionsize,
	[  --with-rootpartitionsize=SIZE	size of the root partition],
	[ROOT_PARTITION_SIZE="$withval"],[ROOT_PARTITION_SIZE="0x240000"])
AC_SUBST(ROOT_PARTITION_SIZE)

AC_ARG_WITH(datapartitionsize,
	[  --with-datapartitionsize=SIZE	size of the data partition],
	[DATA_PARTITION_SIZE="$withval"],[DATA_PARTITION_SIZE="0x400000"])
AC_SUBST(DATA_PARTITION_SIZE)

AC_ARG_ENABLE(ccache,
	AS_HELP_STRING(--enable-ccache,	enable ccache),
	[case "${enableval}" in
		yes) CCACHE_BIN=ccache;;
	esac], [enable_ccache=no])
AM_CONDITIONAL(ENABLE_CCACHE,test "$enable_ccache" = "yes")
AC_SUBST(CCACHE_BIN)

AC_ARG_ENABLE(fortis_hdbox,
	AS_HELP_STRING(--enable-fortis_hdbox,    enable Fortis/hdbox FS-9200HD PVR stuff),
	[case "${enableval}" in
		yes) FORTIS_HDBOX=fortis_hdbox ;;
	esac],[enable_fortis_hdbox=no])
AM_CONDITIONAL(ENABLE_FORTIS_HDBOX,test "$enable_fortis_hdbox" = "yes")
AC_SUBST(FORTIS_HDBOX)

AC_ARG_ENABLE(atevio7500,
	AS_HELP_STRING(--enable-atevio7500,    enable Atevio 7500 PVR stuff),
	[case "${enableval}" in
		yes) ATEVIO7500=atevio7500 ;;
	esac],[enable_atevio7500=no])
AM_CONDITIONAL(ENABLE_ATEVIO7500,test "$enable_atevio7500" = "yes")
AC_SUBST(ATEVIO7500)

AC_ARG_ENABLE(octagon1008,
	AS_HELP_STRING(--enable-octagon1008,    enable Octagon 1008 stuff),
	[case "${enableval}" in
		yes) OCTAGON1008=octagon1008 ;;
	esac],[enable_octagon1008=no])
AM_CONDITIONAL(ENABLE_OCTAGON1008,test "$enable_octagon1008" = "yes")
AC_SUBST(OCTAGON1008)

AC_ARG_ENABLE(tf7700,
	AS_HELP_STRING(--enable-tf7700,    enable topfield tf7700 stuff),
	[case "${enableval}" in
		yes) TF7700=tf7700 ;;
	esac],[enable_tf7700=no])
AM_CONDITIONAL(ENABLE_TF7700,test "$enable_tf7700" = "yes")
AC_SUBST(TF7700)

AC_ARG_ENABLE(hl101,
	AS_HELP_STRING(--enable-hl101,    enable spider box hl101 stuff),
	[case "${enableval}" in
		yes) HL101=hl101 ;;
	esac],[enable_hl101=no])
AM_CONDITIONAL(ENABLE_HL101,test "$enable_hl101" = "yes")
AC_SUBST(HL101)

AC_ARG_ENABLE(vip2_v1,
	AS_HELP_STRING(--enable-vip2_v1,    enable edision argus vip2_v1 stuff),
	[case "${enableval}" in
		yes) VIP2_V1=vip2_v1 ;;
	esac],[enable_vip2_v1=no])
AM_CONDITIONAL(ENABLE_VIP2_V1,test "$enable_vip2_v1" = "yes")
AC_SUBST(VIP2_V1)

AC_ARG_ENABLE(vip1_v2,
	AS_HELP_STRING(--enable-vip1_v2,    enable edision argus vip1_v2 stuff),
	[case "${enableval}" in
		yes) VIP1_V2=vip1_v2 ;;
	esac],[enable_vip1_v2=no])
AM_CONDITIONAL(ENABLE_VIP1_V2,test "$enable_vip1_v2" = "yes")
AC_SUBST(VIP1_V2)

AC_ARG_ENABLE(spark,
    AS_HELP_STRING(--enable-spark,    enable spark),
    [case "${enableval}" in
        yes) SPARK=spark ;;
    esac],[enable_spark=no])
AM_CONDITIONAL(ENABLE_SPARK,test "$enable_spark" = "yes")
AC_SUBST(SPARK)

AC_ARG_ENABLE(spark7162,
    AS_HELP_STRING(--enable-spark7162,    enable spark7162),
    [case "${enableval}" in
        yes) SPARK7162=spark7162 ;;
    esac],[enable_spark7162=no])
AM_CONDITIONAL(ENABLE_SPARK7162,test "$enable_spark7162" = "yes")
AC_SUBST(SPARK7162)

AC_ARG_ENABLE(adb_box,
	AS_HELP_STRING(--enable-adb_box,    enable adb_box stuff),
	[case "${enableval}" in
		yes) ADB_BOX=adb_box ;;
	esac],[enable_adb_box=no])
AM_CONDITIONAL(ENABLE_ADB_BOX,test "$enable_adb_box" = "yes")
AC_SUBST(ADB_BOX)
AC_ARG_ENABLE(ufs922,
	AS_HELP_STRING(--enable-ufs922,    enable kathrein ufs922 stuff),
	[case "${enableval}" in
		yes) UFS922=ufs922 ;;
	esac],[enable_ufs922=no])
AM_CONDITIONAL(ENABLE_UFS922,test "$enable_ufs922" = "yes")
AC_SUBST(UFS922)

AC_ARG_ENABLE(ufs910,
	AS_HELP_STRING(--enable-ufs910,    enable kathrein ufs910 stuff),
	[case "${enableval}" in
		yes) UFS910=ufs910 ;;
	esac],[enable_ufs910=no])
AM_CONDITIONAL(ENABLE_UFS910,test "$enable_ufs910" = "yes")
AC_SUBST(UFS910)

AC_ARG_ENABLE(ufs912,
	AS_HELP_STRING(--enable-ufs912,    enable kathrein ufs912 stuff),
	[case "${enableval}" in
		yes) UFS912=ufs912 ;;
	esac],[enable_ufs912=no])
AM_CONDITIONAL(ENABLE_UFS912,test "$enable_ufs912" = "yes")
AC_SUBST(UFS912)

AC_ARG_ENABLE(hs7810a,
	AS_HELP_STRING(--enable-hs7810a,    enable fortis hs7810a stuff),
	[case "${enableval}" in
		yes) HS7810A=hs7810a ;;
	esac],[enable_hs7810a=no])
AM_CONDITIONAL(ENABLE_HS7810A,test "$enable_hs7810a" = "yes")
AC_SUBST(HS7810A)

AC_ARG_ENABLE(hs7110,
	AS_HELP_STRING(--enable-hs7110,    enable fortis hs7110 stuff),
	[case "${enableval}" in
		yes) HS7110=hs7110 ;;
	esac],[enable_hs7110=no])
AM_CONDITIONAL(ENABLE_HS7110,test "$enable_hs7110" = "yes")
AC_SUBST(HS7110)

AC_ARG_ENABLE(cuberevo,
	AS_HELP_STRING(--enable-cuberevo,    enable cuberevo stuff),
	[case "${enableval}" in
		yes) CUBEREVO=cuberevo ;;
	esac],[enable_cuberevo=no])
AM_CONDITIONAL(ENABLE_CUBEREVO,test "$enable_cuberevo" = "yes")
AC_SUBST(CUBEREVO)

AC_ARG_ENABLE(cuberevo_mini,
	AS_HELP_STRING(--enable-cuberevo_mini,    enable cuberevo mini stuff),
	[case "${enableval}" in
		yes) CUBEREVO_MINI=cuberevo_mini ;;
	esac],[enable_cuberevo_mini=no])
AM_CONDITIONAL(ENABLE_CUBEREVO_MINI,test "$enable_cuberevo_mini" = "yes")
AC_SUBST(CUBEREVO_MINI)

AC_ARG_ENABLE(cuberevo_mini2,
	AS_HELP_STRING(--enable-cuberevo_mini2,    enable cuberevo mini 2 stuff),
	[case "${enableval}" in
		yes) CUBEREVO_MINI2=cuberevo_mini2 ;;
	esac],[enable_cuberevo_mini2=no])
AM_CONDITIONAL(ENABLE_CUBEREVO_MINI2,test "$enable_cuberevo_mini2" = "yes")
AC_SUBST(CUBEREVO_MINI2)

AC_ARG_ENABLE(cuberevo_mini_fta,
	AS_HELP_STRING(--enable-cuberevo_mini_fta,    enable cuberevo mini fta stuff),
	[case "${enableval}" in
		yes) CUBEREVO_MINI_FTA=cuberevo_mini_fta ;;
	esac],[enable_cuberevo_mini_fta=no])
AM_CONDITIONAL(ENABLE_CUBEREVO_MINI_FTA,test "$enable_cuberevo_mini_fta" = "yes")
AC_SUBST(CUBEREVO_MINI_FTA)

AC_ARG_ENABLE(cuberevo_250hd,
	AS_HELP_STRING(--enable-cuberevo_250hd,    enable cuberevo 250hd stuff),
	[case "${enableval}" in
		yes) CUBEREVO_250HD=cuberevo_250hd ;;
	esac],[enable_cuberevo_250hd=no])
AM_CONDITIONAL(ENABLE_CUBEREVO_250HD,test "$enable_cuberevo_250hd" = "yes")
AC_SUBST(CUBEREVO_250HD)

AC_ARG_ENABLE(cuberevo_2000hd,
	AS_HELP_STRING(--enable-cuberevo_2000hd,    enable cuberevo 2000hd stuff),
	[case "${enableval}" in
		yes) CUBEREVO_2000HD=cuberevo_2000hd ;;
	esac],[enable_cuberevo_2000hd=no])
AM_CONDITIONAL(ENABLE_CUBEREVO_2000HD,test "$enable_cuberevo_2000hd" = "yes")
AC_SUBST(CUBEREVO_2000HD)

AC_ARG_ENABLE(cuberevo_9500hd,
	AS_HELP_STRING(--enable-cuberevo_9500hd,    enable cuberevo 9500hd stuff),
	[case "${enableval}" in
		yes) CUBEREVO_9500HD=cuberevo_9500hd ;;
	esac],[enable_cuberevo_9500hd=no])
AM_CONDITIONAL(ENABLE_CUBEREVO_9500HD,test "$enable_cuberevo_9500hd" = "yes")
AC_SUBST(CUBEREVO_9500HD)

AC_ARG_ENABLE(flash_ufs910,
	AS_HELP_STRING(--enable-flash_ufs910,    enable flash ufs910 stuff),
	[case "${enableval}" in
		yes) FLASH_UFS910=flash_ufs910 ;;
	esac],[enable_flash_ufs910=no])
AM_CONDITIONAL(ENABLE_FLASH_UFS910,test "$enable_flash_ufs910" = "yes")
AC_SUBST(FLASH_UFS910)

AC_ARG_ENABLE(homecast5101,
	AS_HELP_STRING(--enable-homecast5101,    enable homecast 5101 stuff),
	[case "${enableval}" in
		yes) HOMECAST5101=hs5101 ;;
	esac],[enable_homecast5101=no])
AM_CONDITIONAL(ENABLE_HOMECAST5101,test "$enable_homecast5101" = "yes")
AC_SUBST(HOMECAST5101)

AC_ARG_ENABLE(ipbox9900,
	AS_HELP_STRING(--enable-ipbox9900,    enable ipbox 9900 stuff),
	[case "${enableval}" in
		yes) IPBOX9900=ipbox9900 ;;
	esac],[enable_ipbox9900=no])
AM_CONDITIONAL(ENABLE_IPBOX9900,test "$enable_ipbox9900" = "yes")
AC_SUBST(IPBOX9900)

AC_ARG_ENABLE(ipbox99,
	AS_HELP_STRING(--enable-ipbox99,    enable ipbox 99 stuff),
	[case "${enableval}" in
		yes) IPBOX99=ipbox99 ;;
	esac],[enable_ipbox99=no])
AM_CONDITIONAL(ENABLE_IPBOX99,test "$enable_ipbox99" = "yes")
AC_SUBST(IPBOX99)

AC_ARG_ENABLE(ipbox55,
	AS_HELP_STRING(--enable-ipbox55,    enable ipbox 55 stuff),
	[case "${enableval}" in
		yes) IPBOX55=ipbox55 ;;
	esac],[enable_ipbox55=no])
AM_CONDITIONAL(ENABLE_IPBOX55,test "$enable_ipbox55" = "yes")
AC_SUBST(IPBOX55)



AC_SUBST(CFLAGS)
AC_SUBST(TARGET_CFLAGS)
AC_SUBST(TARGET_CXXFLAGS)
AC_SUBST(TARGET_LDFLAGS)

AC_PREFIX_DEFAULT(/ufs910)

if test "$prefix" = "NONE"; then
	prefix=/ufs910
fi

AC_ARG_WITH(targetprefix,
	[  --with-targetprefix=DIR prefix for target files [[PREFIX/cdkroot]]],
	[targetprefix="$with_targetprefix"],[targetprefix="${prefix}/cdkroot"])

AC_ARG_WITH(hostprefix,
	[  --with-hostprefix=DIR   prefix for host files [[PREFIX/host]]],
	[hostprefix="$with_hostprefix"],[hostprefix="${prefix}/host"])

AC_ARG_WITH(bootprefix,
	[  --with-bootprefix=DIR   prefix for boot files [[PREFIX/cdkroot-tftpboot]]],
	[bootprefix="$with_bootprefix"],[bootprefix="${prefix}/cdkroot-tftpboot"])

AC_ARG_WITH(flashprefix,
	[  --with-flashprefix=DIR  prefix for flash files [[PREFIX/cdkflash]] (only used for flash building)],
	[flashprefix="$with_flashprefix"],[flashprefix="${prefix}/cdkflash"])

AC_ARG_WITH(ipkprefix,
	[  --with-ipkprefix=DIR  prefix for ipkg package files [[PREFIX/ipk]]],
	[ipkprefix="$with_ipkprefix"],[ipkprefix="${prefix}/ipk"])

AC_ARG_WITH(serversupport,
	[  --with-serversupport=DIR  prefix for server file templates [[PREFIX/serversupport]]],
	[serversupport="$with_serversupport"],[serversupport="${prefix}/serversupport"])

AC_ARG_WITH(ucodesdir,
	[  --with-ucodesdir=DIR  optional directory containing ucodes [[NONE]]],
	[ucodesdir="$with_ucodesdir"],[ucodesdir="NONE"])

AC_ARG_WITH(customizationsdir,
	[  --with-customizationsdir=DIR  optional directory containing customization scripts [[[CVS]]]],
	[customizationsdir="$with_customizationsdir"],[customizationsdir="`pwd`"])

AC_ARG_WITH(updatehttpprefix,
	[  --with-updatehttpprefix=URL  optional URL containing the URL of a directory with update images [[NONE]]],
	[updatehttpprefix="$with_updatehttpprefix"],[updatehttpprefix=])

AC_ARG_WITH(stockdir,
	[  --with-stockdir=DIR  optional directory containing stock stuff [[[CVS/]stock]]],
	[stockdir="$with_stockdir"],[stockdir="`pwd`/stock"])

AC_ARG_WITH(ipkgbuilddir,
	[  --with-ipkgbuilddir=DIR  temporary directory for building ipkg packages [[[CVS]/ipkgbuild]]],
	[ipkgbuilddir="$with_ipkgbuilddir"],[ipkgbuilddir="`pwd`/ipkgbuild"])

buildprefix=`pwd`
AC_SUBST(targetprefix)
AC_SUBST(hostprefix)
AC_SUBST(buildprefix)
AC_SUBST(bootprefix)
AC_SUBST(flashprefix)
AC_SUBST(ipkprefix)
AC_SUBST(serversupport)
AC_SUBST(ucodesdir)
AC_SUBST(customizationsdir)
AC_SUBST(updatehttpprefix)
AC_SUBST(stockdir)
AC_SUBST(ipkgbuilddir)
flashprefix_ro=${flashprefix}/ro
AC_SUBST(flashprefix_ro)
flashprefix_rw=${flashprefix}/rw
AC_SUBST(flashprefix_rw)

AC_ARG_WITH(checkImage,
	[  --with-checkImage=[[none,rename,warn]]	How/if to invoke checkImage [[none]]],
	[CHECKIMAGE_BEHAVIOR="$withval"],[CHECKIMAGE_BEHAVIOR="true"])
if [[ "$withval" = "rename" ]] ; then
	TUXBOX_CHECKIMAGE='$(hostprefix)/bin/checkImage $@ || mv $@ $@_bad'
elif [[ "$withval" = "warn" ]] ; then
	TUXBOX_CHECKIMAGE='rm -f $@_bad; $(hostprefix)/bin/checkImage $@ || touch $@_bad'
else
	TUXBOX_CHECKIMAGE=@true
fi
AC_SUBST(TUXBOX_CHECKIMAGE)

AC_ARG_WITH(cvsdir,
	[  --with-cvsdir=DIR       where to find the cvs],
	[cvsdir="$with_cvsdir"],[cvsdir="NONE"])

AC_ARG_WITH(appsdir,
	[  --with-appsdir=DIR      apps dir from cvs [[[CVS/]apps/]]],
	[appsdir="$with_appsdir"],[appsdir="NONE"])

AC_ARG_WITH(bootdir,
	[  --with-bootdir=DIR      boot dir from cvs [[[CVS/]boot/]]],
	[bootdir="$with_bootdir"],[bootdir="NONE"])

AC_ARG_WITH(driverdir,
	[  --with-driverdir=DIR    driver dir from cvs [[[CVS/]driver]]],
	[driverdir="$with_driverdir"],[driverdir="NONE"])

AC_ARG_WITH(hostappsdir,
	[  --with-hostappsdir=DIR  hostapps dir from cvs [[[CVS/]hostapps]]],
	[hostappsdir="$with_hostappsdir"],[hostappsdir="NONE"])

AC_ARG_WITH(gnuserver,
	[  --with-gnuserver=ADDRESS   the gnu server for gnu-stuff (without ftp://)],
	[gnuserver="$with_gnuserver"],[gnuserver="NONE"])

AC_ARG_WITH(defaultserver,
	[  --with-defaultserver=ADDRESS   the server that is taken if no server is given/works (without http://)],
	[defaultserver="$with_defaultserver"],[defaultserver="NONE"])

if test "$cvsdir" = "NONE"; then
	if test "$appsdir" = "NONE"; then
		appsdir="$buildprefix/apps"
	fi
	if test "$bootdir" = "NONE"; then
		bootdir="$buildprefix/boot"
	fi
	if test "$driverdir" = "NONE"; then
		driverdir="$buildprefix/driver"
	fi
	if test "$hostappsdir" = "NONE"; then
		hostappsdir="$buildprefix/hostapps"
	fi
else
	if test "$appsdir" = "NONE"; then
		appsdir="$cvsdir/apps"
	fi
	if test "$bootdir" = "NONE"; then
		bootdir="$cvsdir/boot"
	fi
	if test "$driverdir" = "NONE"; then
		driverdir="$cvsdir/driver"
	fi
	if test "$hostappsdir" = "NONE"; then
		hostappsdir="$cvsdir/hostapps"
	fi
fi

if test "$gnuserver" = "NONE"; then
	gnuserver="ftp.gwdg.de/pub/misc/gnu/ftp/gnu"
fi

if test "$defaultserver" = "NONE"; then
	defaultserver=""
fi

dircheck="ok"
AC_MSG_CHECKING([for apps directory])
#if test ! -f "$appsdir/dvb/zapit/configure.ac" ; then
if test ! -f "$appsdir/enigma2/configure.ac" ; then
	AC_MSG_WARN([appsdir $appsdir not found])
	appsdir="missing_appsir"
	dircheck="fail"
else
	AC_MSG_RESULT([yes])
fi

AC_MSG_CHECKING([for boot directory])
if test ! -d "$bootdir/u-boot-tufsbox" ; then
	AC_MSG_WARN([bootdir $bootdir not found])
	bootdir="missing_bootdir"
	dircheck="fail"
else
	AC_MSG_RESULT([yes])
fi

AC_MSG_CHECKING([for driver directory])
if test ! -f "$driverdir/Makefile" ; then
	AC_MSG_WARN([driverdir $driverdir not found])
	driverdir="missing_driverdir"
	dircheck="fail"
else
	AC_MSG_RESULT([yes])
fi

AC_MSG_CHECKING([for hostapps directory])
if test ! -f "$hostappsdir/configure.ac" ; then
	AC_MSG_WARN([hostappsdir $hostappsdir not found])
	hostappsdir="missing_hostappsdir"
	dircheck="fail"
else
	AC_MSG_RESULT([yes])
fi

AC_SUBST(appsdir)
AC_SUBST(bootdir)
AC_SUBST(driverdir)
AC_SUBST(hostappsdir)
AC_SUBST(gnuserver)
AC_SUBST(defaultserver)

AC_PATH_PROG(M4,m4,no)
if test "$M4" = "no"; then
	AC_MSG_WARN(No m4 found)
fi

AC_PATH_PROG(BZIP2,bzip2,no)
if test "$BZIP2" = "no"; then
	AC_MSG_WARN(No bzip2 found)
fi

AC_PATH_PROG(MAKEINFO,makeinfo,no)
if test "$MAKEINFO" = "no"; then
	AC_MSG_WARN(No makeinfo found)
fi

AC_PROG_CXX
if test "$CXX" = "g++" -a "$GXX" != "yes"; then
	AC_MSG_ERROR(No g++ found)
fi

AC_PROG_LEX
if test "$LEX" != "flex"; then
	AC_MSG_ERROR(No flex found)
fi

AC_PROG_YACC
if test "$YACC" != "bison -y"; then
	AC_MSG_ERROR(No bison found)
fi

if test "$enable_flashrules" = "yes"; then
	MKLIBS="$hostappsdir/mklibs/mklibs.py"
	AC_SUBST(MKLIBS)

	AC_PATH_PROG(MKCRAMFS,mkcramfs,no)
	if test "$MKCRAMFS" = "no"; then
		AC_MSG_WARN(using tufsbox cramfs)
		MKCRAMFS=$hostprefix/bin/mkcramfs
	fi
	AC_PATH_PROG(MKJFFS2,mkjffs2,no)
	if test "$MKJFFS2" = "no"; then
		AC_PATH_PROG(MKFSJFFS2,mkfs.jffs2,no)
		if test "$MKFSJFFS2" = "no"; then
			AC_MSG_WARN(using tufsbox mkfs.jffs2)
			MKFSJFFS2="$hostprefix/bin/mkfs.jffs2"
		fi
		MKJFFS2="$MKFSJFFS2"
	fi
	AC_PATH_PROG(CFV,cfv,no)
	if test "$CFV" = "no"; then
		AC_MSG_WARN(No cfv found)
	fi

	AC_PATH_PROG(FAKEROOT,fakeroot,no)
	if test "$fakeroot" = "no"; then
		AC_MSG_ERROR(No fakeroot found)
	fi
fi

if test "$enable_ccache" = "yes"; then
	AC_PATH_PROG(CCACHE,ccache,no)
	if test "$CCACHE" = "no"; then
		AC_MSG_WARN(No ccache found)
		CCACHE=$hostprefix/bin/ccache
	fi
fi

FONTDIR="/share/fonts"
AC_SUBST(FONTDIR)
UCODEDIR="/var/tufsbox/ucodes"
AC_SUBST(UCODEDIR)

CLEANUP="rm -rf"
AC_SUBST(CLEANUP)

DEPSCLEANUP="rm -f"
AC_SUBST(DEPSCLEANUP)

RPMDEPSCLEANUP="rm -f"
AC_SUBST(RPMDEPSCLEANUP)

DISTCLEANUP="rm -rf"
AC_SUBST(DISTCLEANUP)

#
# core
#
AC_SUBST(KERNELVERSION)
AC_SUBST(KERNELSTMLABEL)
AC_SUBST(KERNELLABEL)
TUXBOX_RULES_MAKE(linux)
TUXBOX_RULES_MAKE(linuxp0040)
TUXBOX_RULES_MAKE(linuxp0041)
TUXBOX_RULES_MAKE(linux23)
TUXBOX_RULES_MAKE(linuxp0119)
TUXBOX_RULES_MAKE(linuxp0123)
TUXBOX_RULES_MAKE(linux24)
TUXBOX_RULES_MAKE(linuxp0201)
TUXBOX_RULES_MAKE(linuxp0205)
TUXBOX_RULES_MAKE(linuxp0206)
TUXBOX_RULES_MAKE(linuxp0207)
TUXBOX_RULES_MAKE(linuxp0209)

if test "$enable_stm22" = "yes"; then
	if test "$enable_p0040" == "yes"; then
		KERNELVERSION=${VERSION_linuxp0040}
		KERNELSTMLABEL="_${VERSION_linuxp0040#*_}"
	elif test "$enable_p0041" == "yes"; then
		KERNELVERSION=${VERSION_linuxp0041}
		KERNELSTMLABEL="_${VERSION_linuxp0041#*_}"
	else
		KERNELVERSION=${VERSION_linux}
		KERNELSTMLABEL="_${VERSION_linux#*_}"
	fi
else
if test "$enable_stm23" = "yes"; then
	if test "$enable_p0123" == "yes"; then
		KERNELVERSION=${VERSION_linuxp0123}
		KERNELSTMLABEL="_${VERSION_linuxp0123#*_}"
		KERNELLABEL="123"
	else
		KERNELVERSION=${VERSION_linuxp0119}
		KERNELSTMLABEL="_${VERSION_linuxp0119#*_}"
		KERNELLABEL="119"
	fi
else
	if test "$enable_havana_p0207_5" == "yes"; then
		KERNELVERSION=${VERSION_linuxp0207}
		KERNELSTMLABEL="_${VERSION_linuxp0207#*_}"
		KERNELLABEL="207"
    elif test "$enable_p0209" == "yes"; then
		KERNELVERSION=${VERSION_linuxp0209}
		KERNELSTMLABEL="_${VERSION_linuxp0209#*_}"
		KERNELLABEL="209"
    elif test "$enable_p0207" == "yes"; then
		KERNELVERSION=${VERSION_linuxp0207}
		KERNELSTMLABEL="_${VERSION_linuxp0207#*_}"
		KERNELLABEL="207"
	elif test "$enable_p0206" == "yes"; then
		KERNELVERSION=${VERSION_linuxp0206}
		KERNELSTMLABEL="_${VERSION_linuxp0206#*_}"
		KERNELLABEL="206"
	elif test "$enable_p0205" == "yes"; then
		KERNELVERSION=${VERSION_linuxp0205}
		KERNELSTMLABEL="_${VERSION_linuxp0205#*_}"
		KERNELLABEL="205"
	else
		KERNELVERSION=${VERSION_linuxp0201}
		KERNELSTMLABEL="_${VERSION_linuxp0201#*_}"
		KERNELLABEL="201"
	fi
fi
fi

AC_SUBST(EXTERNALLCD_DEP)

if test "$enable_externallcd" == "yes"; then
	EXTERNALLCD_DEP="graphlcd"
else
	EXTERNALLCD_DEP=""
fi

AC_SUBST(MEDIAFW)
AC_SUBST(MEDIAFW_DEP)

if test "$enable_mediafwgstreamer" == "yes"; then
	MEDIAFW="gstreamer"
	MEDIAFW_DEP="gst_plugins_dvbmediasink"
else
	MEDIAFW="eplayer3"
	MEDIAFW_DEP="ffmpeg"
fi

#TUXBOX_RULES_MAKE_EXDIR(binutils)
#TUXBOX_RULES_MAKE_EXDIR(bootstrap_gcc)
#TUXBOX_RULES_MAKE_EXDIR(glibc)
#TUXBOX_RULES_MAKE_EXDIR(gcc)
#TUXBOX_RULES_MAKE(uclibc)

#
# core
#
TUXBOX_RULES_MAKE(squashfs)
TUXBOX_RULES_MAKE(ccache)
TUXBOX_RULES_MAKE(cramfs)
TUXBOX_RULES_MAKE(ipkg_utils)
TUXBOX_RULES_MAKE(ipkg_host)
TUXBOX_RULES_MAKE(host_python)
TUXBOX_RULES_MAKE(libtool)

#
# root
#
TUXBOX_RULES_MAKE(busybox)
TUXBOX_RULES_MAKE(lsb)
TUXBOX_RULES_MAKE(ipkg)
TUXBOX_RULES_MAKE(module_init_tools)
TUXBOX_RULES_MAKE(sysvinit)

#
# net apps
#
TUXBOX_RULES_MAKE(portmap)
TUXBOX_RULES_MAKE(nfs_utils)
TUXBOX_RULES_MAKE(autofs)
TUXBOX_RULES_MAKE(vsftpd)
TUXBOX_RULES_MAKE(netkit_ftp)
TUXBOX_RULES_MAKE(samba)
TUXBOX_RULES_MAKE(netio)
TUXBOX_RULES_MAKE(lighttpd)
TUXBOX_RULES_MAKE(wireless_tools)
TUXBOX_RULES_MAKE(zd1211)
TUXBOX_RULES_MAKE(wpa_supplicant)
TUXBOX_RULES_MAKE(ethtool)

#
# contrib apps
#
TUXBOX_RULES_MAKE(grep)
TUXBOX_RULES_MAKE(openrdate)
TUXBOX_RULES_MAKE(e2fsprogs)
TUXBOX_RULES_MAKE(xfsprogs)
TUXBOX_RULES_MAKE(mc)
TUXBOX_RULES_MAKE(sdparm)
TUXBOX_RULES_MAKE(sg3_utils)
TUXBOX_RULES_MAKE(console_data)
TUXBOX_RULES_MAKE(nano)
TUXBOX_RULES_MAKE(rsync)
TUXBOX_RULES_MAKE(lm_sensors)
TUXBOX_RULES_MAKE(fuse)
TUXBOX_RULES_MAKE(curlftpfs)
TUXBOX_RULES_MAKE(fbset)
TUXBOX_RULES_MAKE(pngquant)
TUXBOX_RULES_MAKE(mplayer)
TUXBOX_RULES_MAKE(mencoder)
TUXBOX_RULES_MAKE(util_linux)
TUXBOX_RULES_MAKE(jfsutils)
TUXBOX_RULES_MAKE(opkg)

#
# contrib libs
#
TUXBOX_RULES_MAKE(libboost)
TUXBOX_RULES_MAKE(ncurses)
TUXBOX_RULES_MAKE(libz)
TUXBOX_RULES_MAKE(libreadline)
TUXBOX_RULES_MAKE(freetype_old)
TUXBOX_RULES_MAKE(freetype)
TUXBOX_RULES_MAKE(lirc)
TUXBOX_RULES_MAKE(jpeg)
TUXBOX_RULES_MAKE(libpng)
TUXBOX_RULES_MAKE(libungif)
TUXBOX_RULES_MAKE(libgif)
TUXBOX_RULES_MAKE(curl)
TUXBOX_RULES_MAKE(libfribidi)
TUXBOX_RULES_MAKE(libsigc)
TUXBOX_RULES_MAKE(libmad)
TUXBOX_RULES_MAKE(libid3tag)
TUXBOX_RULES_MAKE(libxml2)
TUXBOX_RULES_MAKE(libxslt)
TUXBOX_RULES_MAKE(libvorbisidec)
TUXBOX_RULES_MAKE(glib2)
TUXBOX_RULES_MAKE(libiconv)
TUXBOX_RULES_MAKE(libmng)
TUXBOX_RULES_MAKE(lcms)
TUXBOX_RULES_MAKE(openssl)
TUXBOX_RULES_MAKE(directfb)
TUXBOX_RULES_MAKE(dfbpp)
TUXBOX_RULES_MAKE(expat)
TUXBOX_RULES_MAKE(fontconfig)
TUXBOX_RULES_MAKE(python)
TUXBOX_RULES_MAKE(elementtree)
TUXBOX_RULES_MAKE(lxml)
TUXBOX_RULES_MAKE(libxmlccwrap)
TUXBOX_RULES_MAKE(zope_interface)
TUXBOX_RULES_MAKE(setuptools)
TUXBOX_RULES_MAKE(twisted)
TUXBOX_RULES_MAKE(twistedweb2)
TUXBOX_RULES_MAKE(a52dec)
TUXBOX_RULES_MAKE(libdvdcss)
TUXBOX_RULES_MAKE(libdvdnav)
TUXBOX_RULES_MAKE(libdvdread)
TUXBOX_RULES_MAKE(pyopenssl)
TUXBOX_RULES_MAKE(ffmpeg)
TUXBOX_RULES_MAKE(libass)
TUXBOX_RULES_MAKE(webkitdfb)
TUXBOX_RULES_MAKE(icu4c)
TUXBOX_RULES_MAKE(enchant)
TUXBOX_RULES_MAKE(lite)
TUXBOX_RULES_MAKE(sqlite)
TUXBOX_RULES_MAKE(libsoup)
TUXBOX_RULES_MAKE(pixman)
TUXBOX_RULES_MAKE(cairo)
TUXBOX_RULES_MAKE(libogg)
TUXBOX_RULES_MAKE(libflac)
TUXBOX_RULES_MAKE(libcap)
TUXBOX_RULES_MAKE(evebrowser)
TUXBOX_RULES_MAKE(brofs)
TUXBOX_RULES_MAKE(gstreamer)
TUXBOX_RULES_MAKE(gst_plugins_base)
TUXBOX_RULES_MAKE(gst_plugins_good)
TUXBOX_RULES_MAKE(gst_plugins_bad)
TUXBOX_RULES_MAKE(gst_plugins_ugly)
TUXBOX_RULES_MAKE(gst_ffmpeg)
TUXBOX_RULES_MAKE(gst_plugins_dvbmediasink)
TUXBOX_RULES_MAKE(libalsa)
TUXBOX_RULES_MAKE(libusb)

#
# GUI
#
#TUXBOX_RULES_MAKE(enigma2)

#
# development
#
TUXBOX_RULES_MAKE(ruby)

#
# framebuffer
#
#TUXBOX_RULES_MAKE_RPM(directfb)
TUXBOX_RULES_MAKE_RPM(directfb_examples)

#
# in work
#
TUXBOX_RULES_MAKE(flashybrid)
TUXBOX_RULES_MAKE(record)
TUXBOX_RULES_MAKE(netkit_base)

#
# dummy
#

#
# msttf
#

#
# additional
#

#
# java
#

#
# fun stuff
#

#
# dvb apps
#

#
# bluetooth
#

#
# RPM stuff
#
configprefix=$prefix/config
crossprefix=$prefix/devkit/sh4
devkitprefix=$prefix/devkit
rpmdbprefix=${targetprefix}-rpmdb
kernelprefix=$buildprefix
AC_SUBST(crossprefix)
AC_SUBST(configprefix)
AC_SUBST(devkitprefix)
AC_SUBST(rpmdbprefix)
AC_SUBST(kernelprefix)

#
# localmacros
#
$INSTALL -d SOURCES SPECS BUILD SRPMS RPMS/{noarch,${host_arch},sh4}
test -f config && rm config || true
ln -sf $configprefix/rpm config || true
echo "%_topdir $buildprefix" >localmacros
echo "%_specdir %_topdir/SPECS" >>localmacros
echo "%_sourcedir %_topdir/SOURCES" >>localmacros
echo "%_builddir %_topdir/BUILD" >>localmacros
echo "%_buildrootdir %_topdir/BUILDROOT" >>localmacros
echo "%buildroot %_topdir/BUILDROOT/%{name}-%{version}-%{release}.${host_arch}" >>localmacros
echo "%_rpmdir %_topdir/RPMS" >>localmacros
echo "%_srcrpmdir %_topdir/SRPMS" >>localmacros
echo "%_stm_install_prefix $prefix/.." >>localmacros
echo "%_stm_base_prefix $prefix" >>localmacros
echo "%_stm_host_dir $hostprefix" >>localmacros
echo "%_stm_cross_dir $crossprefix" >>localmacros
echo "%_stm_config_dir $configprefix" >>localmacros
echo "%_stm_devkit_dir $devkitprefix" >>localmacros
echo "%_stm_cross_target_dir $targetprefix" >>localmacros
echo "%_stm_kernel_dir $kernelprefix" >>localmacros
echo "%_stm_sources_dir $kernelprefix" >>localmacros
echo "%_stm_host_arch ${host_arch}" >>localmacros
echo "%_stm_host_cpu ${host_cpu}" >>localmacros
echo "%_stm_host_config ${host_alias:-${host}}" >>localmacros
echo "%_dbpath $rpmdbprefix" >>localmacros
echo "%__bzip2 $BZIP2" >>localmacros
echo "%nohostbuilddeps 1" >> localmacros
echo "%_default_patch_fuzz 2" >> localmacros

# Determine how to pass options to rpm, depending on version and distribution
macrofiles="/usr/lib/rpm/macros:$configprefix/rpm/targets/sh4-linux:$configprefix/rpm/common:$buildprefix/localmacros"

RPMMAJOR=`rpm --version | awk '{print $NF}' | cut -d '.' -f 1`
RPMMINOR=`rpm --version | awk '{print $NF}' | cut -d '.' -f 2`

if test ${RPMMAJOR} -lt 4 -o ${RPMMAJOR} -eq 4 -a ${RPMMINOR} -lt 7 ; then
  # RPM < 4.7
  echo "macrofiles: ${macrofiles}" > localrc
  DRPMBUILD="--rcfile /usr/lib/rpm/rpmrc:localrc"
  DRPM=${DRPMBUILD}
else
  # RPM > 4.7
  DRPMBUILD="--macros ${macrofiles}"
  case `lsb_release -s -i` in
    Ubuntu* | Debian* ) DRPM="--force-debian ${DRPMBUILD}" ;;
    *) DRPM=${DRPMBUILD} ;;
  esac
fi

AC_SUBST(DRPM)
AC_SUBST(DRPMBUILD)

#	old
#test -d ../../Archive || mkdir ../../Archive
#ln -sf ../../Archive

test -d ~/Archive || mkdir ~/Archive
ln -sf ~/Archive
install -d $stockdir/{conf,root,.app,.eme,.dat}

#
# internal
#
AC_SUBST_FILE(ARCHIVE)
ARCHIVE=Makefile-archive
AC_CONFIG_COMMANDS_PRE([
AC_MSG_NOTICE([creating Makefile-archive])
${srcdir}/rules-archive.pl ${srcdir}/rules-archive > Makefile-archive
])

#
# summary
#

AC_MSG_RESULT([
summary:
-------------------------------------------------------------------------------
target cpu                  : $CPU_MODEL
linux kernel                : ${KERNELVERSION%.*}
kernelversion               : $KERNELVERSION
localversion                : $KERNELSTMLABEL
STLinux 2.2                 : $enable_stm22
STLinux 2.3                 : $enable_stm23
STLinux 2.3_Havana          : $enable_havana
STLinux 2.4                 : $enable_stm24
Patchlevel P0040            : $enable_p0040
Patchlevel P0041            : $enable_p0041
Patchlevel P0119            : $enable_p0119
Patchlevel P0123            : $enable_p0123
Patchlevel P0201            : $enable_p0201
Patchlevel P0205            : $enable_p0205
Patchlevel P0206            : $enable_p0206
Patchlevel P0207            : $enable_p0207
Patchlevel P0209            : $enable_p0209
HAVANA Patchlevel P0207_5   : $enable_havana_p0207_5
vdr VDR 1.7.11              : $enable_vdr1711
flash rules                 : $enable_flashrules
ccache                      : $enable_ccache
target prefix               : $targetprefix
boot prefix                 : $bootprefix
host prefix                 : $hostprefix
cross prefix                : $crossprefix
build prefix                : $buildprefix
ipk packages prefix         : $ipkprefix
root partition size         : $ROOT_PARTITION_SIZE
data partition size         : $DATA_PARTITION_SIZE
serversupport               : $serversupport
checkImage                  : $CHECKIMAGE_BEHAVIOR
target apps directory       : $appsdir
boot directory              : $bootdir
driver directory            : $driverdir
host apps directory         : $hostappsdir
customization directory     : $customizationsdir
ucode directory             : $ucodesdir
GNU server                  : $gnuserver
default server              : $defaultserver
update http prefix          : $updatehttpprefix
stock directory             : $stockdir
ipkg build directory        : $ipkgbuilddir
Fortis/hdbox stuff          : $enable_fortis_hdbox
Fortis hs7810a stuff        : $enable_hs7810a
Fortis hs7110 stuff         : $enable_hs7110
Atevio 7500 stuff           : $enable_atevio7500
octagon1008 stuff           : $enable_octagon1008
topfield stuff              : $enable_tf7700
spider-box hl101 stuff      : $enable_hl101
edision argus vip1 v2 stuff : $enable_vip1_v2
edision argus vip2 v1 stuff : $enable_vip2_v1
spark box stuff             : $enable_spark
spark7162 box stuff         : $enable_spark7162
adb_box stuff               : $enable_adb_box
ufs910 stuff                : $enable_ufs910
ufs910 flash                : $enable_flash_ufs910
ufs912 stuff                : $enable_ufs912
ufs922 stuff                : $enable_ufs922
cuberevo stuff              : $enable_cuberevo
cuberevo mini stuff         : $enable_cuberevo_mini
cuberevo mini 2 stuff       : $enable_cuberevo_mini2
cuberevo mini fta stuff     : $enable_cuberevo_mini_fta
cuberevo 250hd stuff        : $enable_cuberevo_250hd
cuberevo 2000hd stuff       : $enable_cuberevo_2000hd
cuberevo 9500hd stuff       : $enable_cuberevo_9500hd
homecast 5101 stuff         : $enable_homecast5101
ipbox 9900 stuff            : $enable_ipbox9900
ipbox 99 stuff              : $enable_ipbox99
ipbox 55 stuff              : $enable_ipbox55
XFS support for IDE         : $enable_xfs
NFS server                  : $enable_nfsserver
Samba Clients               : $enable_cifs
NTFS support for IDE        : $enable_ntfs
sg3 utils                   : $enable_sg3
DEBUG                       : $enable_debug
Player131                   : $enable_player131
Player179                   : $enable_player179
Player191                   : $enable_player191
Multicom322                 : $enable_multicom322
Multicom324                 : $enable_multicom324
MediaFw Gstreamer           : $enable_mediafwgstreamer
MediaFw                     : $MEDIAFW
MediaFw Dep                 : $MEDIAFW_DEP
EXTERNALLCD                 : $enable_externallcd
EXTERNALLCD_DEP             : $EXTERNALLCD_DEP
])

if test "$dircheck" = "fail"; then
AC_MSG_RESULT([
******************************************************************
*                       !!!WARNING!!!                            *
* one or more of your CVS source directories could not be found, *
* (for details see above), did you maybe supply an incorrect     *
*  --with-cvsdir argument to configure?                          *
*                       !!!WARNING!!!                            *
******************************************************************
])
fi

TUXBOX_TOUCH='[@[ "x$*" = "x" ] && touch $@ || true]'
AC_SUBST(TUXBOX_TOUCH)
TUXBOX_YAUD_CUSTOMIZE='[[ -x $(customizationsdir)/$(notdir $@)-local.sh ] && $(customizationsdir)/$(notdir $@)-local.sh $(prefix)/$*cdkroot $(buildprefix) || true]'
AC_SUBST(TUXBOX_YAUD_CUSTOMIZE)
FLASHROOTDIR_MODIFIED='touch $(flashprefix)/root'
AC_SUBST(FLASHROOTDIR_MODIFIED)
TUXBOX_CUSTOMIZE='[[ -x $(customizationsdir)/$(notdir $@)-local.sh ] && $(customizationsdir)/$(notdir $@)-local.sh $(flashprefix) $(buildprefix) || true]'
AC_SUBST(TUXBOX_CUSTOMIZE)
TUXBOX_FLASHROOT_MODIFIED='[[ "x$*" = "x$(flashprefix)/root" ] && touch $(flashprefix)/root || true]'
AC_SUBST(TUXBOX_FLASHROOT_MODIFIED)
TUXBOX_FLASH_CUSTOMIZE='[[ "x$*" = "x$(flashprefix)/root" -a -x $(customizationsdir)/$(notdir $@)-local.sh ] && $(customizationsdir)/$(notdir $@)-local.sh $(flashprefix) $(buildprefix) || true]'
AC_SUBST(TUXBOX_FLASH_CUSTOMIZE)
FLASHROOT_MODIFIED='[touch $(flashprefix)/root || true]'
AC_SUBST(FLASHROOT_MODIFIED)
FLASH_CUSTOMIZE='[[ -x $(customizationsdir)/$(notdir $@)-local.sh ] && $(customizationsdir)/$(notdir $@)-local.sh $(flashprefix) $(buildprefix) || true]'
AC_SUBST(FLASH_CUSTOMIZE)

AC_CONFIG_FILES([
Makefile
rules-downcheck.pl
])
#packages/fuse/Makefile

AC_CONFIG_COMMANDS([rules-downcheck-chmod],[chmod +x rules-downcheck.pl])

AC_OUTPUT
