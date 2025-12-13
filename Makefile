.PHONY: setup setup-kohya download-model build up down logs logs-webui logs-kohya clean clean-images

setup: setup-kohya
	mkdir -p webui/models/Stable-diffusion
	mkdir -p webui/models/Lora
	mkdir -p webui/models/hypernetworks
	mkdir -p webui/models/embeddings
	mkdir -p webui/models/VAE
	mkdir -p webui/models/VAE-approx
	mkdir -p webui/models/ControlNet
	mkdir -p webui/models/ESRGAN
	mkdir -p webui/models/GFPGAN
	mkdir -p webui/models/LDSR
	mkdir -p webui/models/SwinIR
	mkdir -p webui/models/Codeformer
	mkdir -p webui/outputs
	mkdir -p kohya/dataset/images
	mkdir -p kohya/dataset/logs
	mkdir -p kohya/outputs
	mkdir -p kohya/.cache/config
	mkdir -p kohya/.cache/user
	mkdir -p kohya/.cache/triton
	mkdir -p kohya/.cache/nv
	mkdir -p kohya/.cache/keras
	mkdir -p lora
	chmod -R 777 webui/models webui/outputs
	@echo "Setup complete!"

setup-kohya:
	@if [ ! -d "kohya_ss_src" ]; then \
		echo "Cloning kohya_ss repository..."; \
		git clone --depth 1 https://github.com/bmaltais/kohya_ss.git kohya_ss_src; \
		cd kohya_ss_src && git submodule update --init --recursive; \
		echo "kohya_ss cloned successfully!"; \
	else \
		echo "kohya_ss_src already exists. Skipping clone."; \
	fi

build: setup-kohya
	docker compose build

download-model:
	@echo "Downloading Stable Diffusion v1.5 model..."
	@mkdir -p webui/models/Stable-diffusion
	@if [ ! -f webui/models/Stable-diffusion/v1-5-pruned-emaonly.safetensors ]; then \
		wget -P webui/models/Stable-diffusion/ \
			https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors; \
		echo "Model downloaded successfully!"; \
	else \
		echo "Model already exists. Skipping download."; \
	fi

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

logs-webui:
	docker compose logs -f webui

logs-kohya:
	docker compose logs -f kohya

clean:
	docker compose down -v
	rm -rf webui kohya lora
	@echo "Cleaned up!"

clean-images:
	docker compose down -v --rmi local
	rm -rf webui kohya lora kohya_ss_src
	@echo "Cleaned up including Docker images!"
