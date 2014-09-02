AC_DEFUN([CHOOSE_BACKEND_COMPILER],
dnl Written by Dan Quinlan, 12/17/2001
dnl This macro selects the back-end C++ compiler to use to compile output 
dnl generated by preprocessors build using ROSE.  This macro needs to be called
dnl before the GET_COMPILER_SPECIFIC_DEFINES macro is called (so that defines 
dnl for the correct back-end C++ compiler are identified for use in preprocessors 
dnl build using ROSE)
[
# Make sure that we select a backend compiler before building the backend specific header files
# AC_BEFORE([CHOOSE_BACKEND_COMPILER],[GENERATE_BACKEND_COMPILER_SPECIFIC_HEADERS])
  AC_BEFORE([CHOOSE_BACKEND_COMPILER],[GENERATE_BACKEND_CXX_COMPILER_SPECIFIC_HEADERS])

  ROSE_CONFIGURE_SECTION([ROSE Backend])
  ROSE_SUPPORT_X10_BACKEND()

  AC_ARG_WITH(alternate_backend_Cxx_compiler,
    [  --with-alternate_backend_Cxx_compiler=<compiler name>
                                Specify an alternative C++ back-end compiler],
    [
    # Use a different compiler for the backend than for the compilation of ROSE source code
      BACKEND_CXX_COMPILER=$with_alternate_backend_Cxx_compiler
      AC_SUBST(BACKEND_CXX_COMPILER)
      echo "alternative back-end C++ compiler specified for generated translators to use: $BACKEND_CXX_COMPILER"
    ] ,
    [ 
    # Alternatively use the specified C++ compiler
	   BACKEND_CXX_COMPILER="$CXX"
      echo "default back-end C++ compiler for generated translators to use: $BACKEND_CXX_COMPILER"
    ])

  AC_ARG_WITH(alternate_backend_C_compiler,
    [  --with-alternate_backend_C_compiler=<compiler name>
                                Specify an alternative C back-end compiler],
    [
    # Use a different compiler for the backend than for the compilation of ROSE source code
      BACKEND_C_COMPILER=$with_alternate_backend_C_compiler
      AC_SUBST(BACKEND_C_COMPILER)
      echo "alternative back-end C compiler specified for generated translators to use: $BACKEND_C_COMPILER"
    ] ,
    [ 
    # Alternatively use the specified C compiler
	   BACKEND_C_COMPILER="$CC"
      echo "default back-end C compiler for generated translators to use: $BACKEND_C_COMPILER"
    ])

# DQ (10/3/2008): Added option to specify backend fortran compiler
  AC_ARG_WITH(alternate_backend_fortran_compiler,
    [  --with-alternate_backend_fortran_compiler=<compiler name>
                                Specify an alternative fortran back-end compiler],
    [
    # Use a different compiler for the backend than for the compilation of ROSE source code
      BACKEND_FORTRAN_COMPILER=$with_alternate_backend_fortran_compiler
      AC_SUBST(BACKEND_FORTRAN_COMPILER)
      echo "alternative back-end fortran compiler specified for generated translators to use: $BACKEND_FORTRAN_COMPILER"
    ] ,
    [ 
    # Alternatively use the specified fortran compiler
	 # BACKEND_FORTRAN_COMPILER="$FC"
	   BACKEND_FORTRAN_COMPILER="gfortran"
      echo "default back-end fortran compiler for generated translators to use: $BACKEND_FORTRAN_COMPILER"
    ])

# DQ (4/2/2011): Added option to specify backend Java compiler
  AC_ARG_WITH(alternate_backend_java_compiler,
    [  --with-alternate_backend_java_compiler=<compiler name>
                                Specify an alternative java back-end compiler],
    [
    # Use a different compiler for the backend than for the compilation of ROSE source code
      BACKEND_JAVA_COMPILER=$with_alternate_backend_java_compiler
      AC_SUBST(BACKEND_JAVA_COMPILER)
      echo "alternative back-end java compiler specified for generated translators to use: $BACKEND_JAVA_COMPILER"
    ] ,
    [ 
    # Alternatively use the specified java compiler
	   BACKEND_JAVA_COMPILER="javac"
      echo "default back-end java compiler for generated translators to use: $BACKEND_JAVA_COMPILER"
    ])

# DQ (8/29/2005): Added support for version numbering of backend compiler
  BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER=`echo|$BACKEND_CXX_COMPILER -dumpversion | cut -d\. -f1`
  BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER=`echo|$BACKEND_CXX_COMPILER -dumpversion | cut -d\. -f2`

# echo "back-end compiler for generated translators to use will be: $BACKEND_CXX_COMPILER"
  echo "     C++ back-end compiler major version number = $BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER"
  echo "     C++ back-end compiler minor version number = $BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER"

# Use this to get the major and minor version numbers for gfortran (which maps --version to -dumpversion, unlike gcc and g++)
# gfortran --version | head -1 | cut -f2 -d\) | tr -d \  | cut -d\. -f2
# Or Jeremiah suggests the alternative:
# gfortran --version | sed -n '1s/.*) //;1p'
  echo "BACKEND_FORTRAN_COMPILER = $BACKEND_FORTRAN_COMPILER"

# Testing the 4.0.x compiler
# BACKEND_FORTRAN_COMPILER="/usr/apps/gcc/4.0.2/bin/gfortran"
# echo "BACKEND_FORTRAN_COMPILER = $BACKEND_FORTRAN_COMPILER"

# DQ (9/15/2009): Normally we expect a string such as "GNU Fortran 95 (GCC) 4.1.2", but 
# the GNU 4.0.x compiler's gfortran outputs a string such as "GNU Fortran 95 (GCC 4.0.2)"
# So for this case we detect it explicitly and fill in the values directly!
  BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER=`echo|$BACKEND_FORTRAN_COMPILER --version | head -1 | cut -f2 -d\) | tr -d \  | cut -d\. -f1`
  BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER=`echo|$BACKEND_FORTRAN_COMPILER --version | head -1 | cut -f2 -d\) | tr -d \  | cut -d\. -f2`

# Test if we computed the major and minor version numbers correctly...recompute if required
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x; then
    echo "Warning: BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER = $BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER (blank) so this is likely the GNU 4.0.x version (try again to get the version number)"
    BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER=`echo|$BACKEND_FORTRAN_COMPILER --version | head -1 | sed s/"GNU Fortran 95 (GCC "//g | cut -f1 -d \) | cut -d\. -f1`
    BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER=`echo|$BACKEND_FORTRAN_COMPILER --version | head -1 | sed s/"GNU Fortran 95 (GCC "//g | cut -f1 -d \) | cut -d\. -f2`
  fi

# echo "back-end compiler for generated translators to use will be: $BACKEND_CXX_COMPILER"
  echo "     Fortran back-end compiler major version number = $BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER"
  echo "     Fortran back-end compiler minor version number = $BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER"

# Test that we have correctly evaluated the major and minor versions numbers...
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x; then
    echo "Warning: Could not compute the MAJOR version number of $BACKEND_FORTRAN_COMPILER"
  # exit 1
  fi

  if test x$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER == x; then
    echo "Warning: Could not compute the MINOR version number of $BACKEND_FORTRAN_COMPILER"
  # exit 1
  fi

# DQ (9/16/2009): GNU gfortran 4.0 has special problems so we avoid some tests where it fails.
  gfortran_version_4_0=no
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test x$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER == x0; then
        echo "Note: we have identified version 4.0 of gfortran!"
        gfortran_version_4_0=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GFORTRAN_VERSION_4_0, [test "x$gfortran_version_4_0" = "xyes"])

# DQ (9/17/2009): GNU gfortran 4.1 has special problems so we avoid some tests where it fails.
  gfortran_version_4_1=no
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test x$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER == x1; then
        echo "Note: we have identified version 4.1 of gfortran!"
        gfortran_version_4_1=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GFORTRAN_VERSION_4_1, [test "x$gfortran_version_4_1" = "xyes"])

# DQ (2/13/2011): GNU gfortran 4.2 is a gnu configuration where I want to have test2010_161.f90 be tested.
# It has previously demonstrated a statistical failure on 4.1.2 and 4.3.2 (running it on 4.2 machines
# is an incremental step to getting it into more uniform testing, since I can't get it to fail locally).
# It also passes valgrind just fine, so this is a bit of a mystery at present.
  gfortran_version_4_2=no
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test x$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER == x2; then
        echo "Note: we have identified version 4.2 of gfortran!"
        gfortran_version_4_2=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GFORTRAN_VERSION_4_2, [test "x$gfortran_version_4_2" = "xyes"])

# DQ (2/1/2011): GNU gfortran 4.4 has special problems so we avoid some tests where it fails.
  gfortran_version_4_4=no
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test x$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER == x4; then
        echo "Note: we have identified version 4.4 of gfortran!"
        gfortran_version_4_4=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GFORTRAN_VERSION_4_4, [test "x$gfortran_version_4_4" = "xyes"])

# DQ (4/10/2011): GNU gfortran 4.5 has special problems so we avoid some tests where it fails.
  gfortran_version_4_5=no
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test x$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER == x5; then
        echo "Note: we have identified version 4.5 of gfortran!"
        gfortran_version_4_5=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GFORTRAN_VERSION_4_5, [test "x$gfortran_version_4_5" = "xyes"])

# DQ (4/10/2011): GNU gfortran 4.6 has special problems so we avoid some tests where it fails.
  gfortran_version_4_6=no
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test x$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER == x6; then
        echo "Note: we have identified version 4.6 of gfortran!"
        gfortran_version_4_6=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GFORTRAN_VERSION_4_6, [test "x$gfortran_version_4_6" = "xyes"])

# Phlin (8/23/2012): GNU gfortran 4.5+ has special supports. 
  gfortran_version_later_4_5=no
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test "$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER" -ge "5"; then
        echo "Note: we have identified version 4.5+ of gfortran!"
        gfortran_version_later_4_5=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GFORTRAN_VERSION_LATER_4_5, [test "x$gfortran_version_later_4_5" = "xyes"])

# Phlin (8/23/2012): GNU gfortran 4.4+ has special supports. 
  gfortran_version_later_4_4=no
  if test x$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test "$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER" -ge "4"; then
        echo "Note: we have identified version 4.4+ of gfortran!"
        gfortran_version_later_4_4=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GFORTRAN_VERSION_LATER_4_4, [test "x$gfortran_version_later_4_4" = "xyes"])

# DQ (8/15/2014): GNU GCC 4.4 starts more complex Microsoft C++ support.
  gcc_version_later_4_4=no
  if test x$BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test "$BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER" -ge "4"; then
        echo "Note: we have identified version 4.4+ of gcc!"
        gcc_version_later_4_4=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GCC_VERSION_LATER_4_4, [test "x$gcc_version_later_4_4" = "xyes"])

# DQ (8/15/2014): Added for more complete support of GNU GCC.
  gcc_version_later_4_5=no
  if test x$BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test "$BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER" -ge "5"; then
        echo "Note: we have identified version 4.5+ of gcc!"
        gcc_version_later_4_5=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GCC_VERSION_LATER_4_5, [test "x$gcc_version_later_4_5" = "xyes"])

# Phlin (8/22/2012): GNU GCC 4.6 starts AVX support.
  gcc_version_later_4_6=no
  if test x$BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test "$BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER" -ge "6"; then
        echo "Note: we have identified version 4.6+ of gcc!"
        gcc_version_later_4_6=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GCC_VERSION_LATER_4_6, [test "x$gcc_version_later_4_6" = "xyes"])

# DQ (7/28/2014): GNU GCC 4.8 starts C11 support.
  gcc_version_later_4_8=no
  if test x$BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test "$BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER" -ge "8"; then
        echo "Note: we have identified version 4.8+ of gcc!"
        gcc_version_later_4_8=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GCC_VERSION_LATER_4_8, [test "x$gcc_version_later_4_8" = "xyes"])

# DQ (8/15/2014): Added for more complete support of GNU GCC.
  gcc_version_later_4_7=no
  if test x$BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test "$BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER" -ge "7"; then
        echo "Note: we have identified version 4.7+ of gcc!"
        gcc_version_later_4_7=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GCC_VERSION_LATER_4_7, [test "x$gcc_version_later_4_7" = "xyes"])

# DQ (7/28/2014): GNU GCC 4.9 adds more C11 support (we need this to control what tests are run).
  gcc_version_later_4_9=no
  if test x$BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER == x4; then
     if test "$BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER" -ge "9"; then
        echo "Note: we have identified version 4.9+ of gcc!"
        gcc_version_later_4_9=yes
     fi
  fi
  AM_CONDITIONAL(ROSE_USING_GCC_VERSION_LATER_4_9, [test "x$gcc_version_later_4_9" = "xyes"])

# echo "Exiting after test of backend version number support ..."
# exit 1

# We use the name of the backend C++ compiler to generate a compiler name that will be used
# elsewhere (CXX_ID might be a better name to use, instead we use basename to strip the path).
# compilerName=`basename $BACKEND_CXX_COMPILER`
  COMPILER_NAME=`basename $BACKEND_CXX_COMPILER`
# echo "default back-end compiler for generated preprocessors will be: $BACKEND_CXX_COMPILER"
# export BACKEND_CXX_COMPILER
# AC_DEFINE_UNQUOTED([CXX_COMPILER_NAME],"$BACKEND_CXX_COMPILER",[Name of backend C++ compiler.])
# echo "default back-end compiler for generated preprocessors will be: $BACKEND_CXX_COMPILER compiler name = $compilerName"

# DQ (1/15/2007): This does not work, it seems that BACKEND_C_COMPILER must be a simple name not a compound name using an option!
# Specify any option that specific backend compiler require (e.g. -restrict)
  case $COMPILER_NAME in
    gcc*|g++*)
      ;;
    icc|icpc)
    # BACKEND_C_COMPILER="$BACKEND_C_COMPILER -restrict"
    # BACKEND_CXX_COMPILER="$BACKEND_CXX_COMPILER -restrict"
      ;;
    "KCC --c" | mpKCC|KCC)
      ;;
    cc|CC)
    ;;
  esac

  echo "After adding (required) options BACKEND_C_COMPILER   = $BACKEND_C_COMPILER"
  echo "After adding (required) options BACKEND_CXX_COMPILER = $BACKEND_CXX_COMPILER"

  echo "default back-end compiler for generated preprocessors will be: $BACKEND_CXX_COMPILER compiler name = $COMPILER_NAME"

# export BACKEND_CXX_COMPILER
# AC_DEFINE_UNQUOTED([CXX_COMPILER_NAME],"$BACKEND_CXX_COMPILER",[Name of backend C++ compiler.])

# This will be used to select options based on which backend compiler is used (g++, xlC, icc, etc.)
# we can't use the basename of the compiler to execute because it might be link using a non-standard name (e.g. mpig++-3.4.1)
  export COMPILER_NAME
  AC_DEFINE_UNQUOTED([BACKEND_CXX_COMPILER_NAME_WITHOUT_PATH],"$COMPILER_NAME",[Name of backend C++ compiler excluding path (used to select code generation options).])

# This will be called to execute the backend compiler (for C++)
  export BACKEND_CXX_COMPILER
  AC_DEFINE_UNQUOTED([BACKEND_CXX_COMPILER_NAME_WITH_PATH],"$BACKEND_CXX_COMPILER",[Name of backend C++ compiler including path (may or may not explicit include path; used to call backend).])

# This will be called to execute the backend compiler (for C)
  export BACKEND_C_COMPILER
  AC_DEFINE_UNQUOTED([BACKEND_C_COMPILER_NAME_WITH_PATH],"$BACKEND_C_COMPILER",[Name of backend C compiler including path (may or may not explicit include path; used to call backend).])

# This will be called to execute the backend compiler (for Fortran)
  export BACKEND_FORTRAN_COMPILER
  AC_DEFINE_UNQUOTED([BACKEND_FORTRAN_COMPILER_NAME_WITH_PATH],"$BACKEND_FORTRAN_COMPILER",[Name of backend Fortran compiler including path (may or may not explicit include path; used to call backend).])

# DQ (4/2/2011): Added some support for the name of the backend Java compiler.
# This will be called to execute the backend compiler (for Java)
  export BACKEND_JAVA_COMPILER
  AC_DEFINE_UNQUOTED([BACKEND_JAVA_COMPILER_NAME_WITH_PATH],"$BACKEND_JAVA_COMPILER",[Name of backend Java compiler including path (may or may not explicit include path; used to call backend).])

# These are useful in handling differences between different versions of the backend compiler
# we assume that the C and C++ compiler version number match and only record version information 
# for the backend C++ compiler. (for example, this helps us generated different code for 
# g++ 3.3.x and 3.4.x backend compilers).
  export BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER
  AC_DEFINE_UNQUOTED([BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER],$BACKEND_CXX_COMPILER_MAJOR_VERSION_NUMBER,[Major version number of backend C++ compiler.])
  export BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER
  AC_DEFINE_UNQUOTED([BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER],$BACKEND_CXX_COMPILER_MINOR_VERSION_NUMBER,[Minor version number of backend C++ compiler.])

  export BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER
  AC_DEFINE_UNQUOTED([BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER],$BACKEND_FORTRAN_COMPILER_MAJOR_VERSION_NUMBER,[Major version number of backend Fortran compiler.])
  export BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER
  AC_DEFINE_UNQUOTED([BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER],$BACKEND_FORTRAN_COMPILER_MINOR_VERSION_NUMBER,[Minor version number of backend Fortran compiler.])

###################################################################################################
# Backend Compiler Support
# TOO (2/15/2011): TODO: create separate macro call to check cross-compilation
    IS_ALTERNATE_BACKEND_C_CROSS_COMPILER=false
    if test "x$with_alternate_backend_C_compiler" != x; then
      AC_LANG_PUSH([C])
      save_cc=$CC
      CC="$with_alternate_backend_C_compiler"
      echo "Checking if the backend C compiler $CC is cross-compiling..."
      echo "Running a simple program with the backend C compiler: $CC..."
      AC_RUN_IFELSE([
        AC_LANG_SOURCE([[
          int main (int argc, char* argv[]) {
            return 0;
          }
        ]])
       ],
       [echo "Successfully ran a simple program with the backend C compiler: $CC"],
       [echo "FAILED to run a simple program with the backend C compiler"
        IS_ALTERNATE_BACKEND_C_CROSS_COMPILER=true
       ], [])
      CC=$save_cc
      AC_LANG_POP([C])
    fi
echo "=> cross-compiling... $IS_ALTERNATE_BACKEND_C_CROSS_COMPILER"
AM_CONDITIONAL(ALTERNATE_BACKEND_C_CROSS_COMPILER, ["$IS_ALTERNATE_BACKEND_C_CROSS_COMPILER"])
AM_CONDITIONAL(ROSE_USING_ALTERNATE_BACKEND_CXX_COMPILER, [test "x$with_alternate_backend_Cxx_compiler" != "x"])
AM_CONDITIONAL(ROSE_USING_ALTERNATE_BACKEND_C_COMPILER, [test "x$with_alternate_backend_C_compiler" != "x"])


# TOO (2/14/2011): Enforce backend C/C++ compilers to be the same version
BACKEND_CXX_COMPILER_VERSION="`echo|$BACKEND_CXX_COMPILER -dumpversion`"
BACKEND_C_COMPILER_VERSION="`echo|$BACKEND_C_COMPILER -dumpversion`"
BACKEND_C_COMPILER_NAME="`basename $BACKEND_C_COMPILER`"
if test "x$BACKEND_CXX_COMPILER_VERSION" != "x$BACKEND_C_COMPILER_VERSION"; then
  echo "Error: the backend C++ and C compilers must be the same!"
  exit 1;
fi
# TOO (2/16/2011): Detect Thrifty (GCC 3.4.4) compiler
AM_CONDITIONAL(USING_GCC_3_4_4_BACKEND_COMPILER, [test "x$BACKEND_C_COMPILER_VERSION" == "x3.4.4"])

# DQ (4/16/2011): Detect the GNU 4.0.4 compilers (used to turn off hanging Haskell support 
# in projects/haskellport/tests/simplify/simplifyTest.C).  This happend twice on tux324
# this must be looked into since it is not clear how this happened and passed commit tests.
AM_CONDITIONAL(USING_GCC_4_0_4_BACKEND_COMPILER, [test "x$BACKEND_C_COMPILER_VERSION" == "x4.0.4"])

# TOO (2/17/2011): Detect Tensilica Xtensa C/C++ compiler
if test "x$BACKEND_C_COMPILER_NAME" == "xxt-xcc"; then
  AM_CONDITIONAL(USING_XTENSA_BACKEND_COMPILER, true)
#  AC_DEFINE_UNQUOTED([USING_XTENSA_BACKEND_COMPILER],true,[Tensilica's Xtensa compiler.])
  echo "The backend C/C++ compilers have been identified as Tensilica Xtensa compilers"
else
  AM_CONDITIONAL(USING_XTENSA_BACKEND_COMPILER, false)
fi


# AC_LANG_PUSH(C)
echo "build input file for backend compiler"
echo 'int main(int argc, char** argv){ asm("nop");}' > conftest_asm.c
cat conftest_asm.c

echo "run backend compiler on input file: $BACKEND_C_COMPILER -std=c99 -Werror=implicit-function-declaration -c conftest_asm.c"
# Handle the 3 cases of true false and cross-compilation
# AC_TRY_RUN(`$BACKEND_C_COMPILER -c conftest_asm.c`,asm_ok=yes,asm_ok=no,asm_ok=no)
# AC_TRY_RUN(conftest_asm.c,asm_ok=yes,asm_ok=no,asm_ok=no)
# ac_compiler_gnu="$BACKEND_C_COMPILER -Werror=implicit-function-declaration"
# AC_TRY_RUN([int main(){ __asm__("nop");}],asm_ok=yes,asm_ok=no,asm_ok=no)
# AC_TRY_COMPILE([],[asm("nop");],asm_ok=yes,asm_ok=no)
# asm_ok=eval($BACKEND_C_COMPILER -Werror=implicit-function-declaration -c conftest_asm.c)
# if test `$BACKEND_C_COMPILER -std=c99 -Werror=implicit-function-declaration -c conftest_asm.c`; then
$BACKEND_C_COMPILER -std=c99 -Werror=implicit-function-declaration -c conftest_asm.c
status=$?
echo "status = $status"
if test "x$status" = "x0"; then
# zero exit code
echo "false case: set asm_ok=yes"
asm_ok=yes
AC_DEFINE([BACKEND_C_COMPILER_SUPPORTS_ASM],[1],[The backend C compiler might not support asm and might require __asm__ instead (e.g. GNU gcc).])
else
# non-zero exit code
echo "true case: set asm_ok=no"
asm_ok=no
fi

AC_MSG_CHECKING(does the backend C compiler ($BACKEND_C_COMPILER) support asm statements)
AC_MSG_RESULT($asm_ok)
# AC_DEFINE_UNQUOTED([BACKEND_C_COMPILER_SUPPORTS_ASM],test "x$asm_ok" = "xyes",[The backend C compiler might not support asm and might require __asm__ instead (e.g. GNU gcc).])
# AC_DEFINE([BACKEND_C_COMPILER_SUPPORTS_ASM],[test "x$asm_ok" = "xyes"],[The backend C compiler might not support asm and might require __asm__ instead (e.g. GNU gcc).])
# AC_LANG_POP(C)

# echo "exiting as a test of asm!"
# exit 1

# AC_LANG_PUSH(C)
echo "build input file for backend compiler"
echo 'int main(int argc, char** argv){ __asm__("nop");}' > conftest_undescore_asm.c
cat conftest_undescore_asm.c

echo "run backend compiler on input file: $BACKEND_C_COMPILER -std=c99 -Werror=implicit-function-declaration -c conftest_undescore_asm.c"
# Handle the 3 cases of true false and cross-compilation
# AC_TRY_RUN(`$BACKEND_C_COMPILER -c conftest_undescore_asm.c`,underscore_asm_ok=yes,underscore_asm_ok=no,underscore_asm_ok=no)
# ac_compiler_gnu="$BACKEND_C_COMPILER -Werror=implicit-function-declaration"
# AC_TRY_COMPILE([],[int main(int,char**){ __asm__("nop");}],underscore_asm_ok=yes,underscore_asm_ok=no)
# AC_TRY_COMPILE([],[__asm__("nop");],underscore_asm_ok=yes,underscore_asm_ok=no)
# if test `$BACKEND_C_COMPILER -std=c99 -Werror=implicit-function-declaration -c conftest_undescore_asm.c`; then
$BACKEND_C_COMPILER -std=c99 -Werror=implicit-function-declaration -c conftest_undescore_asm.c
status=$?
echo "status = $status"
if test "x$status" = "x0"; then
# zero exit code
echo "false case: set underscore_asm_ok=yes"
underscore_asm_ok=yes
AC_DEFINE([BACKEND_C_COMPILER_SUPPORTS_UNDESCORE_ASM],[1],[The backend C compiler might not support asm and might require __asm__ instead (e.g. GNU gcc).])
else
# non-zero exit code
echo "true case: set underscore_asm_ok=no"
underscore_asm_ok=no
fi

AC_MSG_CHECKING(does the backend C compiler ($BACKEND_C_COMPILER) support __asm__ statements)
AC_MSG_RESULT($underscore_asm_ok)
# AC_DEFINE_UNQUOTED([BACKEND_C_COMPILER_SUPPORTS_UNDESCORE_ASM],test "x$underscore_asm_ok" = "xyes",[The backend C compiler might not support asm and might require __asm__ instead (e.g. GNU gcc).])
# AC_DEFINE([BACKEND_C_COMPILER_SUPPORTS_UNDESCORE_ASM],[test "x$underscore_asm_ok" = "xyes"],[The backend C compiler might not support asm and might require __asm__ instead (e.g. GNU gcc).])
# AC_LANG_POP(C)



# Also need to test: asm(".symver ff_av_gettime,av_gettime@LIBAVFORMAT_54") which fails better when used with 4.2.4 compiler.
# This test fails for both 4.4 and 4.2 compilers where as the tests above pass for 4.2 and fails for 4.4 compilers.
# The error message is also different for this example using a longer string than thge example above.
# AC_LANG_PUSH(C)
echo "build input file for backend compiler"
echo 'asm(".symver ff_av_gettime,av_gettime@LIBAVFORMAT_54");' > conftest_long_string_asm.c
cat conftest_long_string_asm.c

echo "run backend compiler on input file: $BACKEND_C_COMPILER -std=c99 -Werror=implicit-function-declaration -c conftest_long_string_asm.c"
# Handle the 3 cases of true false and cross-compilation
# AC_TRY_RUN(`$BACKEND_C_COMPILER -c conftest_asm.c`,asm_ok=yes,asm_ok=no,asm_ok=no)
# AC_TRY_RUN(conftest_asm.c,asm_ok=yes,asm_ok=no,asm_ok=no)
# ac_compiler_gnu="$BACKEND_C_COMPILER -Werror=implicit-function-declaration"
# AC_TRY_RUN([int main(){ __asm__("nop");}],asm_ok=yes,asm_ok=no,asm_ok=no)
# AC_TRY_COMPILE([],[asm("nop");],asm_ok=yes,asm_ok=no)
# asm_ok=eval($BACKEND_C_COMPILER -Werror=implicit-function-declaration -c conftest_asm.c)
# if test `$BACKEND_C_COMPILER -std=c99 -Werror=implicit-function-declaration -c conftest_asm.c`; then
$BACKEND_C_COMPILER -std=c99 -c conftest_long_string_asm.c
status=$?
echo "status = $status"
if test "x$status" = "x0"; then
# zero exit code
echo "false case: set long_string_asm_ok=yes"
long_string_asm_ok=yes
AC_DEFINE([BACKEND_C_COMPILER_SUPPORTS_LONG_STRING_ASM],[1],[The backend C compiler might not support asm and might require __asm__ instead (e.g. GNU gcc).])
else
# non-zero exit code
echo "true case: set long_string_asm_ok=no"
long_string_asm_ok=no
fi

AC_MSG_CHECKING(does the backend C compiler ($BACKEND_C_COMPILER) support asm statements)
AC_MSG_RESULT($long_string_asm_ok)
# AC_DEFINE_UNQUOTED([BACKEND_C_COMPILER_SUPPORTS_ASM],test "x$asm_ok" = "xyes",[The backend C compiler might not support asm and might require __asm__ instead (e.g. GNU gcc).])
# AC_DEFINE([BACKEND_C_COMPILER_SUPPORTS_ASM],[test "x$asm_ok" = "xyes"],[The backend C compiler might not support asm and might require __asm__ instead (e.g. GNU gcc).])
# AC_LANG_POP(C)

# echo "exiting as a test of asm!"
# exit 1


# echo "exiting as a test of __asm__!"
# exit 1

###################################################################################################
])

