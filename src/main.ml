(* Usage Description *)
let usage_msg = "usage: ft_turing [-h] jsonfile input\n
positional arguments:
  jsonfile            json description of the machine\n
  input               input of the machine\n
optional arguments:"

(* List of arguments *)
let arguments = ref []

(* Function to append to the list of arguments *)
let anon_fun filename =
	arguments := filename :: !arguments

let help = ref false

let speclist = [("-h", Arg.Set help, "Display this list of options")]

(* Main *)
let () =
	(* handles the parsing of command arguments *)
	Arg.parse speclist anon_fun usage_msg;
	(* Verifying the nature of arguments *)
	let open Parser in
	match !arguments with
	| [input; jsonfile] -> begin
		try
			process (parse jsonfile) input
		with
		| Parser.Json_malformed msg ->
				Printf.eprintf "Fatal: %s\n" msg
		| Parser.Json_syntax_error msg ->
				Printf.eprintf "Fatal: %s\n" msg
		| Parser.Json_malformed_value msg ->
				Printf.eprintf "Fatal: %s\n" msg
	end
	| _ -> print_endline "Fatal: Bad number of arguments"