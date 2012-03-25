AC_DEFUN([TUXBOX_RULES_MAKE],[
AC_MSG_CHECKING([$1 rules])
eval `${srcdir}/rules.pl make ${srcdir}/rules-make $1 cdkoutput`
INSTALL_$1=`${srcdir}/rules.pl install ${srcdir}/rules-install${INSTALLRULESETFILE} $1`
UNINSTALL_$1=`${srcdir}/rules.pl uninstall ${srcdir}/rules-uninstall $1`
DEPSCLEANUP_$1="rm .deps/$1"
DEPSCLEANUP="$DEPSCLEANUP .deps/$1"
LIST_CLEAN="$LIST_CLEAN $1-clean"
DISTCLEANUP_$1="rm -rf $DIR_$1"
DISTCLEANUP="$DISTCLEANUP $DIR_$1"
DEPSDISTCLEANUP_$1="rm .deps/$1 .deps/$1.do_compile .deps/$1.do_prepare"
LIST_DISTCLEAN="$LIST_DISTCLEAN $1-distclean"
AC_SUBST(DEPENDS_$1)dnl
AC_SUBST(DIR_$1)dnl
AC_SUBST(PREPARE_$1)dnl
AC_SUBST(VERSION_$1)dnl
AC_SUBST(INSTALL_$1)dnl
AC_SUBST(UNINSTALL_$1)dnl
AC_SUBST(DEPSCLEANUP_$1)dnl
AC_SUBST(DEPSCLEANUP)dnl
AC_SUBST(LIST_CLEAN)dnl
AC_SUBST(DISTCLEANUP_$1)dnl
AC_SUBST(DEPSDISTCLEANUP_$1)dnl
AC_SUBST(LIST_DISTCLEAN)dnl
AC_MSG_RESULT(done)
])

AC_DEFUN([TUXBOX_RULES_MAKE_EXDIR],[
AC_MSG_CHECKING([$1 rules])
eval `${srcdir}/rules.pl make ${srcdir}/rules-make $1 cdkoutput`
SOURCEDIR_$1=$DIR_$1
CONFIGURE_$1="../$DIR_$1/configure"
PREPARE_$1="$PREPARE_$1 && ( rm -rf build_$1 || /bin/true ) && mkdir build_$1"
INSTALL_$1=`${srcdir}/rules.pl install ${srcdir}/rules-install${INSTALLRULESETFILE} $1`
CLEANUP_$1="rm -rf $DIR_$1 build_$1"
CLEANUP="$CLEANUP $DIR_$1"
DIR_$1="build_$1"
AC_SUBST(CLEANUP_$1)dnl
AC_SUBST(CONFIGURE_$1)dnl
AC_SUBST(DEPENDS_$1)dnl
AC_SUBST(DIR_$1)dnl
AC_SUBST(INSTALL_$1)dnl
AC_SUBST(PREPARE_$1)dnl
AC_SUBST(SOURCEDIR_$1)dnl
AC_SUBST(VERSION_$1)dnl
AC_MSG_RESULT(done)
])

AC_DEFUN([TUXBOX_RULES_MAKE_RPM],[
AC_MSG_CHECKING([$1 rules])
eval `${srcdir}/rules.pl make ${srcdir}/rules-make $1 cdkoutput`
RPMDEPSCLEANUP_$1="rm .deps/$1"
RPMDEPSCLEANUP="$RPMDEPSCLEANUP .deps/$1"
RPMLIST_CLEAN="$RPMLIST_CLEAN $1-clean"
RPMDISTCLEANUP_$1="rm -rf $DIR_$1"
RPMDEPSDISTCLEANUP_$1="rm .deps/$1 .deps/$1.do_compile .deps/$1.do_prepare"
RPMLIST_DISTCLEAN="$RPMLIST_DISTCLEAN $1-distclean"
AC_SUBST(DIR_$1)dnl
AC_SUBST(RPMDEPSCLEANUP_$1)dnl
AC_SUBST(RPMDEPSCLEANUP)dnl
AC_SUBST(RPMLIST_CLEAN)dnl
AC_SUBST(RPMDISTCLEANUP_$1)dnl
AC_SUBST(RPMDEPSDISTCLEANUP_$1)dnl
AC_SUBST(RPMLIST_DISTCLEAN)dnl
AC_MSG_RESULT(done)
])
