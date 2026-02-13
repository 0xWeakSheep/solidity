add_library(libYulASTComparator
	ASTComparator.cpp
	ASTComparator.h
	ScopeBimap.h
)
target_link_libraries(libYulASTComparator PUBLIC solidity)

add_executable(yulASTComparator main.cpp)
target_link_libraries(yulASTComparator PRIVATE libYulASTComparator)
