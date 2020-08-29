from sistema import Sistema

# Database config
host = 'localhost'
user = 'root'
password = 'JorgeVulgarin15'
db_name = 'G1'

if __name__ == '__main__':
    s = Sistema(host, user, password, db_name)
    s.menu()
