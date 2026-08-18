from http.server import BaseHTTPRequestHandler,HTTPServer
import json
class H(BaseHTTPRequestHandler):
 def do_GET(self):
  body=json.dumps({"status":"ok","service":"cloudforge-app"}).encode() if self.path=="/health" else b'{"message":"CloudForge reference application"}'
  self.send_response(200);self.send_header("Content-Type","application/json");self.end_headers();self.wfile.write(body)
HTTPServer(("0.0.0.0",8080),H).serve_forever()
