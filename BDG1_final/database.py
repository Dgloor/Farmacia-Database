import pymysql


class DataBase:
    def __init__(self, host, user, password, db_name):
        try:
            self.connection = pymysql.connect(
                host=host,
                user=user,
                password=password,
                db=db_name
            )
            self.cursor = self.connection.cursor()
            print("</> Conexión establecida con éxito. </>")

        except pymysql.DatabaseError:
            raise ValueError("Base no conectada")

    def test_clientes(self):
        sql = 'SELECT * FROM cliente'
        self.cursor.execute(sql)
        clients = self.cursor.fetchall()

        if len(clients) != 0:
            for client in clients:
                print(f'Client id: {client[0]}')
        else:
            print("</> Tabla clientes vacía </>")

    def get_medicamentos(self):
        sql = """SELECT DISTINCT m.nombre,
        m.id_medicamento, um.fecha_caducidad
        FROM medicamento m 
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
