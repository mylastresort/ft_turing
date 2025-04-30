CC 		= opam exec -- ocamlfind ocamlopt -package yojson -linkpkg
DIR		= src
CMI 	= $(SRC:.ml=.cmi)
CMX 	= $(SRC:.ml=.cmx)
OBJ 	= $(CMX) $(CMI) $(SRC:.ml=.o)
SRC 	= $(addprefix $(DIR)/, utils.ml errors.ml parser.ml logger.ml machine.ml complexity.ml main.ml)
NAME	= ft_turing
DEP		= yojson ocamlfind

.PHONY: all clean fclean re install

all: install $(NAME)

install:
	[ ! -d "${HOME}/.opam" ] && opam init --yes || true
	opam list --installed | grep --extended-regexp --silent "yojson|ocamlfind" || opam install --yes $(DEP)

$(NAME): $(OBJ)
	$(CC) $(CMX) -o $@

%.cmx %.cmi %.o: %.ml
	$(CC) -c $< -I $(DIR) -o $@

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -f $(NAME) .depend

re: fclean all

.depend:
	ocamldep -native -I $(DIR) -all $(SRC) > .depend

-include .depend
