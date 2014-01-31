watch -n 5 'echo "$(hostname) - HTTPD: $(ps -ef | grep httpd | wc -l)   Speedy: $(ps -ef | grep speedy | wc -l)"'
