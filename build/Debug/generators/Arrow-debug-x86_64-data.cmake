########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND arrow_COMPONENT_NAMES Arrow::arrow_static Parquet::parquet_static)
list(REMOVE_DUPLICATES arrow_COMPONENT_NAMES)
if(DEFINED arrow_FIND_DEPENDENCY_NAMES)
  list(APPEND arrow_FIND_DEPENDENCY_NAMES Thrift mimalloc Boost ZLIB)
  list(REMOVE_DUPLICATES arrow_FIND_DEPENDENCY_NAMES)
else()
  set(arrow_FIND_DEPENDENCY_NAMES Thrift mimalloc Boost ZLIB)
endif()
set(Thrift_FIND_MODE "NO_MODULE")
set(mimalloc_FIND_MODE "NO_MODULE")
set(Boost_FIND_MODE "NO_MODULE")
set(ZLIB_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(arrow_PACKAGE_FOLDER_DEBUG "/root/.conan2/p/b/arrow455c1212ad657/p")
set(arrow_BUILD_MODULES_PATHS_DEBUG )


set(arrow_INCLUDE_DIRS_DEBUG "${arrow_PACKAGE_FOLDER_DEBUG}/include")
set(arrow_RES_DIRS_DEBUG )
set(arrow_DEFINITIONS_DEBUG "-DPARQUET_STATIC"
			"-DARROW_STATIC")
set(arrow_SHARED_LINK_FLAGS_DEBUG )
set(arrow_EXE_LINK_FLAGS_DEBUG )
set(arrow_OBJECTS_DEBUG )
set(arrow_COMPILE_DEFINITIONS_DEBUG "PARQUET_STATIC"
			"ARROW_STATIC")
set(arrow_COMPILE_OPTIONS_C_DEBUG )
set(arrow_COMPILE_OPTIONS_CXX_DEBUG )
set(arrow_LIB_DIRS_DEBUG "${arrow_PACKAGE_FOLDER_DEBUG}/lib")
set(arrow_BIN_DIRS_DEBUG )
set(arrow_LIBRARY_TYPE_DEBUG STATIC)
set(arrow_IS_HOST_WINDOWS_DEBUG 0)
set(arrow_LIBS_DEBUG parquet arrow)
set(arrow_SYSTEM_LIBS_DEBUG pthread m dl rt)
set(arrow_FRAMEWORK_DIRS_DEBUG )
set(arrow_FRAMEWORKS_DEBUG )
set(arrow_BUILD_DIRS_DEBUG )
set(arrow_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(arrow_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${arrow_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${arrow_COMPILE_OPTIONS_C_DEBUG}>")
set(arrow_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${arrow_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${arrow_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${arrow_EXE_LINK_FLAGS_DEBUG}>")


set(arrow_COMPONENTS_DEBUG Arrow::arrow_static Parquet::parquet_static)
########### COMPONENT Parquet::parquet_static VARIABLES ############################################

set(arrow_Parquet_parquet_static_INCLUDE_DIRS_DEBUG "${arrow_PACKAGE_FOLDER_DEBUG}/include")
set(arrow_Parquet_parquet_static_LIB_DIRS_DEBUG "${arrow_PACKAGE_FOLDER_DEBUG}/lib")
set(arrow_Parquet_parquet_static_BIN_DIRS_DEBUG )
set(arrow_Parquet_parquet_static_LIBRARY_TYPE_DEBUG STATIC)
set(arrow_Parquet_parquet_static_IS_HOST_WINDOWS_DEBUG 0)
set(arrow_Parquet_parquet_static_RES_DIRS_DEBUG )
set(arrow_Parquet_parquet_static_DEFINITIONS_DEBUG "-DPARQUET_STATIC")
set(arrow_Parquet_parquet_static_OBJECTS_DEBUG )
set(arrow_Parquet_parquet_static_COMPILE_DEFINITIONS_DEBUG "PARQUET_STATIC")
set(arrow_Parquet_parquet_static_COMPILE_OPTIONS_C_DEBUG "")
set(arrow_Parquet_parquet_static_COMPILE_OPTIONS_CXX_DEBUG "")
set(arrow_Parquet_parquet_static_LIBS_DEBUG parquet)
set(arrow_Parquet_parquet_static_SYSTEM_LIBS_DEBUG )
set(arrow_Parquet_parquet_static_FRAMEWORK_DIRS_DEBUG )
set(arrow_Parquet_parquet_static_FRAMEWORKS_DEBUG )
set(arrow_Parquet_parquet_static_DEPENDENCIES_DEBUG Arrow::arrow_static)
set(arrow_Parquet_parquet_static_SHARED_LINK_FLAGS_DEBUG )
set(arrow_Parquet_parquet_static_EXE_LINK_FLAGS_DEBUG )
set(arrow_Parquet_parquet_static_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(arrow_Parquet_parquet_static_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${arrow_Parquet_parquet_static_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${arrow_Parquet_parquet_static_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${arrow_Parquet_parquet_static_EXE_LINK_FLAGS_DEBUG}>
)
set(arrow_Parquet_parquet_static_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${arrow_Parquet_parquet_static_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${arrow_Parquet_parquet_static_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT Arrow::arrow_static VARIABLES ############################################

set(arrow_Arrow_arrow_static_INCLUDE_DIRS_DEBUG "${arrow_PACKAGE_FOLDER_DEBUG}/include")
set(arrow_Arrow_arrow_static_LIB_DIRS_DEBUG "${arrow_PACKAGE_FOLDER_DEBUG}/lib")
set(arrow_Arrow_arrow_static_BIN_DIRS_DEBUG )
set(arrow_Arrow_arrow_static_LIBRARY_TYPE_DEBUG STATIC)
set(arrow_Arrow_arrow_static_IS_HOST_WINDOWS_DEBUG 0)
set(arrow_Arrow_arrow_static_RES_DIRS_DEBUG )
set(arrow_Arrow_arrow_static_DEFINITIONS_DEBUG "-DARROW_STATIC")
set(arrow_Arrow_arrow_static_OBJECTS_DEBUG )
set(arrow_Arrow_arrow_static_COMPILE_DEFINITIONS_DEBUG "ARROW_STATIC")
set(arrow_Arrow_arrow_static_COMPILE_OPTIONS_C_DEBUG "")
set(arrow_Arrow_arrow_static_COMPILE_OPTIONS_CXX_DEBUG "")
set(arrow_Arrow_arrow_static_LIBS_DEBUG arrow)
set(arrow_Arrow_arrow_static_SYSTEM_LIBS_DEBUG pthread m dl rt)
set(arrow_Arrow_arrow_static_FRAMEWORK_DIRS_DEBUG )
set(arrow_Arrow_arrow_static_FRAMEWORKS_DEBUG )
set(arrow_Arrow_arrow_static_DEPENDENCIES_DEBUG boost::boost mimalloc-static thrift::thrift-conan-do-not-use ZLIB::ZLIB)
set(arrow_Arrow_arrow_static_SHARED_LINK_FLAGS_DEBUG )
set(arrow_Arrow_arrow_static_EXE_LINK_FLAGS_DEBUG )
set(arrow_Arrow_arrow_static_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(arrow_Arrow_arrow_static_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${arrow_Arrow_arrow_static_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${arrow_Arrow_arrow_static_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${arrow_Arrow_arrow_static_EXE_LINK_FLAGS_DEBUG}>
)
set(arrow_Arrow_arrow_static_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${arrow_Arrow_arrow_static_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${arrow_Arrow_arrow_static_COMPILE_OPTIONS_C_DEBUG}>")