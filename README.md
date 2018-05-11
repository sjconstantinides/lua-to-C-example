# lua-to-C-example
How to make C calls from lua for Aerospike
This directory holds a test for using Lua to call a module written in C.
Please ensure that gcc, wget are installed. At the time of this writing (May, 2018) lua version 5.1.x was used, and should be used to maintain consistency. 

The high level outline is simple:
- Create C code using the lua structs that will be passed back and forth
- Generate a .so file from the C code to be used at runtime
- Create the lua code to call the C code
- Import/register the .so file into the Aerospike server
- Import/register the lua code into the Aerospike server

This example contains:
- The power.c file that includes the needed lua structures and function calls to register the C functions within lua. 

- The use_power.lua file used that calls the C code

- The build.sh file used to build and run the code and test case

- The test.lua file used to test the lua -> C calling connection via command line


Things to know:
The .so produced needs to be reachable from the calling lua. This needs to be brought into the Aerospike server process space for lua to access it. This is accomplished by registering the .so as a module within Aerospike using the AQL “register module” command. This needs to be imported prior to registering the .lua file. 

Also, if the C code is changed and the .so recreated, the .lua module needs to be removed from the Aerospike server process space using the AQL “remove module” command and then re-inserted after the .so has been registered. 

There is no need to restart the Aerospike server in between any of these steps.

Your lua script needs to know about and have access to the C code contained within the .so. This is accomplished through importing/registering the .so code and by the use of the “require(<name of the .so file, “power” in our example>)” AND by the luaL_openlib() function within the C code.

Arguments and parameters passed between lua and C are done via the stack. So in the C code you will need to grab values off of the stack using the lua_tonumber() function or other defined lua stack functions. Multiple values can be returned to lua also via the stack using the lua_pushnumber() function or other defined stack functions. 

The return statement from the C code indicates how many values were put onto the stack so lua can unwind them. 



To run the example, run the commands:

> sudo ./build.sh
> aql -c "execute use_power.call_go(123) on test where pk='x'"

SUCCESS: 15129

To run the test.lua (verify the lua -> C) works:
lua test.lua


The build.sh will:
--  build the power.so
--  register the power.so and use_power.lua files with the server.

The aql call will:
--  initiate a call to use_power.call_go with 123 as its argument.
    use_power.call_go imports power.so to calculate the square of 123.

