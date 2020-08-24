from sistema import Sistema

host = 'localhost'
user = 'root'
password = ''
db_name = 'G1'

if __name__ == '__main__':
    s = Sistema(host, user, password, db_name)
    s.menu()
