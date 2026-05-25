include(FetchContent)

## build options
option(USE_SYSTEM_PACKAGES "Use system packages instead of fetching dependencies" ON)

option(USE_MY_CPP_LIBRARIES "Enable internal cppLibraries" ON)
option(USE_GLOG "Use glog for logging" ON)
option(USE_GFLAGS "Use gflags for command-line flag parsing" ON)
option(USE_GRPC "Use gRPC for remote procedure calls" OFF)

## Check if required packages are already installed, if not complile from source
## My internal cpp libraries 
if(USE_CPP_LIBRARIES)
    if(USE_SYSTEM_PACKAGES)
        find_package(cppLibraries CONFIG QUIET)
    endif()

    if(NOT cppLibraries_FOUND)
        message(STATUS "cppLibraries not installed locally, building from source!!")

        ## Disable generating test binary 
        set(CPP_LIBRARIES_BUILD_TESTS OFF CACHE BOOL "" FORCE)

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

## Google gflags library 
if(USE_GFLAGS)
    if(USE_SYSTEM_PACKAGES)
        find_package(gflags CONFIG QUIET)
    endif()

    if(NOT gflags_FOUND)
        message(STATUS "gflags not installed locally, building from source!!")

        FetchContent_Declare(
            gflags
            GIT_REPOSITORY https://github.com/gflags/gflags.git
            GIT_TAG v2.3.0
            GIT_SHALLOW TRUE
        )

        FetchContent_MakeAvailable(gflags)

    else()
        message(STATUS "Using system installed gflags!")
    endif()
endif()

## Google logging library 
if(USE_GLOG)
    if(USE_SYSTEM_PACKAGES)
        find_package(glog CONFIG QUIET)
    endif()

    if(NOT glog_FOUND)
        message(STATUS "glog not installed locally, building from source!!")

        FetchContent_Declare(
            glog
            GIT_REPOSITORY https://github.com/google/glog.git
            GIT_TAG v0.7.1
            GIT_SHALLOW TRUE
        )

        FetchContent_MakeAvailable(glog)

    else()
        message(STATUS "Using system installed glog!")
    endif()
endif()

## Google RPC library + protobuf
## Generating code from proto defined in grpc.cmake
if(USE_GRPC)
    if(USE_SYSTEM_PACKAGES)
        find_package(Protobuf CONFIG QUIET)
        find_package(gRPC CONFIG QUIET)
    endif()

    if(NOT Protobuf_FOUND OR NOT gRPC_FOUND)
        message(STATUS "gRPC/Protobuf not installed locally, building from source!!")

        ## This parameter enables propagating C++ features to targets that link to this package's libraries
        set(ABSL_PROPAGATE_CXX_STD ON CACHE BOOL "" FORCE)

        ## Disable tests for protobuf and grpc
        set(protobuf_BUILD_TESTS OFF CACHE BOOL "" FORCE)
        set(gRPC_BUILD_TESTS OFF CACHE BOOL "" FORCE)

        FetchContent_Declare(
            grpc
            GIT_REPOSITORY https://github.com/grpc/grpc.git
            GIT_TAG v1.64.0
            GIT_SHALLOW TRUE
        )

        FetchContent_MakeAvailable(grpc)

    else()
        message(STATUS "Using system installed gRPC/Protobuf!")
    endif()
endif()