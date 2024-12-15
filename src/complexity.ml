let calculate input_len iterations =
  print_endline (String.make 80 '*');

  let logn = float_of_int input_len |> Float.log2 |> int_of_float in
  let n = input_len in
  let two_pow_n = Utils.pow 2 n in
  let n_fact = 0 in

  match iterations with
  | x when x < logn -> "O(1)"
  | x when x < n -> "O(logn)"
  | x when x < n * logn -> "O(n)"
  | x when x < n * n -> "O(nlogn)"
  | x when x < two_pow_n -> "O(n^2)"
  | x when x < n_fact -> "O(2^n)"
  | _ -> "O(n!)"
