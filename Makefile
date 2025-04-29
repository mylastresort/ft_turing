CC 		= opam exec -- ocamlfind ocamlc -package yojson -linkpkg
DIR		= src
CMI 	= $(SRC:.ml=.cmi)
CMO 	= $(SRC:.ml=.cmo)
OBJ 	= $(CMO) $(CMI)
SRC 	= $(addprefix $(DIR)/, utils.ml errors.ml parser.ml logger.ml machine.ml complexity.ml)
MAIN	= $(DIR)/main.ml
NAME	= ft_turing
DEP		= yojson ocamlfind

.PHONY: all clean fclean re install

all: install $(NAME)

install:
	[ ! -d "${HOME}/.opam" ] && opam init --yes || true
	opam list --installed | grep --extended-regexp --silent "yojson|ocamlfind" || opam install --yes $(DEP)

$(NAME): $(OBJ) $(MAIN:.ml=.cmo) $(MAIN:.ml=.cmi)
	$(CC) $(CMO) $(MAIN:.ml=.cmo) -o $@

%.cmo %.cmi: %.ml
	$(CC) -c $< -I $(DIR) -o $@

clean:
	rm -rf $(OBJ) $(MAIN:.ml=.cmo) $(MAIN:.ml=.cmi)

fclean: clean
	rm -f $(NAME)

re: fclean all
