#!/bin/bash

rundir=${1:-run}

echo Size,Partition,Nodes,PPN,ExecutionTime,ClockTime
( find $rundir/*/*out -printf "%p " -exec tail -1 '{}'  \; ) | grep Exec | sed 's/.*run\.\([A-Z]\)\.\([a-zA-Z0-9]*\)\.N\([0-9]*\)\.ppn\([0-9]*\)\..*ExecutionTime = \([0-9.]*\) s.*ClockTime = \([0-9.]*\) s.*$/\1,\2,\3,\4,\5,\6/g'

