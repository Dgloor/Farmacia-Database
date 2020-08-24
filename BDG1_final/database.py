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
        sql = """
        SELECT DISTINCT um.numero_serie, m.nombre, um.fecha_caducidad
        FROM medicamento m 
        inner join unidad_medicamento um on 
        m.id_medicamento = um.id_medicamento
        """
        self.cursor.execute(sql)
        meds = self.cursor.fetchall()
        return meds

    def get_farmacias(self):
        sql = """
        SELECT id_farmacia, nombre from farmacia;
        """
        self.cursor.execute(sql)
        farmacias = self.cursor.fetchall()
        return farmacias

    def get_empleados(self, tipo):
        sql = """
            SELECT cedula, concat(p.nombre, ' ', apellido_paterno)
            FROM persona p INNER JOIN 
        """
        tabla = ''
        columna = ''

        if tipo == 'Bodegueros':
            tabla = 'bodeguero'
            columna = 'id_bodeguero'
        elif tipo == 'Admins Bodega':
            tabla = 'bodega'
            columna = 'id_admin_bodega'

        sql += f"{tabla} b ON(p.cedula = b.{columna})"

        self.cursor.execute(sql)
        empleados = self.cursor.fetchall()
        return empleados

    def ingreso(self, **kwargs):
        sql = ''
        print(kwargs)

    def egreso(self, **kwargs):
        sql = ''
        print(kwargs)
