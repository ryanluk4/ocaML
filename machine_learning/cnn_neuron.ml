(*
	Ryan Luk
	ryanluk4@gmail.com

	CNN image recognition, cifar dataset

	The CIFAR dataset has 60_000 color images (32 x 32) in 10 classes
	- 6_000 images per class
	- 50_000 training
	- 10_000 testing
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

(* 
	This is a more straightforward network with less dropout, less dense
	layers, and evenly sized convolution layers.
*)

let makeNetwork input_shape =
  	input input_shape
  	(* normalization layer *)
  	|> normalisation ~decay:0.9
  	(*
  		conv layer 1
  		input: 32 32 3
  		output: 32 32 32
  	*)
  	|> conv2d [|3;3;3;32|] [|1;1|] ~act_typ:Activation.Relu
  	(*
  		conv layer 2
  		input: 32 32 32
  		output: 30 30 32
  	*)
  	|> conv2d [|3;3;32;32|] [|1;1|] ~act_typ:Activation.Relu
  	(*
  		max pool 1
  		input: 30 30 32
  		output: 15 15 32
  	*)
  	|> max_pool2d [|2;2|] [|2;2|]
  	(* dropout rate of 0.1 *)
  	|> dropout 0.1
  	(*
  		conv layer 3
  		input: 15 15 32
  		output: 15 15 64
  	*)
  	|> conv2d [|3;3;32;64|] [|1;1|] ~act_typ:Activation.Relu
  	(*
  		conv layer 4
  		input: 15 15 64
  		output: 13 13 64
  	*)
  	|> conv2d [|3;3;64;64|] [|1;1|] ~act_typ:Activation.Relu
  	(*
  		max pool 2
  		input: 13 13 64
  		output: 6 6 64
  	*)
  	|> max_pool2d [|2;2|] [|2;2|]
  	(* dropout rate of 0.1 *)
  	|> dropout 0.1
  	(*
  		full layer 1
  		input: 6 6 64
  		output: 512
  	*)
  	|> fully_connected 512 ~act_typ:Activation.Relu
  	(*
  		linear layer 1
  		input: 512
  		output: 10
  	*)
  	|> linear 10 ~act_typ:Activation.(Softmax 1)
  	(* softmax 10 for classification *)
  	|> get_network

;;

let trainNetwork () =
	(* load dataset 1 *)
	let x, _, y = Dataset.load_cifar_train_data 1 in
	(* network has input 32x32x3 *)
	let network = makeNetwork [|32;32;3|] in
	(* print layers *)
	Graph.print network;
	let params = Params.config
    	~batch:(Batch.Mini 100) ~learning_rate:(Learning_Rate.Adagrad 0.005)
    	(* checkpoint provides snapshots every epoch*)
    	~checkpoint:(Checkpoint.Epoch 5.) ~stopping:(Stopping.Const 1e-6) 10.
  	in
  	Graph.train ~params network x y |> ignore ;
  network
;;

let testNetwork network =
  (* data *)
  let images, _, labels = Dataset.load_mnist_test_data () in
  let rows = Dense.Matrix.S.row_num images in
  let images = Dense.Ndarray.S.reshape images [|rows;28;28;1|] in

  (* format *)
  let mat2num x = Dense.Matrix.S.of_array (
      x |> Dense.Matrix.Generic.max_rows
        |> Array.map (fun (_,_,num) -> float_of_int num)
    ) 1 rows
  in

  (* matching prediction *)
  let pred = mat2num (Graph.model network images) in
  let fact = mat2num labels in
  let accu = Dense.Matrix.S.(elt_equal pred fact |> sum') in
  Owl_log.info "Accuracy on test set: %f" (accu /. (float_of_int rows))

(*
	This is a model I made in a machine learning class on the CIFAR dataset, translated
	from Python (Tensorflow/Keras), the only difference is I used a SGD optimizer
	(with learning rate = 0.05, decay = 1e-6, momentum = 0.9). So, the only similarity
	is the network structure. This network resulted in the most even accuracy and 
	validation accuracy (around 0.76) with the Python dataset.	

	The syntax/structure of functional programming and sparse documentation still
	confuses me a bit, so this network feels a little heavy. I also went very liberal
	on the dropout to even out validation accuracies.
*)

let networkCSE input_shape =
  	input input_shape
  	|> normalisation ~decay:0.9
  	|> conv2d [|3;3;3;50|] [|1;1|] ~act_typ:Activation.Relu
  	|> max_pool2d [|2;2|] [|2;2|] 
  	|> conv2d [|3;3;50;100|] [|1;1|] ~act_typ:Activation.Relu
  	|> max_pool2d [|2;2|] [|2;2|]
  	|> dropout  0.2
  	|> conv2d [|3;3;100;150|] [|1;1|] ~act_typ:Activation.Relu
  	|> max_pool2d [|2;2|] [|2;2|]
  	|> dropout 0.3
  	|> fully_connected 50 ~act_typ:Activation.Relu
  	|> dropout 0.2
  	|> fully_connected 50 ~act_typ:Activation.Relu
  	|> dropout 0.3
  	|> fully_connected 50 ~act_typ:Activation.Relu
  	|> dropout 0.4
  	|> linear 10 ~act_typ:Activation.(Softmax 1)
  	|> get_network

;;

let trainCSE () =
	(* load dataset 1 *)
	let x, _, y = Dataset.load_cifar_train_data 1 in
	(* network has input 32x32x3 *)
	let network = networkCSE [|32;32;3|] in
	(* print layers *)
	Graph.print network;
	let params = Params.config
    	~batch:(Batch.Mini 100) ~learning_rate:(Learning_Rate.Adagrad 0.005)
    	(* checkpoint provides snapshots every epoch*)
    	~checkpoint:(Checkpoint.Epoch 5.) ~stopping:(Stopping.Const 1e-6) 10.
  	in
  	Graph.train ~params network x y

;;

let _ = 
  let n = trainNetwork () in
  testNetwork n