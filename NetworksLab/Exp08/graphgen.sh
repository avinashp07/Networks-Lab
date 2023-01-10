set terminal png
set output 'QueueMonitoring2.png'
set xlabel "Time(in seconds)"
set autoscale
set ylabel "Packets"
set grid
set style data points
plot "queuemonitor" using 1:2 title "Queue" lt rgb "blue", "Dequeue" using 1:3 lt rgb "green", "Drop" using 1:4 lt rgb "red" 

