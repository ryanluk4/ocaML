(*
  Ryan Luk
	ryanluk4@gmail.com

	CNN image recognition, mnist dataset
*)

open! Owl
open! Neural.S
open! Neural.S.Graph

(* 
	conv2d
    	?name
    	?(padding = SAME)
    	?(init_typ = Init.Tanh)
    	?act_typ
    	kernel
    	stride
    	input_node

  normalisation ?name ?(axis = -1) ?training ?decay ?mu ?var input_node

  max_pool2d ?name ?(padding = SAME) ?act_typ kernel stride input_node

  dropout ?name rate input_node
*)

(* 
	default padding is SAME
	VALID padding drops extras, i.e. 13 pixels with filter 6, stride 5
*)


let network_structure input_size =
  input input_size
  |> normalisation ~decay:0.9

  |> conv2d [|24;28;1;24|] [|1;1|] ~act_typ:Activation.Relu (* default padding SAME *)
  |> max_pool2d [|2;2|] [|2;2|] 

  |> dropout 0.4

  |> flatten

  |> fully_connected 128 ~act_typ:Activation.Relu

  |> dropout 0.4

  |> linear 10 ~act_typ:Activation.(Softmax 1)
  |> get_network (* feedfoward functions into network data type *)
;;

let train () =
  let input_size = [|28;28;1|] (* 28x28x1 digit size *)
  let x, _, y = Dataset.load_mnist_train_data_arr () in (* load *)
  let network = network_structure input_size in (* struct *)
  Graph.print network ; (* print *)

  let params = Params.config
    ~batch:(Batch.Mini 100)
    ~learning_rate:(Learning_Rate.Adam (0.001, 1e-7, 0.9)) (* default adam *)
    ~loss:(Loss.Cross_entropy) 1.0 (* 1 epoch *)
  in
  Graph.train ~params network x y |> ignore; (* train *)
  network (* return network *)
;;

let test network =
  let imgs, _, labels = Dataset.load_mnist_test_data () in
  let m = Dense.Matrix.S.row_num imgs in
  let imgs = Dense.Ndarray.S.reshape imgs [|m;28;28;1|] in

  let mat2num x = Dense.Matrix.S.of_array (
      x |> Dense.Matrix.Generic.max_rows
        |> Array.map (fun (_,_,num) -> float_of_int num)
    ) 1 m
  in

  let pred = mat2num (Graph.model network imgs) in (* eval model into matrices *)
  let fact = mat2num labels in
  let accu = Dense.Matrix.S.(elt_equal pred fact |> sum') in
  Owl_log.info "Accuracy on test set: %f" (accu /. (float_of_int m))
;;

let _ = 
  let n = train () in
  test n