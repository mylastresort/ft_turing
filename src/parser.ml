open Yojson.Basic.Util

exception Json_malformed of string
exception Json_syntax_error of string

type transition = {
  read: string;
  to_state: string;
  write: string;
  action: string
}

type automaton = {
  alphabet: string list;
  states: string list;
  initial: string;
  finals: string list;
  transitions: (string * transition list) list;
}

let member_to_list_string name obj =
  obj |> member name |> to_list |> List.map to_string

let member_to_string name obj =
  obj |> member name |> to_string

let member_to_assoc name obj =
  obj |> member name |> to_assoc

let extract_field name fn =
  try
    fn ()
  with
  | Type_error (msg, _) ->
      raise (
        Json_malformed ("Missing or malformed '" ^ name ^ "' field.\n" ^ msg)
      )

let extract_state_transitions state transition_list =
  try
    transition_list |> to_list |> List.map (fun obj ->
      {
        read = member_to_string "read" obj;
        to_state = member_to_string "to_state" obj;
        write = member_to_string "write" obj;
        action = member_to_string "action" obj;
      }
    )
  with
  | Type_error (msg, _) ->
      raise (Json_malformed (
        "Malformed '" ^ state ^ "' transition object.\nError: " ^ msg
      ))

let read_json jsonfile =
  try
    Yojson.Basic.from_file jsonfile
  with
  | Yojson.Json_error msg ->
      raise (Json_syntax_error ("Bad json syntax: " ^ msg)) 

let parse jsonfile =
  let json = read_json jsonfile in
  let transitions = extract_field "transitions" (fun () ->
    member_to_assoc "transitions" json
  ) in
  {
    alphabet = extract_field "alphabet" (fun () ->
      member_to_list_string "alphabet" json
    );
    states = extract_field "states" (fun () ->
      member_to_list_string "states" json
    );
    initial = extract_field "initial" (fun () ->
      member_to_string "initial" json
    );
    finals = extract_field "finals" (fun () ->
      member_to_list_string "finals" json
    );
    transitions = List.map (fun (state, transition_list) ->
      (state, extract_state_transitions state transition_list)
    ) transitions;
  }

let process algo input = 
  Printf.printf "Alphabet: [ %s ]\n" (String.concat ", " algo.alphabet);
  Printf.printf "States: [ %s ]\n" (String.concat ", " algo.states);
  Printf.printf "Initial: %s \n" algo.initial;
  Printf.printf "Finals: [ %s ]\n" (String.concat ", " algo.finals);
  List.iter (fun (state, transitions) ->
    List.iter (fun trans ->
      Printf.printf "(%s, %s) -> (%s, %s, %s)\n" state trans.read trans.to_state trans.write trans.action
    ) transitions
  ) algo.transitions