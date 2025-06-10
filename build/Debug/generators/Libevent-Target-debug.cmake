# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(libevent_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(libevent_FRAMEWORKS_FOUND_DEBUG "${libevent_FRAMEWORKS_DEBUG}" "${libevent_FRAMEWORK_DIRS_DEBUG}")

set(libevent_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET libevent_DEPS_TARGET)
    add_library(libevent_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET libevent_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${libevent_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${libevent_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:libevent::core;openssl::openssl>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### libevent_DEPS_TARGET to all of them
conan_package_library_targets("${libevent_LIBS_DEBUG}"    # libraries
                              "${libevent_LIB_DIRS_DEBUG}" # package_libdir
                              "${libevent_BIN_DIRS_DEBUG}" # package_bindir
                              "${libevent_LIBRARY_TYPE_DEBUG}"
                              "${libevent_IS_HOST_WINDOWS_DEBUG}"
                              libevent_DEPS_TARGET
                              libevent_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "libevent"    # package_name
                              "${libevent_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${libevent_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Debug ########################################

    ########## COMPONENT libevent::pthreads #############

        set(libevent_libevent_pthreads_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(libevent_libevent_pthreads_FRAMEWORKS_FOUND_DEBUG "${libevent_libevent_pthreads_FRAMEWORKS_DEBUG}" "${libevent_libevent_pthreads_FRAMEWORK_DIRS_DEBUG}")

        set(libevent_libevent_pthreads_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET libevent_libevent_pthreads_DEPS_TARGET)
            add_library(libevent_libevent_pthreads_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET libevent_libevent_pthreads_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'libevent_libevent_pthreads_DEPS_TARGET' to all of them
        conan_package_library_targets("${libevent_libevent_pthreads_LIBS_DEBUG}"
                              "${libevent_libevent_pthreads_LIB_DIRS_DEBUG}"
                              "${libevent_libevent_pthreads_BIN_DIRS_DEBUG}" # package_bindir
                              "${libevent_libevent_pthreads_LIBRARY_TYPE_DEBUG}"
                              "${libevent_libevent_pthreads_IS_HOST_WINDOWS_DEBUG}"
                              libevent_libevent_pthreads_DEPS_TARGET
                              libevent_libevent_pthreads_LIBRARIES_TARGETS
                              "_DEBUG"
                              "libevent_libevent_pthreads"
                              "${libevent_libevent_pthreads_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET libevent::pthreads
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_LIBRARIES_TARGETS}>
                     )

        if("${libevent_libevent_pthreads_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET libevent::pthreads
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         libevent_libevent_pthreads_DEPS_TARGET)
        endif()

        set_property(TARGET libevent::pthreads APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET libevent::pthreads APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET libevent::pthreads APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_LIB_DIRS_DEBUG}>)
        set_property(TARGET libevent::pthreads APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET libevent::pthreads APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_pthreads_COMPILE_OPTIONS_DEBUG}>)


    ########## COMPONENT libevent::openssl #############

        set(libevent_libevent_openssl_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(libevent_libevent_openssl_FRAMEWORKS_FOUND_DEBUG "${libevent_libevent_openssl_FRAMEWORKS_DEBUG}" "${libevent_libevent_openssl_FRAMEWORK_DIRS_DEBUG}")

        set(libevent_libevent_openssl_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET libevent_libevent_openssl_DEPS_TARGET)
            add_library(libevent_libevent_openssl_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET libevent_libevent_openssl_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'libevent_libevent_openssl_DEPS_TARGET' to all of them
        conan_package_library_targets("${libevent_libevent_openssl_LIBS_DEBUG}"
                              "${libevent_libevent_openssl_LIB_DIRS_DEBUG}"
                              "${libevent_libevent_openssl_BIN_DIRS_DEBUG}" # package_bindir
                              "${libevent_libevent_openssl_LIBRARY_TYPE_DEBUG}"
                              "${libevent_libevent_openssl_IS_HOST_WINDOWS_DEBUG}"
                              libevent_libevent_openssl_DEPS_TARGET
                              libevent_libevent_openssl_LIBRARIES_TARGETS
                              "_DEBUG"
                              "libevent_libevent_openssl"
                              "${libevent_libevent_openssl_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET libevent::openssl
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_LIBRARIES_TARGETS}>
                     )

        if("${libevent_libevent_openssl_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET libevent::openssl
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         libevent_libevent_openssl_DEPS_TARGET)
        endif()

        set_property(TARGET libevent::openssl APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET libevent::openssl APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET libevent::openssl APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_LIB_DIRS_DEBUG}>)
        set_property(TARGET libevent::openssl APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET libevent::openssl APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_openssl_COMPILE_OPTIONS_DEBUG}>)


    ########## COMPONENT libevent::extra #############

        set(libevent_libevent_extra_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(libevent_libevent_extra_FRAMEWORKS_FOUND_DEBUG "${libevent_libevent_extra_FRAMEWORKS_DEBUG}" "${libevent_libevent_extra_FRAMEWORK_DIRS_DEBUG}")

        set(libevent_libevent_extra_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET libevent_libevent_extra_DEPS_TARGET)
            add_library(libevent_libevent_extra_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET libevent_libevent_extra_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'libevent_libevent_extra_DEPS_TARGET' to all of them
        conan_package_library_targets("${libevent_libevent_extra_LIBS_DEBUG}"
                              "${libevent_libevent_extra_LIB_DIRS_DEBUG}"
                              "${libevent_libevent_extra_BIN_DIRS_DEBUG}" # package_bindir
                              "${libevent_libevent_extra_LIBRARY_TYPE_DEBUG}"
                              "${libevent_libevent_extra_IS_HOST_WINDOWS_DEBUG}"
                              libevent_libevent_extra_DEPS_TARGET
                              libevent_libevent_extra_LIBRARIES_TARGETS
                              "_DEBUG"
                              "libevent_libevent_extra"
                              "${libevent_libevent_extra_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET libevent::extra
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_LIBRARIES_TARGETS}>
                     )

        if("${libevent_libevent_extra_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET libevent::extra
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         libevent_libevent_extra_DEPS_TARGET)
        endif()

        set_property(TARGET libevent::extra APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET libevent::extra APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET libevent::extra APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_LIB_DIRS_DEBUG}>)
        set_property(TARGET libevent::extra APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET libevent::extra APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_extra_COMPILE_OPTIONS_DEBUG}>)


    ########## COMPONENT libevent::core #############

        set(libevent_libevent_core_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(libevent_libevent_core_FRAMEWORKS_FOUND_DEBUG "${libevent_libevent_core_FRAMEWORKS_DEBUG}" "${libevent_libevent_core_FRAMEWORK_DIRS_DEBUG}")

        set(libevent_libevent_core_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET libevent_libevent_core_DEPS_TARGET)
            add_library(libevent_libevent_core_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET libevent_libevent_core_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libevent_libevent_core_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_core_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_core_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'libevent_libevent_core_DEPS_TARGET' to all of them
        conan_package_library_targets("${libevent_libevent_core_LIBS_DEBUG}"
                              "${libevent_libevent_core_LIB_DIRS_DEBUG}"
                              "${libevent_libevent_core_BIN_DIRS_DEBUG}" # package_bindir
                              "${libevent_libevent_core_LIBRARY_TYPE_DEBUG}"
                              "${libevent_libevent_core_IS_HOST_WINDOWS_DEBUG}"
                              libevent_libevent_core_DEPS_TARGET
                              libevent_libevent_core_LIBRARIES_TARGETS
                              "_DEBUG"
                              "libevent_libevent_core"
                              "${libevent_libevent_core_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET libevent::core
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libevent_libevent_core_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${libevent_libevent_core_LIBRARIES_TARGETS}>
                     )

        if("${libevent_libevent_core_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET libevent::core
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         libevent_libevent_core_DEPS_TARGET)
        endif()

        set_property(TARGET libevent::core APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_core_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET libevent::core APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${libevent_libevent_core_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET libevent::core APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${libevent_libevent_core_LIB_DIRS_DEBUG}>)
        set_property(TARGET libevent::core APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_core_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET libevent::core APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${libevent_libevent_core_COMPILE_OPTIONS_DEBUG}>)


    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET libevent::libevent APPEND PROPERTY INTERFACE_LINK_LIBRARIES libevent::pthreads)
    set_property(TARGET libevent::libevent APPEND PROPERTY INTERFACE_LINK_LIBRARIES libevent::openssl)
    set_property(TARGET libevent::libevent APPEND PROPERTY INTERFACE_LINK_LIBRARIES libevent::extra)
    set_property(TARGET libevent::libevent APPEND PROPERTY INTERFACE_LINK_LIBRARIES libevent::core)

########## For the modules (FindXXX)
set(libevent_LIBRARIES_DEBUG libevent::libevent)
