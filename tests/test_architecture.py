from pathlib import Path
import yaml
ROOT=Path(__file__).parents[1]
def compose():return yaml.safe_load((ROOT/'docker-compose.yml').read_text())
def test_only_reverse_proxy_publishes_a_host_port():
 services=compose()['services'];published=[name for name,value in services.items() if value.get('ports')]
 assert published==['proxy'];assert services['proxy']['ports']==['127.0.0.1:8443:8443']
def test_network_membership_enforces_no_direct_public_to_data_path():
 services=compose()['services'];assert services['proxy']['networks']==['public','application'];assert services['app']['networks']==['application','data'];assert services['database']['networks']==['data']
 assert compose()['networks']['application']['internal'] is True;assert compose()['networks']['data']['internal'] is True
def test_runtime_hardening_and_healthchecks_cover_online_services():
 for name in ('proxy','app'):
  service=compose()['services'][name];assert service['read_only'] is True;assert 'no-new-privileges:true' in service['security_opt'];assert service['cap_drop']==['ALL'];assert 'healthcheck' in service
def test_secrets_use_file_mounts_not_literal_credentials():
 text=(ROOT/'docker-compose.yml').read_text();assert 'POSTGRES_PASSWORD_FILE' in text;assert 'DB_PASSWORD_FILE' in text;assert 'POSTGRES_PASSWORD:' not in text;assert 'DB_PASSWORD:' not in text;assert '.secrets/' in text
def test_proxy_tls_and_security_headers_are_explicit():
 config=(ROOT/'nginx/default.conf').read_text();assert 'listen 8443 ssl' in config;assert 'TLSv1.2 TLSv1.3' in config;assert 'Strict-Transport-Security' in config;assert 'proxy_connect_timeout' in config
def test_terraform_policy_has_default_denials_and_native_tests():
 network=(ROOT/'terraform/modules/network/main.tf').read_text();tests=(ROOT/'terraform/tests/policy.tftest.hcl').read_text();assert 'internet_to_data' in network;assert 'public_to_data' in network;assert 'database_exposure' in tests;assert 'service_policy_violations' in tests
def test_operational_scripts_fail_fast_and_backup_is_explicit():
 for name in ('bootstrap-local.sh','validate.sh','smoke-test.sh','backup.sh'):assert 'set -eu' in (ROOT/'scripts'/name).read_text()
 assert 'pg_dump' in (ROOT/'docker-compose.yml').read_text()
