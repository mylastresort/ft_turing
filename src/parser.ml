open Yojson.Basic.Util

exception File_not_found of string
exception Json_malformed of string
exception Json_syntax_error of string
exception Json_malformed_value of string

type transition = {
  read : string;
  to_state : string;
  write : string;
  action : string;
}

type automaton = {
  name : string;
  alphabet : string list;
  blank : string;
  states : string list;
  initial : string;
  finals : string list;
  transitions : (string * transition list) list;
}

let mem_to_lst_str obj name =
  obj |> member name |> to_list |> List.map to_string

let mem_to_str obj name = obj |> member name |> to_string
let mem_to_assoc obj name = obj |> member name |> to_assoc

let extract_field name fn =
  try fn name
  with Type_error (msg, _) ->
    raise (Json_malformed ("Missing or malformed '" ^ name ^ "' field.\n" ^ msg))

let validate_state state states =
  if not (List.exists (fun opt -> opt = state) states) then
    raise
      (Json_malformed_value
         ("Malformed 'transitions' field: '" ^ state ^ "' is not in states.")
      );
  state

let validate_state_trans name extractor state options =
  let value = extractor name in
  if not (List.exists (fun opt -> opt = value) options) then
    raise
      (Json_malformed_value
         ("Malformed '" ^ name ^ "' in '" ^ state ^ "' transition.")
      );
  value

let extract_state_trans state transition_list states alphabet actions =
  try
    let transitions =
      try transition_list |> to_list
      with Type_error (msg, _) ->
        raise
          (Json_malformed
             ("malformed '" ^ state ^ "' state transition array.\nError: " ^ msg)
          )
    in
    let extract obj = mem_to_str obj in
    transitions
    |> List.map (fun obj ->
           {
             read = validate_state_trans "read" (extract obj) state alphabet;
             to_state =
               validate_state_trans "to_state" (extract obj) state states;
             write = validate_state_trans "write" (extract obj) state alphabet;
             action = validate_state_trans "action" (extract obj) state actions;
           }
       )
  with Type_error (msg, _) ->
    raise
      (Json_malformed
         ("Malformed '" ^ state ^ "' transition object.\nError: " ^ msg)
      )

let read_json jsonfile =
  try Yojson.Basic.from_file jsonfile with
  | Sys_error msg -> raise (File_not_found "File not found.")
  | Yojson.Json_error msg ->
      raise (Json_syntax_error ("Bad json syntax: " ^ msg))

let parse jsonfile =
  let json = read_json jsonfile in
  let transitions = extract_field "transitions" (mem_to_assoc json) in
  let name = extract_field "name" (mem_to_str json) in
  let alphabet = extract_field "alphabet" (mem_to_lst_str json) in
  let blank = extract_field "blank" (mem_to_str json) in
  let states = extract_field "states" (mem_to_lst_str json) in
  let finals = extract_field "finals" (mem_to_lst_str json) in
  let initial = extract_field "initial" (mem_to_str json) in
  {
    name;
    alphabet;
    blank =
      ( if List.exists (fun a -> a = blank) alphabet then blank
        else
          raise
            (Json_malformed_value
               "Bad json input: 'blank' is not in known alphabet"
            )
      );
    states;
    initial =
      ( if List.exists (fun state -> state = initial) states then initial
        else
          raise
            (Json_malformed_value
               "Bad json input: 'initial' state is not in known states"
            )
      );
    finals =
      ( if List.for_all (fun e1 -> List.exists (fun e2 -> e1 = e2) states) finals
        then finals
        else
          raise
            (Json_malformed_value "Bad json input: 'finals' has unknown state")
      );
    transitions =
      List.map
        (fun (state, transition_list) ->
          ( validate_state state states,
            extract_state_trans state transition_list states alphabet
              [ "LEFT"; "RIGHT" ]
          )
        )
        transitions;
  }

let parse_input input alphabet =
  let in_alphabet c = String.contains alphabet c in
  match input with
  | "" -> raise Errors.EmptyInput
  | s when String.for_all in_alphabet input -> s
  | _ -> raise Errors.InvalidInput
