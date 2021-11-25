import connexion

from prometheus_flask_exporter import ConnexionPrometheusMetrics

application = connexion.FlaskApp(__name__, specification_dir='spec/')
application.add_api('openapi.yaml')

metrics = ConnexionPrometheusMetrics(application)

if __name__ == '__main__':
    application.run()
