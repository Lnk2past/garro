# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(arrow_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(arrow_FRAMEWORKS_FOUND_DEBUG "${arrow_FRAMEWORKS_DEBUG}" "${arrow_FRAMEWORK_DIRS_DEBUG}")

set(arrow_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET arrow_DEPS_TARGET)
    add_library(arrow_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET arrow_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${arrow_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${arrow_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:boost::boost;mimalloc-static;thrift::thrift-conan-do-not-use;ZLIB::ZLIB;Arrow::arrow_static>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### arrow_DEPS_TARGET to all of them
conan_package_library_targets("${arrow_LIBS_DEBUG}"    # libraries
                              "${arrow_LIB_DIRS_DEBUG}" # package_libdir
                              "${arrow_BIN_DIRS_DEBUG}" # package_bindir
                              "${arrow_LIBRARY_TYPE_DEBUG}"
                              "${arrow_IS_HOST_WINDOWS_DEBUG}"
                              arrow_DEPS_TARGET
                              arrow_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "arrow"    # package_name
                              "${arrow_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${arrow_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Debug ########################################

    ########## COMPONENT Parquet::parquet_static #############

        set(arrow_Parquet_parquet_static_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(arrow_Parquet_parquet_static_FRAMEWORKS_FOUND_DEBUG "${arrow_Parquet_parquet_static_FRAMEWORKS_DEBUG}" "${arrow_Parquet_parquet_static_FRAMEWORK_DIRS_DEBUG}")

        set(arrow_Parquet_parquet_static_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET arrow_Parquet_parquet_static_DEPS_TARGET)
            add_library(arrow_Parquet_parquet_static_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET arrow_Parquet_parquet_static_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'arrow_Parquet_parquet_static_DEPS_TARGET' to all of them
        conan_package_library_targets("${arrow_Parquet_parquet_static_LIBS_DEBUG}"
                              "${arrow_Parquet_parquet_static_LIB_DIRS_DEBUG}"
                              "${arrow_Parquet_parquet_static_BIN_DIRS_DEBUG}" # package_bindir
                              "${arrow_Parquet_parquet_static_LIBRARY_TYPE_DEBUG}"
                              "${arrow_Parquet_parquet_static_IS_HOST_WINDOWS_DEBUG}"
                              arrow_Parquet_parquet_static_DEPS_TARGET
                              arrow_Parquet_parquet_static_LIBRARIES_TARGETS
                              "_DEBUG"
                              "arrow_Parquet_parquet_static"
                              "${arrow_Parquet_parquet_static_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET Parquet::parquet_static
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_LIBRARIES_TARGETS}>
                     )

        if("${arrow_Parquet_parquet_static_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET Parquet::parquet_static
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         arrow_Parquet_parquet_static_DEPS_TARGET)
        endif()

        set_property(TARGET Parquet::parquet_static APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET Parquet::parquet_static APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET Parquet::parquet_static APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_LIB_DIRS_DEBUG}>)
        set_property(TARGET Parquet::parquet_static APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET Parquet::parquet_static APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${arrow_Parquet_parquet_static_COMPILE_OPTIONS_DEBUG}>)


    ########## COMPONENT Arrow::arrow_static #############

        set(arrow_Arrow_arrow_static_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(arrow_Arrow_arrow_static_FRAMEWORKS_FOUND_DEBUG "${arrow_Arrow_arrow_static_FRAMEWORKS_DEBUG}" "${arrow_Arrow_arrow_static_FRAMEWORK_DIRS_DEBUG}")

        set(arrow_Arrow_arrow_static_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET arrow_Arrow_arrow_static_DEPS_TARGET)
            add_library(arrow_Arrow_arrow_static_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET arrow_Arrow_arrow_static_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'arrow_Arrow_arrow_static_DEPS_TARGET' to all of them
        conan_package_library_targets("${arrow_Arrow_arrow_static_LIBS_DEBUG}"
                              "${arrow_Arrow_arrow_static_LIB_DIRS_DEBUG}"
                              "${arrow_Arrow_arrow_static_BIN_DIRS_DEBUG}" # package_bindir
                              "${arrow_Arrow_arrow_static_LIBRARY_TYPE_DEBUG}"
                              "${arrow_Arrow_arrow_static_IS_HOST_WINDOWS_DEBUG}"
                              arrow_Arrow_arrow_static_DEPS_TARGET
                              arrow_Arrow_arrow_static_LIBRARIES_TARGETS
                              "_DEBUG"
                              "arrow_Arrow_arrow_static"
                              "${arrow_Arrow_arrow_static_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET Arrow::arrow_static
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_LIBRARIES_TARGETS}>
                     )

        if("${arrow_Arrow_arrow_static_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET Arrow::arrow_static
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         arrow_Arrow_arrow_static_DEPS_TARGET)
        endif()

        set_property(TARGET Arrow::arrow_static APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET Arrow::arrow_static APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET Arrow::arrow_static APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_LIB_DIRS_DEBUG}>)
        set_property(TARGET Arrow::arrow_static APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET Arrow::arrow_static APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${arrow_Arrow_arrow_static_COMPILE_OPTIONS_DEBUG}>)


    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET arrow::arrow APPEND PROPERTY INTERFACE_LINK_LIBRARIES Parquet::parquet_static)
    set_property(TARGET arrow::arrow APPEND PROPERTY INTERFACE_LINK_LIBRARIES Arrow::arrow_static)

########## For the modules (FindXXX)
set(arrow_LIBRARIES_DEBUG arrow::arrow)
