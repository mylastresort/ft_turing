(* Machine Exceptions *)
exception EmptyInput
exception InvalidInput
exception TransitionTableNotFound of string
exception TransitionNotFound of (string * char)
exception InputHasBlank
