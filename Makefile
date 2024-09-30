CC 		= ocamlfind ocamlc -package yojson -linkpkg
DIR		= src
CMI 	= $(SRC:.ml=.cmi)
CMO 	= $(SRC:.ml=.cmo)
OBJ 	= $(CMO) $(CMI)
SRC 	= $(DIR)/parser.ml $(DIR)/main.ml
NAME	= ft_turing
DEP		= yojson ocamlfind

.PHONY: all clean fclean re

all: $(NAME)

install:
	opam --version || apt update && apt install opam -y
	test -r /root/.opam/opam-init/init.sh && . /root/.opam/opam-init/init.sh > /dev/null 2> /dev/null || opam init -y
	echo 'test -r /root/.opam/opam-init/init.sh && . /root/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true' >> ~/.profile
	[ ! -d "_opam" ] && opam switch create . $(DEP)


$(NAME): $(OBJ)
	eval $$(opam env); $(CC) $(CMO) -o $@

%.cmo %.cmi: %.ml
	eval $$(opam env); $(CC) -c $< -I src -o $@

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -f $(NAME)

re: fclean all