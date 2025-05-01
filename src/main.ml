let usage_description = "usage: ft_turing [-h] jsonfile input"

(* Usage Description *)
let usage_msg =
  usage_description
  ^ "\n\n\
     positional arguments:\n\
    \  jsonfile            json description of the machine\n\n\
    \  input               input of the machine\n\n\
     optional arguments:\n\
    \  -h, --help          show this list of options.\n"

(* Main *)
let () =
  try
    let open Parser in
    let arguments = Array.to_list Sys.argv in
    if List.exists (fun e -> e = "-h" || e = "--help") arguments then
      Printf.printf "%s" usage_msg
    else
      match arguments with
      | _ :: [ jsonfile; input ] ->
          if input = "" then raise Errors.EmptyInput;
          let algo = parse jsonfile in
          let input = parse_input input (String.concat "" algo.alphabet) in
          Logger.log_header algo.name;
          Logger.log_machine algo;
          print_endline (String.make 80 '*');
          Machine.process algo input
          |> Complexity.calculate (String.length input)
          |> Printf.printf "Time Complexity: %s\n"
      | _ ->
          Printf.eprintf "Fatal: Bad number of arguments\n%s" usage_msg;
          exit 1
  with
  | Arg.Help _ -> Printf.printf "%s" usage_msg
  | Arg.Bad msg ->
      Printf.eprintf "%s\nTry './ft_turing -h' for more information.\n"
        usage_description;
      exit 1
  | Parser.File_not_found msg ->
      Printf.eprintf "Fatal: %s\n" msg;
      exit 1
  | Parser.Json_malformed msg ->
      Printf.eprintf "Fatal: %s\n" msg;
      exit 1
  | Parser.Json_syntax_error msg ->
      Printf.eprintf "Fatal: %s\n" msg;
      exit 1
  | Parser.Json_malformed_value msg ->
      Printf.eprintf "Fatal: %s\n" msg;
      exit 1
  | Errors.EmptyInput ->
      Printf.eprintf "Fatal: Input must not be blank\n";
      exit 1
  | Errors.InvalidInput ->
      Printf.eprintf
        "Fatal: Input must only contain characters from the specified alphabet\n";
      exit 1
  | Errors.InputHasBlank ->
      Printf.eprintf "Fatal: Input must not contain blank characters\n";
      exit 1
  | Errors.TransitionTableNotFound state ->
      Printf.eprintf "Fatal: No transition table found for state \"%s\"\n" state;
      exit 1
  | Errors.TransitionNotFound (state, char) ->
      Printf.eprintf "Fatal: No transition found from (%s, %c)\n" state char;
      exit 1
  | _ ->
      Printf.eprintf "Fatal: Unknown error\n";
      exit 1
