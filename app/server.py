"""Small dependency-free service used to prove infrastructure behavior."""
from http.server import BaseHTTPRequestHandler,ThreadingHTTPServer
import json,logging,os,signal,time,uuid
logging.basicConfig(level=os.getenv('LOG_LEVEL','INFO'),format='%(message)s')
started=time.time();ready=True
class Handler(BaseHTTPRequestHandler):
 server_version='CloudForgeApp/1.0';sys_version=''
 def log_message(self,fmt,*args):logging.info(json.dumps({'event':'http_request','method':self.command,'path':self.path,'client':self.client_address[0],'request_id':getattr(self,'request_id',None)}))
 def send_json(self,status,payload):
  body=json.dumps(payload).encode();self.send_response(status);self.send_header('Content-Type','application/json');self.send_header('Content-Length',str(len(body)));self.send_header('X-Request-ID',self.request_id);self.end_headers();self.wfile.write(body)
 def do_GET(self):
  self.request_id=self.headers.get('X-Request-ID') or str(uuid.uuid4())
  if self.path=='/health/live':return self.send_json(200,{'status':'alive','uptime_seconds':round(time.time()-started,2)})
  if self.path=='/health/ready':return self.send_json(200 if ready else 503,{'status':'ready' if ready else 'draining'})
  if self.path=='/':return self.send_json(200,{'service':'cloudforge-reference-app','trust_zone':'application','request_id':self.request_id})
  self.send_json(404,{'error':'not_found','request_id':self.request_id})
server=ThreadingHTTPServer(('0.0.0.0',8080),Handler)
def drain(*_):
 global ready;ready=False;logging.info(json.dumps({'event':'shutdown_started'}));server.shutdown()
signal.signal(signal.SIGTERM,drain)
logging.info(json.dumps({'event':'service_started','port':8080}));server.serve_forever()
