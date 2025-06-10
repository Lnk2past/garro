########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(mimalloc_COMPONENT_NAMES "")
if(DEFINED mimalloc_FIND_DEPENDENCY_NAMES)
  list(APPEND mimalloc_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES mimalloc_FIND_DEPENDENCY_NAMES)
else()
  set(mimalloc_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(mimalloc_PACKAGE_FOLDER_DEBUG "/root/.conan2/p/b/mimalfdbb5ff98ae30/p")
set(mimalloc_BUILD_MODULES_PATHS_DEBUG )


set(mimalloc_INCLUDE_DIRS_DEBUG )
set(mimalloc_RES_DIRS_DEBUG )
set(mimalloc_DEFINITIONS_DEBUG )
set(mimalloc_SHARED_LINK_FLAGS_DEBUG )
set(mimalloc_EXE_LINK_FLAGS_DEBUG )
set(mimalloc_OBJECTS_DEBUG )
set(mimalloc_COMPILE_DEFINITIONS_DEBUG )
set(mimalloc_COMPILE_OPTIONS_C_DEBUG )
set(mimalloc_COMPILE_OPTIONS_CXX_DEBUG )
set(mimalloc_LIB_DIRS_DEBUG "${mimalloc_PACKAGE_FOLDER_DEBUG}/lib")
set(mimalloc_BIN_DIRS_DEBUG )
set(mimalloc_LIBRARY_TYPE_DEBUG STATIC)
set(mimalloc_IS_HOST_WINDOWS_DEBUG 0)
set(mimalloc_LIBS_DEBUG mimalloc-debug)
set(mimalloc_SYSTEM_LIBS_DEBUG pthread rt)
set(mimalloc_FRAMEWORK_DIRS_DEBUG )
set(mimalloc_FRAMEWORKS_DEBUG )
set(mimalloc_BUILD_DIRS_DEBUG )
set(mimalloc_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(mimalloc_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${mimalloc_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${mimalloc_COMPILE_OPTIONS_C_DEBUG}>")
set(mimalloc_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mimalloc_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mimalloc_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mimalloc_EXE_LINK_FLAGS_DEBUG}>")


set(mimalloc_COMPONENTS_DEBUG )