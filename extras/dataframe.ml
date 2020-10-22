(*
	Ryan Luk
	ryanluk4@gmail.com

	Simple dataframe
*)

open! Owl

let df = Dataframe.of_csv ~sep:',' "train.csv" ;;

Owl_pretty.pp_dataframe Format.std_formatter df;;

let xs = Dataframe.get_col df 0 ;;
let ys = Dataframe.get_col df 1 ;;

(* extract and transform, needs column names removed from .csv
	let extract_data csv_file =
	let data = Owl_io.read_csv ~sep:',' csv_file in
	let data = Array.map (fun x -> Array.map float_of_string x) data
		|> Mat.of_arrays in
	let x = Mat.get_slice [[];[1]] data in
	let y = Mat.get_slice [[];[0]] data in
	x, y
;;

	let x, y = extract_data "train.csv" ;; 
*)