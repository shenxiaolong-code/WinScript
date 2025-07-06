

import inspect
from urllib.parse import urlparse, parse_qs
from http.server import BaseHTTPRequestHandler, HTTPServer
import os
import sys
import logging

# print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
print(f'cmd: python {" ".join(sys.argv)}\r\n\x1b[30m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\x1b[0m')
print(f'\033[92mrun \033[33m{os.path.join(os.path.dirname(os.path.dirname(__file__)), "kill_port_8000_process.sh")}\033[92m if hang\033[0m')

logging.basicConfig(level=logging.INFO)

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # logging.info ("start to process request")
        print(f'\r\n\x1b[30m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[91m\r\nRecevied remote cmd\r\n\033[33mstart to process request ... \x1b[0m\r\n')

        # 假设 URL 路径是 /openfile?path=<file_path>
        # 解析 URL 并获取查询参数
        parsed_url = urlparse(self.path)
        query_params = parse_qs(parsed_url.query)

        # 检查 'path' 参数是否存在于查询参数中
        if 'path' in query_params:
            # 获取 'path' 参数的值，注意它是一个列表
            file_path = query_params['path'][0]
            # 对文件路径进行 URL 解码
            file_path = os.path.normpath(file_path)

            # 使用 Visual Studio Code 打开文件
            os.system(f"cursor --goto {file_path}")

            # 发送 HTTP 响应
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"async_open_file_on_303 :\033[94m " + file_path.encode('utf-8')  + "\r\n\033[33m".encode('utf-8') )
            print("Done to process request")
        else:
            # 如果 'path' 参数不存在，发送 HTTP 400 响应
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b"Bad request: 'path' parameter is missing")
            print("Failed to process request: 'path' parameter is missing")


httpd = HTTPServer(('0.0.0.0', 8000), RequestHandler)
logging.info ("server is started")
httpd.serve_forever()
logging.info ("serve exit !")

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m\r\n\r\n')

# if port is used by previous run , kill the process
# lsof -i:8000
# kill -9 PID
