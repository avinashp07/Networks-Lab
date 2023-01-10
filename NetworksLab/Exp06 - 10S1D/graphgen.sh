set terminal png
set output 'PacketLoss.png'
set xrange [0.0:100.0]
set xlabel "Time(in seconds)"
set autoscale
set ylabel "Throughput(in Kbps)"
set grid
set style data linespoints
plot "packetloss" using 1:2 title "Packet Loss" lt rgb "red"

