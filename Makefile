CC 		= opam exec -- ocamlfind ocamlc -package yojson -linkpkg
DIR		= src
CMI 	= $(SRC:.ml=.cmi)
CMO 	= $(SRC:.ml=.cmo)
OBJ 	= $(CMO) $(CMI)
SRC 	= $(DIR)/parser.ml $(DIR)/main.ml
NAME	= ft_turing
DEP		= yojson ocamlfind

.PHONY: all clean fclean re install

all: install $(NAME)

install:
	[ ! -d "${HOME}/.opam" ] && opam init --yes || true
	opam install --yes $(DEP)

$(NAME): $(OBJ)
	$(CC) $(CMO) -o $@

%.cmo %.cmi: %.ml
	$(CC) -c $< -I src -o $@

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -f $(NAME)

re: fclean all
