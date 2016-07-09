import os.path

BASE_DIR = os.path.dirname(os.path.realpath(__file__))

DATABASES = {
    'default': {
        'migrations_dir': os.path.join(BASE_DIR, "migrations"),
        'engine': 'postgres',
        'dsn': 'host=localhost dbname=pomf_dev user=croncat sslmode=disable',
    }
}

LOG_FILE = os.path.join(BASE_DIR, "migration.log")
