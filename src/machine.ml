let _find_transition_table (algo : Parser.automaton) state =
  match
    List.find_opt
      (fun tt -> match tt with s, _ when s = state -> true | _ -> false)
      algo.transitions
  with
  | Some transition_table -> transition_table
  | None -> raise (Errors.TransitionTableNotFound state)

let _find_transition transition_table state input index =
  match
    List.find_opt
      (fun (t : Parser.transition) -> t.read = String.sub input index 1)
      transition_table
  with
  | Some t -> t
  | None -> raise (Errors.TransitionNotFound (state, String.get input index))

let _update_tape tape index write_value =
  let new_char = String.get write_value 0 in
  String.mapi (fun i c -> if i = index then new_char else c) tape

let _update_index action index =
  if action = "LEFT" then index - 1 else index + 1

let process (algo : Parser.automaton) (input : string) =
  let rec _loop state input index counter =
    match List.find_index (fun s -> s = state) algo.finals with
    | Some final_state -> counter
    | None ->
        let state, transition_table = _find_transition_table algo state in

        let transition = _find_transition transition_table state input index in

        Logger.log_transition input state transition index
          (String.get algo.blank 0);

        let new_tape = _update_tape input index transition.write in

        let new_index = _update_index transition.action index in

        let new_tape =
          match new_index with
          | i when i < 0 -> algo.blank ^ new_tape
          | i when i >= String.length new_tape -> new_tape ^ algo.blank
          | _ -> new_tape
        in

        let new_index = max new_index 0 in

        _loop transition.to_state new_tape new_index (counter + 1)
  in
  _loop algo.initial input 0 0
