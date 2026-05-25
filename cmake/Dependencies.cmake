include(FetchContent)

## build options
option(USE_SYSTEM_PACKAGES "Use system packages instead of fetching dependencies" ON)

option(USE_MY_CPP_LIBRARIES "Enable internal cppLibraries" ON)
option(USE_GLOG "Use glog for logging" ON)
option(USE_GFLAGS "Use gflags for command-line flag parsing" ON)
option(USE_GRPC "Use gRPC for remote procedure calls" ON)

## Check if required packages are already installed, if not complile from source

if(USE_MY_CPP_LIBRARIES)
    if(USE_SYSTEM_PACKAGES)
        find_package(cppLibraries CONFIG QUITE)
    endif()

    if(NOT cppLibraries_FOUND)
        message(STATUS "cppLibraries not installed locally, building from source!!")

        FetchContent_Declare(
            cppLibraries
            GIT_REPOSITORY git@github.com:Shaan-somaiah/cppLibraries.git
            GIT_TAG main
            GIT_SHALLOW TRUE
        )

        FetchContent_MakeAvailable(cppLibraries)

    else()
        message(STATUS "Using system installed cppLibraries!")
    endif()
endif()