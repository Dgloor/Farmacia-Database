import pip
from sistema import Sistema

# Database config
host = 'localhost'
user = 'root'
password = ''
db_name = 'G1'

if __name__ == '__main__':
    try:
        pip.main(['install', 'PyMySQL'])
    except Exception as e:
        print(e)

    s = Sistema(host, user, password, db_name)
    s.menu()
