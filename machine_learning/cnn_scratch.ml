(*
	Ryan Luk
	ryanluk4@gmail.com

	CNN image recognition, cifar dataset
*)

open! Owl
open! Algodiff.S
open! Neural.S

(* layer type *)
type layer = {
	mutable weight : t ;
	mutable bias : t ;
	mutable activation : t -> t ;
}

(* network type = collection of layers *)
type network = {
	layers : layer array
}

(* evaluate layer going forward, input x *)
let forward_layer xs layer = 
	Maths.((xs *@ layer.weight) + layer.bias) |> layer.activation
;;

(* evaluate whole network *)
let forward_network xs network =
	Array.fold_left forward_layer xs network.layers
;;

(* cross entropy loss *)
let loss_function network xs ys =

	let t = tag () in (* init int 1 *)
	Array.iter (fun layer ->
		layer.weight <- make_reverse layer.weight t;
		layer.bias <- make_reverse layer.bias t;
	) network.layers;
	Maths.(cross_entropy ys (forward_network xs network) / (F (Mat.row_num ys |> float_of_int)))

;;

(* back prop *)
let backpropagation network eta xs ys =
	
	let loss = loss_function network xs ys in
	reverse_prop (F 1.) loss;

	(* primal is the basic function, not the differential *)
	(* adjval undoes tangent differential *)
	Array.iter (fun layer -> 
		layer.weight <- Maths.((primal layer.weight) - (eta * (adjval layer.weight))) |> primal;
		layer.bias <- Maths.((primal layer.bias) - (eta * (adjval layer.bias))) |> primal;
	) network.layers;

	loss |> unpack_flt

;;

(* runs network, produces predictions with probability *)
let predict_network network xs ys =

	Dense.Matrix.S.iter2_rows (fun row _ ->

		let p = forward_network (Arr row) network |> unpack_arr in
		Dense.Matrix.Generic.print p;

		let prob, i = Dense.Matrix.Generic.max_i p in
		Printf.printf "prediction: %i\nwith probability: %f\n" i.(1) prob
		) (unpack_arr xs) (unpack_arr ys) ;

;;


let main () = 
	(* network structure *)
	let layer1 = {
		weight = Maths.(Mat.uniform 784 40 * F 0.15 - F 0.075) ;
		bias = Mat.zeros 1 40 ;
		activation = Maths.tanh ;
	} in

	let last_layer = {
		weight = Maths.(Mat.uniform 40 10 * F 0.15 - F 0.075) ;
		bias = Mat.zeros 1 10 ;
		activation = Maths.softmax ~axis:1 ;
	} in

	let net = {
		layers = [|layer1; last_layer|]
	} in

	(* train *)
	let x, _, y = Dataset.load_mnist_train_data () in
	for i = 1 to 999 do
		let x', y' = Dataset.draw_samples x y 100 in
		backpropagation net (F 0.01) (Arr x') (Arr y')
		|> Owl_log.info "#%03i : loss %g" i
	done ;

	(* random sample, prediction *)
	let x, y, _ = Dataset.load_mnist_train_data () in
	let x, y = Dataset.draw_samples x y 10 in
	predict_network net (Arr x) (Arr y)

;;

let _ = main ()
	