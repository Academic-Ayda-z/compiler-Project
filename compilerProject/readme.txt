bison -d  parser.y
gcc lex.yy.c parser.tab.c -o compiler
./compiler < ./input2.txt | cat > ./output.txt