open Base
open Owl
open Domainslib

let file =
  try Stdlib.Sys.argv.(1) with
  | _ -> "speedup"

let print s = Stdio.print_endline (Sexp.to_string s)

let time_this f =
  let t0 = Unix.gettimeofday () in
  f ();
  Unix.gettimeofday () -. t0

let n_repeat = 10
let n = Int.pow 2 11 (* will always be a multiple of #domains *)
let m = 2000
let nds = [| 1; 2; 4; 8; 16; 32; 64 |]

(* everything is preallocated so we won't be stressing the GC... *)
let a = Mat.gaussian n m
let b = Mat.gaussian m m
let c = Mat.gaussian n m

let perform pool =
  let nd = Task.get_num_domains pool in
  let group =
    let per_domain = n / nd in
    fun x i -> Arr.sub_left x (i * per_domain) per_domain
  in
  (* simple distributed matrix multiplication *)
  time_this (fun () ->
    Task.run pool (fun () ->
      Task.parallel_for pool ~chunk_size:1 ~start:0 ~finish:(nd - 1) ~body:(fun i ->
        Mat.dot_ ~c:(group c i) (group a i) b)))

(* establish the baseline *)
let baseline =
  let pool = Task.setup_pool ~num_domains:0 () in
  let t = Array.init n_repeat ~f:(fun _ -> perform pool) |> Stats.mean in
  Task.teardown_pool pool;
  t

let _ =
  Array.map nds ~f:(fun nd ->
    print [%message (nd : int)];
    let pool = Task.setup_pool ~num_domains:(nd - 1) () in
    let speedups =
      Array.init n_repeat ~f:(fun _ ->
        let t = perform pool in
        Float.(baseline / t))
    in
    Task.teardown_pool pool;
    Float.[| of_int nd; Stats.mean speedups; Stats.sem speedups |])
  |> Mat.of_arrays
  |> Mat.save_txt ~out:file

let _ =
  let c = Stdio.Out_channel.create (file ^ ".stats") in
  Stdlib.Gc.print_stat c;
  Stdio.Out_channel.close c
