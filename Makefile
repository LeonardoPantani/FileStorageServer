#
# @file		Makefile
# @brief	File di tipo makefile che compila gli eseguibili, file oggetto, librerie statiche e rimuove i file obsoleti.
# @author	Leonardo Pantani
#

# ------------ CARTELLE ------------ 
# Cartella dei file oggetto
OBJECT_FOLDER = build/objects
# Cartella delle librerie
LIB_FOLDER = build/libs
# Cartella delle api
API_FOLDER = sources/api
# Cartella delle strutture dati
DS_FOLDER = sources/data_structures
# Cartella delle utils
UTL_FOLDER = sources/utils
# Cartella degli headers
HDR_FOLDER = headers


# ------------- ALTRO --------------
# Estensione del file socket da rimuovere da ovunque
SOCKET_EXTENSION = sk
# Bersagli phony (non sono nomi file ma una ricetta esplicita da eseguire)
.PHONY: all client server clean test1 test2 test3


# --------- COMPILAZIONE -----------
CC = gcc
CFLAGS += -g -std=c99 -Wall
CXXFLAGS += -DDEBUG
# CXXFLAGS += -DDEBUG -DDEBUG_VERBOSE # stampa informazioni relative all'invio e ricezione dei messaggi
THREAD_FLAGS = -pthread
INCLUDES = -I./$(HDR_FOLDER)

# Dipendenze server e client
server_dependencies = libs/libds.so libs/libserver.so libs/libcomm.so
client_dependencies = libs/libcomm.so libs/libapi.so

all: clean server client

server: $(server_dependencies)
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) $(THREAD_FLAGS) sources/server.c -o server -Wl,-rpath,./build/libs -L ./build/libs -lds -lserver -lcomm

client: $(client_dependencies)
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) sources/client.c -o client -Wl,-rpath,./build/libs -L ./build/libs -lapi -lcomm


libs/libserver.so: $(OBJECT_FOLDER)/config.o $(OBJECT_FOLDER)/statistics.o
	$(CC) -shared -o $(LIB_FOLDER)/libserver.so $^

libs/libapi.so: $(OBJECT_FOLDER)/utils.o $(OBJECT_FOLDER)/communication.o $(OBJECT_FOLDER)/api.o
	$(CC) -shared -o $(LIB_FOLDER)/libapi.so $^

libs/libds.so: $(OBJECT_FOLDER)/node.o $(OBJECT_FOLDER)/list.o $(OBJECT_FOLDER)/hashtable.o
	$(CC) -shared -o $(LIB_FOLDER)/libds.so $^

libs/libcomm.so: $(OBJECT_FOLDER)/utils.o $(OBJECT_FOLDER)/communication.o
	$(CC) -shared -o $(LIB_FOLDER)/libcomm.so $^



$(OBJECT_FOLDER)/api.o: $(API_FOLDER)/api.c $(HDR_FOLDER)/api.h
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) $(API_FOLDER)/api.c -c -fPIC -o $@

$(OBJECT_FOLDER)/communication.o: $(UTL_FOLDER)/communication.c $(HDR_FOLDER)/communication.h
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) $(UTL_FOLDER)/communication.c -c -fPIC -o $@

$(OBJECT_FOLDER)/statistics.o: $(UTL_FOLDER)/statistics.c $(HDR_FOLDER)/statistics.h
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) $(UTL_FOLDER)/statistics.c -c -fPIC -o $@

$(OBJECT_FOLDER)/config.o: $(UTL_FOLDER)/config.c $(HDR_FOLDER)/config.h
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) $(UTL_FOLDER)/config.c -c -fPIC -o $@

$(OBJECT_FOLDER)/utils.o: $(UTL_FOLDER)/utils.c $(HDR_FOLDER)/utils.h
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) $(UTL_FOLDER)/utils.c -c -fPIC -o $@

$(OBJECT_FOLDER)/node.o: $(DS_FOLDER)/node.c $(HDR_FOLDER)/node.h
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) $(DS_FOLDER)/node.c -c -fPIC -o $@

$(OBJECT_FOLDER)/list.o: $(DS_FOLDER)/list.c $(HDR_FOLDER)/list.h
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) $(DS_FOLDER)/list.c -c -fPIC -o $@

$(OBJECT_FOLDER)/hashtable.o: $(DS_FOLDER)/hashtable.c $(HDR_FOLDER)/hashtable.h
	$(CC) $(INCLUDES) $(CFLAGS) $(CXXFLAGS) $(DS_FOLDER)/hashtable.c -c -fPIC -o $@


# ------------- TARGET PHONY --------------
clean:
	rm -f -rf build
	rm -f -rf TestDirectory/output
	rm -f *.$(SOCKET_EXTENSION)
	rm -f server
	rm -f client
	mkdir build
	mkdir $(OBJECT_FOLDER)
	mkdir $(LIB_FOLDER)
	mkdir TestDirectory/output
	mkdir TestDirectory/output/Client
	mkdir TestDirectory/output/Client/flushati
	mkdir TestDirectory/output/Client/salvati
	mkdir TestDirectory/output/Server


test1:
	@$(MAKE) -s clean
	@$(MAKE) -s all
	@echo "*********************************************"
	@echo "*************** AVVIO TEST 1 ****************"
	@echo "*********************************************"
	@rm -f valgrind_output.txt
	@bash scripts/test1.sh
	@echo "*********************************************"
	@echo "************** TEST 1 SUPERATO **************"
	@echo "*********************************************"

test2:
	@$(MAKE) -s clean
	@$(MAKE) -s all
	@echo "*********************************************"
	@echo "*************** AVVIO TEST 2 ****************"
	@echo "*********************************************"
	@bash scripts/test2.sh
	@echo "*********************************************"
	@echo "************** TEST 2 SUPERATO **************"
	@echo "*********************************************"

test3:
	@$(MAKE) -s clean
	@$(MAKE) -s all
	@echo "*********************************************"
	@echo "********** TEST 3 NON IMPLEMENTATO **********"
	@echo "*********************************************"