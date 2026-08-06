#!/bin/bash
# Quick check: is your GPU reservation running? Which node?
job=$(squeue -u $USER -n gpu-reserve -o "%i %T %N %M %l" -h 2>/dev/null)
if [ -z "$job" ]; then
    echo "No active gpu-reserve job. Submit one with:"
    echo "  sbatch ~/gpu-reserve.sh"
else
    echo "GPU reservation status:"
    echo "  JobID  State  Node  Elapsed  TimeLimit"
    echo "  $job"
    node=$(echo "$job" | awk '{print $3}')
    if [ "$node" != "" ] && [ "$node" != "(None)" ]; then
        echo ""
        jobid=$(echo "$job" | awk '{print $1}')
        echo "Connect with:  srun --overlap --jobid $jobid --pty bash"
    fi
fi
