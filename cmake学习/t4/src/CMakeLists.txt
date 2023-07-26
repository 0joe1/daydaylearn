ADD_EXECUTABLE(main main.c)
INCLUDE_DIRECTORIES(/tmp/usr/include/hello)
TARGET_LINK_LIBRARIES(main /tmp/usr/lib/libhello.a)
