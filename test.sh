export CUDA_VISIBLE_DEVICES=6,7
# accelerate launch \
#   --mixed_precision bf16 \
#   --num_cpu_threads_per_process 1 \
#   sd-scripts/flux_train_network.py \
#   --pretrained_model_name_or_path "/mnt/sdb/dongpeijie/workspace/fluxgym/models/unet/flux1-dev.sft" \
#   --clip_l "/mnt/sdb/dongpeijie/workspace/fluxgym/models/clip/clip_l.safetensors" \
#   --t5xxl "/mnt/sdb/dongpeijie/workspace/fluxgym/models/clip/t5xxl_fp16.safetensors" \
#   --ae "/mnt/sdb/dongpeijie/workspace/fluxgym/models/vae/ae.sft" \
#   --cache_latents_to_disk \
#   --save_model_as safetensors \
#   --sdpa --persistent_data_loader_workers \
#   --max_data_loader_n_workers 2 \
#   --seed 42 \
#   --gradient_checkpointing \
#   --mixed_precision bf16 \
#   --save_precision bf16 \
#   --network_module networks.lora_flux \
#   --network_dim 4 \
#   --optimizer_type adamw8bit \
#   --learning_rate 1e-4 \
#   --cache_text_encoder_outputs \
#   --cache_text_encoder_outputs_to_disk \
#   --fp8_base \
#   --highvram \
#   --max_train_epochs 3 \
#   --save_every_n_epochs 4 \
#   --dataset_config "/mnt/sdb/dongpeijie/workspace/fluxgym/dataset.toml" \
#   --output_dir "/mnt/sdb/dongpeijie/workspace/fluxgym/outputs" \
#   --output_name wukong-lora \
#   --timestep_sampling shift \
#   --discrete_flow_shift 3.1582 \
#   --model_prediction_type raw \
#   --guidance_scale 1.0 \
#   --loss_type l2 \
  
start_time=$(date +%s)

CUDA_VISIBLE_DEVICES=7 python sd-scripts/flux_minimal_inference.py --ckpt_path ./models/unet/flux1-dev.sft \
  --clip_l models/clip/clip_l.safetensors \
  --t5xxl models/clip/t5xxl_fp16.safetensors \
  --ae ./models/vae/ae.sft \
  --lora_weights ./outputs/wukong.safetensors \
  --prompt "WuKong Style a monkey woman is climbing a tree with blue blue sky." \
  --offload \
  --steps 50

end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "Execution time: $execution_time seconds"