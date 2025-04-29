let log_header name =
  let _pad_name =
    let len = String.length name in
    let space_len = 78 - len in
    let left_space = space_len / 2 in
    let right_space = space_len - left_space in
    Printf.sprintf "*%s%s%s*"
      (String.make left_space ' ')
      name
      (String.make right_space ' ')
  in

  print_endline (String.make 80 '*');
  Printf.printf "*%s*\n" (String.make 78 ' ');
  print_endline _pad_name;
  Printf.printf "*%s*\n" (String.make 78 ' ');
  print_endline (String.make 80 '*')

let log_machine (algo : Parser.automaton) =
  Printf.printf "Alphabet: [ %s ]\n" (String.concat ", " algo.alphabet);
  Printf.printf "Blank: %s \n" algo.blank;
  Printf.printf "States: [ %s ]\n" (String.concat ", " algo.states);
  Printf.printf "Initial: %s \n" algo.initial;
  Printf.printf "Finals: [ %s ]\n" (String.concat ", " algo.finals);
  List.iter
    (fun (state, transitions) ->
      List.iter
        (fun (trans : Parser.transition) ->
          Printf.printf "(%s, %s) -> (%s, %s, %s)\n" state trans.read
            trans.to_state trans.write trans.action
        )
        transitions
    )
    algo.transitions

let log_transition input state (transition : Parser.transition) index blank =
  let tape =
    Printf.sprintf "%s<%c>%s" (String.sub input 0 index) (String.get input index)
      (String.sub input (index + 1) (String.length input - (index + 1)))
  in
  let padded_tape = Utils.str_pad_left tape 20 blank in
  Printf.printf "[%s] (%s, %c) -> (%s, %s, %s)\n" padded_tape state
    (String.get input index) transition.to_state transition.write
    transition.action
