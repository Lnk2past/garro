########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND thrift_COMPONENT_NAMES thrift::thrift thriftz::thriftz thriftnb::thriftnb)
list(REMOVE_DUPLICATES thrift_COMPONENT_NAMES)
if(DEFINED thrift_FIND_DEPENDENCY_NAMES)
  list(APPEND thrift_FIND_DEPENDENCY_NAMES Libevent OpenSSL Boost ZLIB)
  list(REMOVE_DUPLICATES thrift_FIND_DEPENDENCY_NAMES)
else()
  set(thrift_FIND_DEPENDENCY_NAMES Libevent OpenSSL Boost ZLIB)
endif()
set(Libevent_FIND_MODE "NO_MODULE")
set(OpenSSL_FIND_MODE "NO_MODULE")
set(Boost_FIND_MODE "NO_MODULE")
set(ZLIB_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(thrift_PACKAGE_FOLDER_DEBUG "/root/.conan2/p/b/thrifc35af07e9aa80/p")
set(thrift_BUILD_MODULES_PATHS_DEBUG )


set(thrift_INCLUDE_DIRS_DEBUG )
set(thrift_RES_DIRS_DEBUG )
set(thrift_DEFINITIONS_DEBUG )
set(thrift_SHARED_LINK_FLAGS_DEBUG )
set(thrift_EXE_LINK_FLAGS_DEBUG )
set(thrift_OBJECTS_DEBUG )
set(thrift_COMPILE_DEFINITIONS_DEBUG )
set(thrift_COMPILE_OPTIONS_C_DEBUG )
set(thrift_COMPILE_OPTIONS_CXX_DEBUG )
set(thrift_LIB_DIRS_DEBUG "${thrift_PACKAGE_FOLDER_DEBUG}/lib")
set(thrift_BIN_DIRS_DEBUG )
set(thrift_LIBRARY_TYPE_DEBUG STATIC)
set(thrift_IS_HOST_WINDOWS_DEBUG 0)
set(thrift_LIBS_DEBUG thriftnbd thriftzd thriftd)
set(thrift_SYSTEM_LIBS_DEBUG m pthread)
set(thrift_FRAMEWORK_DIRS_DEBUG )
set(thrift_FRAMEWORKS_DEBUG )
set(thrift_BUILD_DIRS_DEBUG )
set(thrift_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(thrift_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${thrift_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${thrift_COMPILE_OPTIONS_C_DEBUG}>")
set(thrift_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${thrift_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${thrift_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${thrift_EXE_LINK_FLAGS_DEBUG}>")


set(thrift_COMPONENTS_DEBUG thrift::thrift thriftz::thriftz thriftnb::thriftnb)
########### COMPONENT thriftnb::thriftnb VARIABLES ############################################

set(thrift_thriftnb_thriftnb_INCLUDE_DIRS_DEBUG )
set(thrift_thriftnb_thriftnb_LIB_DIRS_DEBUG "${thrift_PACKAGE_FOLDER_DEBUG}/lib")
set(thrift_thriftnb_thriftnb_BIN_DIRS_DEBUG )
set(thrift_thriftnb_thriftnb_LIBRARY_TYPE_DEBUG STATIC)
set(thrift_thriftnb_thriftnb_IS_HOST_WINDOWS_DEBUG 0)
set(thrift_thriftnb_thriftnb_RES_DIRS_DEBUG )
set(thrift_thriftnb_thriftnb_DEFINITIONS_DEBUG )
set(thrift_thriftnb_thriftnb_OBJECTS_DEBUG )
set(thrift_thriftnb_thriftnb_COMPILE_DEFINITIONS_DEBUG )
set(thrift_thriftnb_thriftnb_COMPILE_OPTIONS_C_DEBUG "")
set(thrift_thriftnb_thriftnb_COMPILE_OPTIONS_CXX_DEBUG "")
set(thrift_thriftnb_thriftnb_LIBS_DEBUG thriftnbd)
set(thrift_thriftnb_thriftnb_SYSTEM_LIBS_DEBUG )
set(thrift_thriftnb_thriftnb_FRAMEWORK_DIRS_DEBUG )
set(thrift_thriftnb_thriftnb_FRAMEWORKS_DEBUG )
set(thrift_thriftnb_thriftnb_DEPENDENCIES_DEBUG thrift::thrift libevent::libevent)
set(thrift_thriftnb_thriftnb_SHARED_LINK_FLAGS_DEBUG )
set(thrift_thriftnb_thriftnb_EXE_LINK_FLAGS_DEBUG )
set(thrift_thriftnb_thriftnb_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(thrift_thriftnb_thriftnb_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${thrift_thriftnb_thriftnb_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${thrift_thriftnb_thriftnb_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${thrift_thriftnb_thriftnb_EXE_LINK_FLAGS_DEBUG}>
)
set(thrift_thriftnb_thriftnb_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${thrift_thriftnb_thriftnb_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${thrift_thriftnb_thriftnb_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT thriftz::thriftz VARIABLES ############################################

set(thrift_thriftz_thriftz_INCLUDE_DIRS_DEBUG )
set(thrift_thriftz_thriftz_LIB_DIRS_DEBUG "${thrift_PACKAGE_FOLDER_DEBUG}/lib")
set(thrift_thriftz_thriftz_BIN_DIRS_DEBUG )
set(thrift_thriftz_thriftz_LIBRARY_TYPE_DEBUG STATIC)
set(thrift_thriftz_thriftz_IS_HOST_WINDOWS_DEBUG 0)
set(thrift_thriftz_thriftz_RES_DIRS_DEBUG )
set(thrift_thriftz_thriftz_DEFINITIONS_DEBUG )
set(thrift_thriftz_thriftz_OBJECTS_DEBUG )
set(thrift_thriftz_thriftz_COMPILE_DEFINITIONS_DEBUG )
set(thrift_thriftz_thriftz_COMPILE_OPTIONS_C_DEBUG "")
set(thrift_thriftz_thriftz_COMPILE_OPTIONS_CXX_DEBUG "")
set(thrift_thriftz_thriftz_LIBS_DEBUG thriftzd)
set(thrift_thriftz_thriftz_SYSTEM_LIBS_DEBUG )
set(thrift_thriftz_thriftz_FRAMEWORK_DIRS_DEBUG )
set(thrift_thriftz_thriftz_FRAMEWORKS_DEBUG )
set(thrift_thriftz_thriftz_DEPENDENCIES_DEBUG thrift::thrift ZLIB::ZLIB)
set(thrift_thriftz_thriftz_SHARED_LINK_FLAGS_DEBUG )
set(thrift_thriftz_thriftz_EXE_LINK_FLAGS_DEBUG )
set(thrift_thriftz_thriftz_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(thrift_thriftz_thriftz_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${thrift_thriftz_thriftz_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${thrift_thriftz_thriftz_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${thrift_thriftz_thriftz_EXE_LINK_FLAGS_DEBUG}>
)
set(thrift_thriftz_thriftz_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${thrift_thriftz_thriftz_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${thrift_thriftz_thriftz_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT thrift::thrift VARIABLES ############################################

set(thrift_thrift_thrift_INCLUDE_DIRS_DEBUG )
set(thrift_thrift_thrift_LIB_DIRS_DEBUG "${thrift_PACKAGE_FOLDER_DEBUG}/lib")
set(thrift_thrift_thrift_BIN_DIRS_DEBUG )
set(thrift_thrift_thrift_LIBRARY_TYPE_DEBUG STATIC)
set(thrift_thrift_thrift_IS_HOST_WINDOWS_DEBUG 0)
set(thrift_thrift_thrift_RES_DIRS_DEBUG )
set(thrift_thrift_thrift_DEFINITIONS_DEBUG )
set(thrift_thrift_thrift_OBJECTS_DEBUG )
set(thrift_thrift_thrift_COMPILE_DEFINITIONS_DEBUG )
set(thrift_thrift_thrift_COMPILE_OPTIONS_C_DEBUG "")
set(thrift_thrift_thrift_COMPILE_OPTIONS_CXX_DEBUG "")
set(thrift_thrift_thrift_LIBS_DEBUG thriftd)
set(thrift_thrift_thrift_SYSTEM_LIBS_DEBUG m pthread)
set(thrift_thrift_thrift_FRAMEWORK_DIRS_DEBUG )
set(thrift_thrift_thrift_FRAMEWORKS_DEBUG )
set(thrift_thrift_thrift_DEPENDENCIES_DEBUG Boost::headers openssl::openssl)
set(thrift_thrift_thrift_SHARED_LINK_FLAGS_DEBUG )
set(thrift_thrift_thrift_EXE_LINK_FLAGS_DEBUG )
set(thrift_thrift_thrift_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(thrift_thrift_thrift_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${thrift_thrift_thrift_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${thrift_thrift_thrift_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${thrift_thrift_thrift_EXE_LINK_FLAGS_DEBUG}>
)
set(thrift_thrift_thrift_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${thrift_thrift_thrift_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${thrift_thrift_thrift_COMPILE_OPTIONS_C_DEBUG}>")