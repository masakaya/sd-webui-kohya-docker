.PHONY: setup up down logs logs-webui logs-kohya clean

setup:
	mkdir -p webui/models/Stable-diffusion
	mkdir -p webui/models/Lora
	mkdir -p webui/outputs
	mkdir -p kohya/training
	mkdir -p kohya/outputs
	mkdir -p lora
	@echo "Setup complete!"

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
