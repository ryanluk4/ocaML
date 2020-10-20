(* 
	Ryan Luk
	ryanluk4@gmail.com

	Weighted dice roll, frequentist probability

	This will simulate rolling a die with given `weights`
	corresponding to the values 1 through 6, printing the current 
	average every 10 trials, for `num_trials`.

	This is a good way to estimate average if the distribution is unknown.

	The average may bounce up and down even after hitting the expected value
	but the long run average will match the expected value.

	The expected value can be calculated by taking the dot product of the
	weights to [1,2,3,4,5,6], given by:

		E(X) = theta \dot X
			 = 0.1*1 + 0.1*2 + 0.1*3 + 0.1*4 + 0.1*5 + 0.5*6 = 4.5

*)

(* Weights corresponding to values 1 through 6 *)
let weights = [| 0.1;0.1;0.1;0.1;0.1;0.5 |]

let () =
	
	(* initiates Random *)
	Random.self_init () ;

	(* total is for counting the number of sucesses, stored as 
		a reference to count through the loop
	*)
	let total = ref 0. in
	(* defined number of trials *)
	let num_trials = 1000 in

	for i = 1 to num_trials do

		(* print out every 10 trials *)
		if (i mod 10) = 0 then
			Printf.printf "%f \n" (!total /. (float_of_int i))
		;

		(* value to save result *)
		let save_value = ref 0 in

		(* sum of weights *)
		let sum = ref 0. in
		(* resulting value *)
		let result = ref 1 in
		(* random [0,1] *)
		let random = Random.float 1. in

		(* 
			random corresponds to a random roll, across the
			distribution given by `weights`
		*)
		
		for i = 0 to (Array.length weights) - 1 do

			(* sums the weights *)
			sum := !sum +. weights.(i) ; 
			(* if the sum reaches the random roll, save the value*)
			if random < !sum then
				save_value := !result
			(* add one to the roll *)
			else
				result := !result + 1
			;
		done
		;

		(* add to a total for the long term average *)
		total := !total +. float_of_int !save_value

	done
;;