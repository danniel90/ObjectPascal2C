OPASCAL_LEXER	:= opascal_lexer.cpp
OPASCAL_GRAMMAR	:= opascal_grammar.cpp
OPASCAL_TREE_S	:= opascal_tree.cpp
OPASCAL_TREE_H	:= opascal_tree.h
OPASCAL_TOKENS	:= opascal_tokens.h

TARGET  := opascal
SRCS    := ${OPASCAL_TREE_S} ${OPASCAL_GRAMMAR} ${OPASCAL_LEXER} main.cpp
OBJS    := ${SRCS:.cpp=.o} 

CCFLAGS = -g
LDFLAGS = 
LIBS    = 

.PHONY: all clean

all:: ${TARGET} 

${TARGET}: ${OBJS} 
	${CXX} ${LDFLAGS} -o $@ $^ ${LIBS} 

${OBJS}: %.o: %.cpp
	${CXX} ${CCFLAGS} -o $@ -c $<
	
${OPASCAL_TREE_S} ${OPASCAL_TREE_H}: opascal.tc
	treecc -o ${OPASCAL_TREE_S} -h ${OPASCAL_TREE_H} $<

${OPASCAL_GRAMMAR} ${OPASCAL_TOKENS}: opascal.y
	bison --defines=${OPASCAL_TOKENS} -r all -o ${OPASCAL_GRAMMAR} $<

${OPASCAL_LEXER}: opascal.l
	flex -i -o ${OPASCAL_LEXER} $<

clean:: 
	-rm -f *~ *.o ${TARGET} ${OPASCAL_LEXER} ${OPASCAL_GRAMMAR} ${OPASCAL_TOKENS} ${OPASCAL_TREE_S} ${OPASCAL_TREE_H} *.output

