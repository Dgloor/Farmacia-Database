import pymysql
import datetime


class DataBase:

    def __init__(self, host, user, password, db_name):
        try:
            self.connection = pymysql.connect(host=host,
                                              user=user,
                                              password=password,
                                              db=db_name,
                                              charset='utf8')
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

    def ingreso(self, data): #complex
        try:
            now = datetime.date.today()
            self.connection.begin()
            sql = f"""
                INSERT INTO registro(id_bodeguero, fecha_solicitud, justificativo)
                VALUES('{data['bodeguero']}', STR_TO_DATE('{now}', '%Y-%m-%d'), '{data['justificativo']}');
            """
            self.cursor.execute(sql)

            self.cursor.execute("select max(id_registro) from registro")
            id_registro = self.cursor.fetchone()[0]

            sql = f"""
                INSERT INTO ingreso(id_ingreso, id_admin_bodega)
                VALUES({id_registro}, '{data['solicitante']}')
             """
            self.cursor.execute(sql)

            self.cursor.execute(f"SELECT id_bodega FROM Bodeguero WHERE id_bodeguero = '{data['bodeguero']}'")
            id_bodega = self.cursor.fetchone()[0]

            for id_med, info in data['medicamentos'].items():
                n_serie, cantidad, fecha_cad = list(info.values())

                sql = f"""
                   INSERT INTO Unidad_Medicamento(id_medicamento, numero_serie, fecha_caducidad)
                   VALUES({id_med}, {n_serie}, STR_TO_DATE('{fecha_cad}', '%Y-%m-%d'));
                """
                self.cursor.execute(sql)
                sql = f"""
                   INSERT INTO ingreso_bodega_unidad(id_ingreso, numero_serie, cantidad)
                   VALUES ({id_registro}, {n_serie}, {cantidad});
                """
                self.cursor.execute(sql)
                sql = f"""
                   INSERT INTO Stock_Bodega(numero_serie, id_bodega, stock_actual)
                   VALUES( {n_serie}, {id_bodega}, {cantidad});
                """
                self.cursor.execute(sql)

            self.connection.commit()
            print("</> Unidades ingresadas con éxito </>")

        except Exception as e:
            self.connection.rollback()
            print("<x> Transacción fallida <x>")
            print(e)

    def egreso(self, data):
        sql = f"""
        CALL RegistrarEgreso (
        '{data['bodeguero']}', '{data['justificativo']}',
        {data['farmacia']},  {data['n_serie']},
        {data['cantidad']} ,  @exitoso
        );
        """
        self.cursor.execute(sql)
        self.cursor.execute("select @exitoso;")
        exitoso = self.cursor.fetchone()[0]
        if exitoso:
            print("</> Unidades enviadas a farmacia con éxito </>")
        else:
            print("<X> Stock insuficiente, intente nuevamente. <X>")
