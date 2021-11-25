import multiprocessing
import ssl

bind = '0.0.0.0:8443'

workers = 1
worker_temp_dir = '/dev/shm'
threads = multiprocessing.cpu_count() * 2

accesslog = '-'
errorlog = '-'

cert_reqs = ssl.CERT_OPTIONAL
ca_certs = '/var/run/secrets/svid/svid-bundle.pem'
certfile = '/var/run/secrets/svid/svid.pem'
keyfile = '/var/run/secrets/svid/svid-key.pem'
