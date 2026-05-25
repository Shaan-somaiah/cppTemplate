add_library(project_options INTERFACE)
add_library(project_warnings INTERFACE)

target_compile_features(project_options INTERFACE cxx_std_17)

target_compile_options(project_warnings
    INTERFACE
       -Wall
       -Wextra
       -Wpedantic
       -Wconversion
       -Wsign-conversion
)

target_compile_options(project_options
    INTERFACE
        $<$<CONFIG:Debug>:-g>
)