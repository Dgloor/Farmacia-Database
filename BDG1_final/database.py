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
        SELECT um.numero_serie, m.nombre, um.fecha_caducidad, stock_bodega.restante
        FROM (
            SELECT i.numero_serie, i.cantidad - IFNULL(e.cantidad, 0) as restante
            FROM (
                SELECT ibu.numero_serie, ibu.cantidad FROM ingreso i
                INNER JOIN (ingreso_bodega_unidad ibu, registro r)
                ON(i.id_ingreso = ibu.id_ingreso AND r.id_registro = i.id_ingreso)
                WHERE r.id_bodeguero = '{id_bodeguero}'
            ) i
            LEFT JOIN (
                SELECT ebu.numero_serie, ebu.cantidad
                FROM egreso e
                inner join(egreso_bodega_unidad ebu, registro r)
                ON(e.id_egreso = ebu.id_egreso and r.id_registro = e.id_egreso)
                WHERE r.id_bodeguero = '{id_bodeguero}'
            ) e
            ON i.numero_serie = e.numero_serie
            GROUP BY numero_serie
        ) stock_bodega
        INNER JOIN(medicamento m, unidad_medicamento um)
        ON( stock_bodega.numero_serie = um.numero_serie
            and um.id_medicamento = m.id_medicamento
        ) order by m.nombre asc
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
        CALL registrar_ingreso (
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
