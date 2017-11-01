# c8asm
## Description
c8asm is a simple assembler for Chip-8 language written in C, using flex & bison. It follows Cowgod's Chip-8 technical reference syntax (http://devernay.free.fr/hacks/chip8/C8TECH10.HTM).
## Building
To build c8asm, you need an Unix operating system with at least Make, GCC, Binutils, GNU Flex and GNU Bison on it.<br>
To start building the application, just set your working directory to the root directory of this repository, and type `make all`.<br>
The application is really small so it should not take more than a few seconds to build it.<br>
The executable will be placed in the bin directory, which will be created at build time.<br>
## Usage
By default, c8asm reads its input from stdin, and writes its output to stdout.<br>
Error messages are always written to stderr.<br>
In order to make c8asm read a file, you have to specify the input file name like this :<br>
`c8asm input_file.c8a`<br>
You can also specify the output file using the '-o' option :<br>
`c8asm input_file.c8a -o output_file.ch8`<br>
c8asm was made to work with pipes. Here is an example :<br>
`cat input_file.c8a | c8asm > output_file.c8a`<br>