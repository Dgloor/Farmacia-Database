import pymysql


class DataBase:
    def __init__(self):
        self.connection = pymysql.connect(
            host='localhost',
            user='root',
            password='',
            db='G1'
        )
        self.cursor = self.connection.cursor()
        print("</> Conexión establecida con éxito </>")

    def test_clientes(self):
        sql = 'SELECT * FROM cliente'
        self.cursor.execute(sql)
        clients = self.cursor.fetchall()

        if len(clients) != 0:
            for client in clients:
                print(f'Client id: {client[0]}')
        else:
            print("</> Tabla clientes vacía </>")

    def getMedicamentos(self):
        sql = """SELECT DISTINCT nombre FROM medicamento m 
        inner join unidad_medicamento um on 
        m.id_medicamento = um.id_medicamento
        """
        self.cursor.execute(sql)
        meds = self.cursor.fetchall()
        return meds

    def ingreso(self, **kwargs):
        sql = ''
        print(kwargs)

    def egreso(self, **kwargs):
        sql = ''
        print(kwargs)
