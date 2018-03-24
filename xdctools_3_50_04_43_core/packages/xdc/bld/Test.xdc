/* 
 *  Copyright (c) 2008 Texas Instruments and others.
 *  All rights reserved. This program and the accompanying materials
 *  are made available under the terms of the Eclipse Public License v1.0
 *  which accompanies this distribution, and is available at
 *  http://www.eclipse.org/legal/epl-v10.html
 * 
 *  Contributors:
 *      Texas Instruments - initial implementation
 * 
 * */
/*
 *  ======== Test.xdc ========
 */
package xdc.bld;

/*!
 *  ======== Test ========
 *  Model of a test
 *
 *  Each Test instance represents a pair consisting of an executable and
 *  command line arguments for that executable.  Each pair uniquely
 *  identifies an output sequence (the result of running the executable
 *  with the specified arguments) that can be compared to a known valid
 *  result.  Executables that have non-deterministic execution behavior
 *  (e.g., multi-threaded apps) must ensure that the output is independent
 *  of these variations.
 *
 *  Test instances are created via the `Executable.addTest()` function; 
 *  this ensures that each test is associated with a containing executable.
 *
 *  Test instances do not have unique names. However, each test does have
 *  a "group" name which is optionally specified via `Test.Attrs`.  If the
 *  "group" name is not specified, it defaults to the name of the containing
 *  executable.  To run any group of tests (which may consist of one or more
 *  executable and command-line pairs) it is sufficient to run
 *  the following command:
 *  @p(code)
 *      xdc <test_group_name>.test
 *  @p
 *  where `<test_group_name>` is the name of the test group to run.
 *
 *  Each Executable instance (created via `PackageContents.addExecutable()`)
 *  implicitly adds a test whose "group" name is the name of the executable
 *  and whose arguments are empty (i.e., argc == 0).  Thus, it is possible
 *  to run any executable that can be built using the following command:
 *  @p(code)
 *      xdc <exe_name>.test
 *  @p
 *  where `<exe_name>` is the name of the executable.  Note that if you add a
 *  test to the executable (without specifying a unique `groupName`), the
 *  command above will run the executable more than once; it will run once
 *  for every test associated with the executable.
 */
metaonly module Test {
    /*!
     *  ======== Attrs ========
     *  Optional attributes for a test instance.
     *
     *  Unspecified attributes are "inherited" from `{@link Executable#Attrs}`;
     *  i.e., if one of fields in this structure is unspecified *and* this
     *  field's name matches a field name in `Executable.Attrs`, then
     *  this field's value defaults to the value in specified by
     *  `Executable.Attrs`.  This mechanism makes it possible to establish
     *  executable-specific default values for any of the "inherited"
     *  attributes.
     *
     *  @field(args)        this is a string of arguments (which may contain
     *                      embedded strings) that are passed to the executable
     *                      being run.
     *  @field(execCmd)     this string names the "loader" which is responsible
     *                      for running the executable with the arguments
     *                      specified by the `args` field.  If this field is
     *                      `null` or `undefined`, the command used to run
     *                      the executable is determined by the executable's
     *                      configuration script; see
     *                      `{@link xdc.cfg.Program#execCmd}`.
     *  @field(execArgs)    this is a string of arguments passed to the
     *                      "loader" to control how this loader manages the
     *                      execution of the executable being run.
     *  @field(groupName)   the name of the group of tests of which this test
     *                      is a member.
     *  @field(refOutput)   the name of a "reference" text file that is used
     *                      to validate the output generated by running
     *                      the executable with the specified arguments.  If
     *                      the exit status of the executable is 0 and the
     *                      output of the executable differs from the
     *                      contents of `refOutput`, the test fails.  If this
     *                      comparison fails, the output of the executable is
     *                      saved to a temporary file to allow analysis of the
     *                      failure.  The temporary file's name is:
     *                      "`.tmp,{exeName},{id}`", where `{exeName}` is the
     *                      name of the executable and `{id}` is a test
     *                      id number.
     *
     *                      If `refOutput` is not defined (or set to `null`)
     *                      no comparison is made; only the exit status of the
     *                      executable is used to determine the success or
     *                      failure of the test.
     *  @field(refExitCode) the expected exit status of the executable.
     *
     *                      If `refExitCode` is not defined (or set to `null`)
     *                      an exit status of 0 is assumed.
     *
     *  @see #attrs
     */
    struct Attrs {
        String args;        /*! arguments passed to the exe for this test */
        String execCmd;     /*! exec command for this test */
        String execArgs;    /*! arguments to the exec command itself */
        String groupName;   /*! name of a group of related tests */
        String refOutput;   /*! name of a reference output file */
        String cmpCmd;      /*! command used to compare refOutput */
        int    refExitCode; /*! expected exit code (default = 0) */
    };

instance:
    /*!
     *  ======== create ========
     *  @_nodoc
     *  Instances should only be created via Executable.addTest()
     */
    create();
    
    /*!
     *  ======== attrs ========
     *  Optional attributes for this test instance.
     *
     *  Default values for each of the fields in attrs:
     *  @p(dlist)
     *     - `groupName`
     *          name of the program "containing" this test
     *
     *     - `execCmd`
     *          the first non-`null` value in:
     *              `prog.attrs.test.exec,
     *              xdc.cfg.Program.execCmd`,
     *              `prog.platform.getExecCmd()`.
     *
     *     - execArgs
     *          the first non-`null` value in:
     *              `prog.attrs.test.execArgs`,
     *              "".
     *
     *     - args
     *          the first non-`null` value in:
     *              `prog.attrs.test.args`,
     *              "".
     */
    config Test.Attrs attrs;
}
/*
 *  @(#) xdc.bld; 1, 0, 2,0; 11-8-2017 17:10:16; /db/ztree/library/trees/xdc/xdc-D20.1/src/packages/
 */

