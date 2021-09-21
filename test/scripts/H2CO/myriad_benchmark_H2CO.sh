#!/bin/bash -l

# Batch script to run a serial job under SGE.
# Resources (mem, h_rt, tmpfs) currently set to a generous guess.
# Run with 'time' to measure resources used for more accurate requests.

# Request wallclock time (format hours:minutes:seconds).
#$ -l h_rt=12:00:0

# Request RAM (must be an integer followed by M, G, or T)
#$ -l mem=1G

# Request TMPDIR space (default is 10 GB)
#$ -l tmpfs=15G

# Set the name of the job.
#$ -N trove-benchmark-H2CO

# Email when job begins, ends, or aborts
#$ -m bea

# Set the working directory to somewhere in your scratch space and copy files
#$ -wd /home/ccaesja/Scratch/
TROVE_DIR="$HOME/proj-trove/TROVE"
cp $TROVE_DIR/test/benchmarks/H2CO/input/*.inp $TMPDIR
cp $TROVE_DIR/test/scripts/H2CO/run_benchmark.sh $TMPDIR
cp $TROVE_DIR/test/scripts/H2CO/myriad_benchmark_H2CO.sh $TMPDIR
cp $TROVE_DIR/j-trove.x $TMPDIR

# Your work should be done in $TMPDIR 
echo $TMPDIR
cd $TMPDIR

# Load relevant modules
module load python3/3.8
module load jq

# Run the application and put the output into a file called out.txt
# Should include info on time/memory use
 /usr/bin/time --verbose ./run_benchmark.sh 1 j-trove.x > out.txt

# tar-up all output files onto the shared scratch area
tar -zcvf $HOME/Scratch/files_from_job_$JOB_ID.tar.gz $TMPDIR
