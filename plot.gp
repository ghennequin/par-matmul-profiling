set term pngcairo size 300,300
set output "speedup.png"
set key noautotitle

set border 3
set tics out nomirror
set log
set xrange [0.6:64]
set offset graph 0.05, graph 0.05
set yrange [0.6:64]
set ylabel 'speedup'
set xlabel '# domains'
set size square

plot x w l lc rgb 'gray' dt (10,10) lw 2, \
     'speedup-5.0' u 1:($2-$3):($2+$3) w filledcu fs transparent solid 0.2 lc 8, \
     '' u 1:2 t '5.0' w lp pt 7 lc 8 ps 0.5, \
     'speedup-5.1' u 1:($2-$3):($2+$3) w filledcu fs transparent solid 0.2 lc 7, \
     '' u 1:2 t '5.1' w lp pt 7 lc 7 ps 0.5

unset output




