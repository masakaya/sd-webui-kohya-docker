.PHONY: setup download-model up down logs logs-webui logs-kohya clean

setup:
	mkdir -p webui/models/Stable-diffusion
	mkdir -p webui/models/Lora
	mkdir -p webui/outputs
	mkdir -p kohya/training
	mkdir -p kohya/outputs
	mkdir -p lora
	@echo "Setup complete!"

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
