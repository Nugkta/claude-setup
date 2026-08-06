#!/bin/bash
#SBATCH --job-name=gpu-reserve
#SBATCH --partition=workq
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --output=%x-%j.log

RESUBMIT_DELAY=${1:-14h}

echo "=== GPU Reserved ==="
echo "Node: $(hostname)"
echo "Start: $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "GPUs: $CUDA_VISIBLE_DEVICES"
echo "Will resubmit after: $RESUBMIT_DELAY"
echo "SSH into this node: ssh $(hostname)"
echo "===================="

# Wait, then submit next job so it queues overnight
(
    sleep "$RESUBMIT_DELAY"
    NEXT_ID=$(sbatch /home/u6tn/han00.u6tn/gpu-reserve.sh 2>&1)
    echo "[$(date)] Next reservation submitted: $NEXT_ID"
) &

sleep infinity
