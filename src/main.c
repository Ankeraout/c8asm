#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "lexer.h"
#include "parser.h"

typedef struct {
	char* name;
	int address;
} Symbol;

Symbol* symbolTable = NULL;
int symbolTableSize = 0;

Symbol* unresolvedSymbolTable = NULL;
int unresolvedSymbolTableSize = 0;

uint8_t* buffer = NULL;
int bufferSize = 0;

int org = 0x200;
bool org_changed = false;

extern int yylineno;

void die(char* error);

int main(int argc, char** argv) {
	// Variables holding file names
	char* inputFileName = NULL;
	char* outputFileName = NULL;
	
	// Variable holding the output file descriptor.
	// Note that only the output file is held here, because the input file
	// descriptor will be placed in yyin.
	FILE* outputFile = NULL;
	
	// Check arguments
	for(int i = 1; i < argc; i++) {
		if(strcmp(argv[i], "-o") == 0) {
			if(argc > i + 1) {
				if(outputFileName == NULL) {
					outputFileName = argv[i + 1];
					i++;
				} else {
					fprintf(stderr, "Error: too many output files.\n");
					return 1;
				}
			} else {
				fprintf(stderr, "Error: expected file name after '-o'.");
				return 1;
			}
		} else {
			if(inputFileName == NULL) {
				inputFileName = argv[i];
			} else {
				fprintf(stderr, "Error: too many input files.\n");
				return 1;
			}
		}
	}
	
	// Open input file
	if(inputFileName == NULL) {
		yyin = stdin;
	} else {
		yyin = fopen(inputFileName, "r");
	
		if(yyin == NULL) {
			fprintf(stderr, "Error: could not open input file.\n");
			return 1;
		}
	}
	
	// Parse the file
	yyparse();
	
	// Close input file
	fclose(yyin);
	
	// Link symbols
	for(int i = 0; i < unresolvedSymbolTableSize; i++) {
		bool found = false;
		
		for(int j = 0; j < symbolTableSize; j++) {
			if(strcmp(unresolvedSymbolTable[i].name, symbolTable[j].name) == 0) {
				found = true;
				
				buffer[unresolvedSymbolTable[i].address - org] |= (symbolTable[j].address >> 8) & 0x0f;
				buffer[unresolvedSymbolTable[i].address - org + 1] = symbolTable[j].address & 0xff;
				
				break;
			}
		}
			
		if(!found) {
			fprintf(stderr, "Error: undefined symbol '%s'\n", unresolvedSymbolTable[i].name);
			return 1;
		}
	}
	
	// Open output file
	if(outputFileName == NULL) {
		outputFile = stdout;
	} else {
		outputFile = fopen(outputFileName, "w+");
		
		if(outputFile == NULL) {
			fprintf(stderr, "Error: could not open output file.\n");
			return 1;
		}
	}
	
	// Write code to output file
	fwrite(buffer, 1, bufferSize, outputFile);
	
	// Close output file
	fclose(outputFile);
	
	return 0;
}

void define_label(char* name, int address) {
	// Check if the label was not defined earlier
	for(int i = 0; i < symbolTableSize; i++) {
		if(strcmp(name, symbolTable[i].name) == 0) {
			fprintf(stderr, "Error: symbol '%s' redefined on line %d.\n", name, yylineno);
			exit(1);
		}
	}
	
	symbolTable = realloc(symbolTable, sizeof(Symbol) * (symbolTableSize + 1));
	
	if(symbolTable == NULL) {
		fprintf(stderr, "Error: could not allocate memory.\n");
		exit(1);
	} else {
		symbolTable[symbolTableSize].name = name;
		symbolTable[symbolTableSize].address = address;
		symbolTableSize++;
	}
}

void wanted_label(char* name, int address) {
	unresolvedSymbolTable = realloc(unresolvedSymbolTable, sizeof(Symbol) * (unresolvedSymbolTableSize + 1));
	
	if(unresolvedSymbolTable == NULL) {
		fprintf(stderr, "Error: could not allocate memory.\n");
		exit(1);
	} else {
		unresolvedSymbolTable[unresolvedSymbolTableSize].name = name;
		unresolvedSymbolTable[unresolvedSymbolTableSize].address = address;
		unresolvedSymbolTableSize++;
	}
}

void buffer_writeByte(uint8_t byte) {
	int address = bufferSize + org;
	
	if(address < 0 || address >= 0x1000) {
		fprintf(stderr, "Error: buffer write out of address space.\n");
		exit(1);
	}
	
	buffer = realloc(buffer, sizeof(uint8_t) * (bufferSize + 1));
	
	if(buffer == NULL) {
		fprintf(stderr, "Error: could not allocate memory.\n");
		exit(1);
	} else {
		buffer[bufferSize] = byte;
		bufferSize++;
	}
}

void change_org(int address) {
	if(address < 0 || address >= 0x1000) {
		die("ORG directive out of range");
	} else {
		if(org_changed) {
			die("too many ORG directives");
		} else if(bufferSize > 0) {
			die("unexpected ORG directive");
		} else {
			org_changed = true;
			org = address;
		}
	}
}

int currentBufferAddress() {
	return bufferSize + org;
}

void die(char* error) {
	fprintf(stderr, "Error: %s on line %d.\n", error, yylineno);
	exit(1);
}
