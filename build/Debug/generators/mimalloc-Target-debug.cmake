# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(mimalloc_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(mimalloc_FRAMEWORKS_FOUND_DEBUG "${mimalloc_FRAMEWORKS_DEBUG}" "${mimalloc_FRAMEWORK_DIRS_DEBUG}")

set(mimalloc_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET mimalloc_DEPS_TARGET)
    add_library(mimalloc_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET mimalloc_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${mimalloc_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${mimalloc_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### mimalloc_DEPS_TARGET to all of them
conan_package_library_targets("${mimalloc_LIBS_DEBUG}"    # libraries
                              "${mimalloc_LIB_DIRS_DEBUG}" # package_libdir
                              "${mimalloc_BIN_DIRS_DEBUG}" # package_bindir
                              "${mimalloc_LIBRARY_TYPE_DEBUG}"
                              "${mimalloc_IS_HOST_WINDOWS_DEBUG}"
                              mimalloc_DEPS_TARGET
                              mimalloc_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "mimalloc"    # package_name
                              "${mimalloc_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${mimalloc_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET mimalloc-static
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${mimalloc_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${mimalloc_LIBRARIES_TARGETS}>
                 )

    if("${mimalloc_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET mimalloc-static
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     mimalloc_DEPS_TARGET)
    endif()

    set_property(TARGET mimalloc-static
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${mimalloc_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET mimalloc-static
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${mimalloc_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET mimalloc-static
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${mimalloc_LIB_DIRS_DEBUG}>)
    set_property(TARGET mimalloc-static
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${mimalloc_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET mimalloc-static
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${mimalloc_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(mimalloc_LIBRARIES_DEBUG mimalloc-static)
