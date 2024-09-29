open Yojson.Basic.Util

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

let parse jsonfile =
  let json = Yojson.Basic.from_file jsonfile in
  let transitions = json |> member "transitions" |> to_assoc in
  let transitions_list = List.map (fun (state_name, transition_list) ->
      let transitions = transition_list |> to_list |> List.map (fun obj ->
        {
          read = obj |> member "read" |> to_string;
          to_state = obj |> member "to_state" |> to_string;
          write = obj |> member "write" |> to_string;
          action = obj |> member "action" |> to_string;
        }
      ) in
      (state_name, transitions)
    ) transitions in
  {
    alphabet = json |> member "alphabet" |> to_list |> List.map to_string;
    states = json |> member "states" |> to_list |> List.map to_string;
    initial = json |> member "initial" |> to_string;
    finals = json |> member "finals" |> to_list |> List.map to_string;
    transitions = transitions_list
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