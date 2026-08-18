from pathlib import Path
def test_segmentation_and_secret_pattern():
 compose=Path("docker-compose.yml").read_text();assert "internal: true" in compose and "POSTGRES_PASSWORD_FILE" in compose and "ports:" in compose
def test_only_proxy_publishes_port():
 text=Path("docker-compose.yml").read_text();assert text.count("ports:")==1
