##########################
#####    MAKEFILE    #####
##########################

EX = robot
LIBSO = librobot.so


ARM_SRC_DIR=../armv7/src

INCLUDE_DIR= $(ARM_SRC_DIR)
LIB_DIR=$(CPPUNIT_PATH)/lib
LIBS= 

CPPFLAGS= -std=gnu++11 -Wextra -Wall -O3 `pkg-config --cflags playerc++` -fPIC #-DDEBUG
DEBUG= -g

LDFLAGS=-L$(LIB_DIR) $(LIBS) `pkg-config --libs playerc++`

CPPSOURCES = $(wildcard *.cpp)




################################################################    
# all: $(EX)

all: $(LIBSO)

$(EX): $(CPPSOURCES:.cpp=.o)
	g++ -o $@ $^ $(LDFLAGS)


$(LIBSO): $(CPPSOURCES:.cpp=.o) gpio_map.o
	g++ -shared  -Wl,-soname,$(LIBSO) -o $(LIBSO) $^  $(LDFLAGS) 


%.o: %.cpp
	g++ $(CPPFLAGS) $(DEBUG) -c $< -o $@ -I $(INCLUDE_DIR)



gpio_map.o: $(ARM_SRC_DIR)/gpio_map.cpp
	g++ $(CPPFLAGS) $(DEBUG) -c $< -o $@  -I $(INCLUDE_DIR) 


################################################################	

clean:
	-rm -f *.o *~ *.so

cleaner:
	-rm -rf *.o *~ $(EX) *.so

################################################################	

remade:
	$(MAKE) cleaner
	$(MAKE)
