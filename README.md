# Instructions

```sh
export OMP_NUM_THREADS=1
export OCAMLRUNPARAM=s=32M

opam switch 5.0.0
eval $(opam env)
opam pin -n git+https://github.com/tmcgilchrist/owl.git#arm64 --with-version=1.1.0 -y
opam install stdio base owl domainslib ppx_sexp_message -y
dune clean
dune exec src/toy.exe -- speedup-5.0.0

opam switch 5.1.0
opam pin -n git+https://github.com/tmcgilchrist/owl.git#arm64 --with-version=1.1.0 -y
opam install stdio base owl domainslib ppx_sexp_message
eval $(opam env)
dune clean
dune exec src/toy.exe -- speedup-5.1.0

opam switch 5.1.1
opam pin -n git+https://github.com/tmcgilchrist/owl.git#arm64 --with-version=1.1.0 -y
opam install stdio base owl domainslib ppx_sexp_message
eval $(opam env)
dune clean
dune exec src/toy.exe -- speedup-5.1.1

gnuplot plot.gp
# then look at speedup.png
```

GC stats are saved in `speedup-5.0.stats` and `speedup-5.1.stats`.

