set terminal png
set output "Result.png"
set xlabel "Time (in seconds)"
set grid
set autoscale
set ylabel "Throughput (in kbps)"
set style data linespoints
plot "thrptgraph1" using 1:2 title "TCP Throughput" lt rgb "blue"