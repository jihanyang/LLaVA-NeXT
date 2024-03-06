export http_proxy=http://sys-proxy-rd-relay.byted.org:8118
export https_proxy=http://sys-proxy-rd-relay.byted.org:8118
export AZCOPY_CONCURRENCY_VALUE="AUTO"
export HF_HOME=/mnt/bn/${NAS_REGION}/workspace/.cache/huggingface
export HF_TOKEN="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"
export HF_HUB_ENABLE_HF_TRANSFER="1"

cd /mnt/bn/${NAS_REGION}/workspace/projects/ml_envs

bash Miniconda3-latest-Linux-x86_64.sh -b -u;
source ~/miniconda3/etc/profile.d/conda.sh -b -u;

conda init bash;
source ~/.bashrc;

cd /mnt/bn/${NAS_REGION}/workspace/projects/sglang
/home/tiger/miniconda3/bin/python3 -m pip install --upgrade pip
/home/tiger/miniconda3/bin/python3 -m pip install -e "python[all]"
/home/tiger/miniconda3/bin/python3 -m pip install vllm==0.3.2
/home/tiger/miniconda3/bin/python3 -m pip install hf_transfer

nvidia-smi
# python3 -m torch.utils.collect_env

which python3

cd /mnt/bn/${NAS_REGION}/workspace/projects/sglang
/home/tiger/miniconda3/bin/python3 -m sglang.launch_server --model-path liuhaotian/llava-v1.6-34b --tokenizer-path liuhaotian/llava-v1.6-34b-tokenizer --port=30000 --tp-size=8

sleep 480;
echo "Web service initialized";
python /mnt/bn/${NAS_REGION}/workspace/projects/LLaVA_Next/playground/sgl_llava_inference_multinode.py --image_folder=/mnt/bn/${NAS_REGION}/data/llava_data/blip_558k/images --dist=${1} --total_dist=24 --parallel=32 --port=30000