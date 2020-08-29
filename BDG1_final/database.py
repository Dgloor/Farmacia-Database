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

    def get_medicamentos(self):
        sql = """
        SELECT id_medicamento, nombre
        FROM medicamento;
        """
        self.cursor.execute(sql)
        meds = self.cursor.fetchall()
        return meds

    def get_unidad_medicamentos(self, id_bodeguero):
        sql = f"""
        SELECT sb.numero_serie, m.nombre, um.fecha_caducidad, sb.stock_actual
        FROM stock_bodega sb
        INNER JOIN (unidad_medicamento um, medicamento m)
        ON (sb.numero_serie = um.numero_serie and m.id_medicamento = um.id_medicamento)
        WHERE sb.id_bodega = (
            SELECT b.id_bodega FROM bodega b INNER JOIN bodeguero bo 
            ON b.id_bodega = bo.id_bodega 
            WHERE bo.id_bodeguero = '{id_bodeguero}'
            )
        order by m.nombre asc;
        """
        self.cursor.execute(sql)
        u_meds = self.cursor.fetchall()
        return u_meds

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

    def ingreso(self, data):
        sql = f"""
        CALL registrarIngreso (
        '{data['solicitante']}', '{data['bodeguero']}',
        '{data['justificativo']}', {data['medicamento']},
        {data['n_serie']}, {data['fecha_cad']}, 
        {data['cantidad']}
        );"""

        self.cursor.execute(sql)
        print("</> Unidades ingresadas con éxito </>")

    def egreso(self, data):
        sql = f"""
        """
        self.cursor.execute(sql)
        print("</> Unidades enviadas a farmacia con éxito </>")
