(* Machine Exceptions *)
exception EmptyInput
exception TransitionTableNotFound of string
exception TransitionNotFound of (string * char)
