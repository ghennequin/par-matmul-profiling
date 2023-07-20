# Instructions

```sh
export OMP_NUM_THREADS=1
export OCAMLRUNPARAM=s=32M 

opam switch 5.0.0
eval $(opam env)
dune clean
dune exec src/toy.exe -- speedup-5.0 
  
opam switch 5.1.0~beta1
eval $(opam env)
dune clean
dune exec src/toy.exe -- speedup-5.1

gnuplot plot.gp
# then look at speedup.png
```

GC stats are saved in `speedup-5.0.stats` and `speedup-5.1.stats`.

