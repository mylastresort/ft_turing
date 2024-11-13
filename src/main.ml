let usage_description = "usage: ft_turing [-h] jsonfile input"
(* Usage Description *)
let usage_msg = usage_description ^ "\n
positional arguments:
  jsonfile            json description of the machine\n
  input               input of the machine\n
optional arguments:
  -h, --help          show this list of options.\n"

(* List of arguments *)
let arguments = ref []

(* Function to append to the list of arguments *)
let anon_fun filename =
	arguments := filename :: !arguments

let speclist = [("-h", Arg.Unit (fun () -> raise (Arg.Help usage_msg)),
							"show this help message and exit");
							("-help", Arg.Unit (fun () -> raise (Arg.Bad "")),
							"unkown option '-help'")]

(* Main *)
let () =
	try
		Arg.parse_argv Sys.argv speclist anon_fun usage_msg;
		let open Parser in
		match !arguments with
		| [input; jsonfile] ->
            let algo = parse jsonfile
            in (
                Logger.log_header algo.name;
                Logger.log_machine algo;
                print_endline (String.make 80 '*');
				Machine.process (parse jsonfile) input
            )
		| _ -> Printf.eprintf "Fatal: Bad number of arguments\n%s" usage_msg;
						exit 1
	with
	| Arg.Help _ -> Printf.printf "%s" usage_msg
	| Arg.Bad msg ->
			Printf.eprintf "%s\nTry './ft_turing -h' for more information.\n"
				usage_description; exit 1
	| Parser.File_not_found msg ->
			Printf.eprintf "Fatal: %s\n" msg; exit 1
	| Parser.Json_malformed msg ->
			Printf.eprintf "Fatal: %s\n" msg; exit 1
	| Parser.Json_syntax_error msg ->
			Printf.eprintf "Fatal: %s\n" msg; exit 1
	| Parser.Json_malformed_value msg ->
			Printf.eprintf "Fatal: %s\n" msg; exit 1
    | Errors.TransitionTableNotFound state ->
        Printf.eprintf "Fatal: No transition table found for state \"%s\"\n" state; exit 1
    | Errors.TransitionNotFound (state, char) ->
        Printf.eprintf "Fatal: No transition found from (%s, %c)\n" state char; exit 1
	| _ -> Printf.eprintf "Fatal: Unknown error\n"; exit 1
