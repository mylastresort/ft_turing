CC 		= ocamlfind ocamlc -package yojson -linkpkg
DIR		= src
CMI 	= $(SRC:.ml=.cmi)
CMO 	= $(SRC:.ml=.cmo)
OBJ 	= $(CMO) $(CMI)
SRC 	= $(DIR)/parser.ml $(DIR)/main.ml
NAME	= ft_turing
OPAM	= $(shell opam env)

.PHONY: all clean fclean re

all: $(NAME)

install:
	opam install yojson
	opam install ocamlfind

$(NAME): $(OBJ)
	$(CC) $(CMO) -o $@

%.cmo %.cmi: %.ml
	$(CC) -c $< -I src -o $@

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -f $(NAME)

re: fclean all