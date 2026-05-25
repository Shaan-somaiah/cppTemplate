set(CORE_LIB_NAME ${PROJECT_NAME}_core)
set(APP_NAME ${PROJECT_NAME})

if(USE_GRPC)
    generate_grpc_cpp(
        PROTO_FILE  
            ${PROJECT_SOURCE_DIR}/proto/my_project_name.proto

        GENERATED_DIR
            ${CMAKE_BINARY_DIR}/generated
    )
endif()

add_library(${CORE_LIB_NAME}
    ${GENERATED_PROTO_SRCS}
)

target_link_libraries(${CORE_LIB_NAME}
    PUBLIC
        project_options
        project_warnings
)

## Optional dependencies 
if(USE_CPP_LIBRARIES)
    target_link_libraries(${CORE_LIB_NAME}
        PUBLIC
            cppLibraries
    )
endif()

if(USE_GFLAGS)
    target_link_libraries(${CORE_LIB_NAME}
        PUBLIC
            gflags
    )
endif()

if(USE_GLOG)
    target_link_libraries(${CORE_LIB_NAME}
        PUBLIC
            glog::glog
    )
endif()

if(USE_GRPC)
    target_link_libraries(${CORE_LIB_NAME}
        PUBLIC
            gRPC::grpc++
            protobuf::libprotobuf
    )
endif()

## Include directories
target_include_directories(${CORE_LIB_NAME}
    PUBLIC
        ${PROJECT_SOURCE_DIR}/include
)

## gRPC generated includes
if(USE_GRPC)
    target_include_directories(${CORE_LIB_NAME}
        PUBLIC
            ${GENERATED_PROTO_HDR_DIR}
    )
endif()


## Source subdirectories
add_subdirectory(core)

if(USE_GRPC)
    add_subdirectory(grpc)
endif()

## Executable binary 
add_executable(${APP_NAME}
    main.cc
)

target_link_libraries(${APP_NAME}
    PRIVATE
        ${CORE_LIB_NAME}
)