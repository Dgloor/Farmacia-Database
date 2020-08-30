from database import DataBase
import datetime


class Sistema:
    m = """\n-- SISTEMA FARMACIA --\n 1. Ingreso Bodega\n 2. Egreso Bodega\n 3. Salir"""

    def __init__(self, host, user, password, db_name):
        self.op = ''
        self.options = {'1': self.ingreso, '2': self.egreso, '3': self.exit}
        self.db = -1
        try:
            self.db = DataBase(host, user, password, db_name)
        except ValueError:
            print("<X> Conexión a base no establecida <X>")

    def menu(self):
        while self.op != '3' and self.db != -1:
            self.validar_op()
            self.options[self.op]()

    def validar_op(self):
        self.op = 0
        while self.op not in self.options.keys():
            print(self.m)
            self.op = input("Ingrese una opción: ")
            if self.op not in self.options.keys():
                print("\n<x> Opción incorrecta, intente de nuevo. <x>")

    def ingreso(self):
        print("\n-- Ingreso Bodega --")
        solicitante = self.select_emp('Admins Bodega')
        bodeguero = self.select_emp('Bodegueros')
        justificativo = input("\nJustificativo: ")
        medicamentos = self.select_meds()
        if medicamentos != {}:
            data = {'solicitante': solicitante, 'bodeguero': bodeguero,
                    'justificativo': justificativo, 'medicamentos': medicamentos}

            print("\nProcesando transacción...")
            self.db.ingreso(data)

    def egreso(self):
        print("\n-- Egreso Bodega -- ")
        bodeguero = self.select_emp('Bodegueros')
        justificativo = input("\nJustificativo: ")
        farmacia = self.select_farmacia()
        n_serie = self.select_unidad_med(bodeguero)
        cantidad = self.select_cantidad()

        data = {'bodeguero': bodeguero, 'justificativo': justificativo,
                'farmacia': farmacia, 'n_serie': n_serie,
                'cantidad': cantidad}

        print("\nProcesando transacción...")
        self.db.egreso(data)

    @staticmethod
    def select_cantidad() -> int:
        cantidad = ""
        valido = False
        while not valido:
            cantidad = input("Cantidad: ")
            if cantidad.isdigit():
                cantidad = int(cantidad)
                valido = True
            else:
                print("\n<x> Cantidad inválida, intente de nuevo <x>")

        return cantidad

    def select_emp(self, tipo) -> str:
        emps = self.db.get_empleados(tipo)
        print(f'\n====== {tipo.upper()} ======')
        print(f'n | Cedula {" " * 4}| Nombre')
        print('-' * 36)
        for i, info_emp in enumerate(emps):
            cedula, nombre = info_emp
            print(str(i + 1) + ' | ' + cedula + ' | ' + nombre)

        t = 'Solicitante'
        if tipo == 'Bodegueros':
            t = 'Bodeguero'

        pos = ""
        valido = False
        while not valido:
            pos = input(f"{t} (n): ")
            if pos.isdigit():
                pos = int(pos)
                if 0 < pos < len(emps) + 1:
                    valido = True
                else:
                    print("\n<x> Fuera de rango, intente de nuevo. <x>")
            else:
                print("\n<x> Error, intente de nuevo <x>")

        return emps[pos - 1][0]

    def select_farmacia(self) -> int:
        farmacias = self.db.get_farmacias()
        print('\n== Farmacias ==')
        print(f'n | Nombre')
        print('-' * 18)
        for info in farmacias:
            i_d, nombre = info
            print(str(i_d) + ' | ' + nombre)

        pos = ""
        valido = False
        while not valido:
            pos = input("Farmacia destino (n): ")
            if pos.isdigit():
                pos = int(pos)
                if 0 < pos < len(farmacias):
                    valido = True
                else:
                    print("\n<x> Fuera de rango, intente de nuevo. <x>")
            else:
                print("\n<x> Error, intente de nuevo <x>")

        return pos

    def select_meds(self) -> dict:
        medicamentos = {}
        m = []
        meds = self.db.get_medicamentos()
        print('\n== CATALOGO MEDICAMENTOS ==')
        print(f'n | Nombre')
        print('-' * 20)
        for me in meds:
            id_med, nombre = me
            m.append(id_med)
            row = f"{str(id_med)} | {nombre}"
            print(row)

        id_med = -1
        while id_med != 0:
            id_med = self.select_id_med(m)
            if id_med != 0:
                n_serie = self.select_n_serie()
                fecha_cad = self.select_fecha()
                cantidad = self.select_cantidad()

                medicamentos[id_med] = {'n_serie': n_serie, 'cantidad': cantidad,
                                        'fecha_cad': fecha_cad}

        return medicamentos

    @staticmethod
    def select_id_med(meds) -> int:
        id_med = ""
        valido = False

        while not valido:
            id_med = input("\nId medicamento (n), *(0 para continuar)*: ")
            if id_med.isdigit():
                id_med = int(id_med)
                if id_med in meds or id_med == 0:
                    valido = True
                else:
                    print("\n<x> Id. medicamento inexistente, intente de nuevo <x>")
            else:
                print("\n<x> N. medicamento inválido , intente de nuevo <x>")

        return id_med

    @staticmethod
    def select_fecha() -> datetime:
        valido = False
        fecha_cad = None
        while not valido:
            try:
                f = input("Fecha de caducidad (yyyy-mm-dd): ").split('-')
                fecha_cad = datetime.date(int(f[0]), int(f[1]), int(f[2]))
                valido = True
            except Exception:
                print("\n<x> Fecha inválida, intente de nuevo. <x>")

        return fecha_cad

    @staticmethod
    def select_n_serie() -> int:
        n_serie = ""
        valido = False
        while not valido:
            n_serie = input("Número de Serie (6 cifras): ")
            if n_serie.isdigit() and len(n_serie) == 6:
                n_serie = int(n_serie)
                valido = True
            else:
                print("\n<x> No. serie inválido, intente de nuevo <x>")

        return n_serie

    def select_unidad_med(self, id_bodeguero) -> int:
        u_meds = self.db.get_unidad_medicamentos(id_bodeguero)
        m = []
        print('\n== CATALOGO UNIDAD MEDICAMENTOS ==')
        print(f'N. Serie | {"Nombre":^13} | {"Caducidad":^10} | {"Stock bodega":^10}')
        print('-' * 53)
        for u_m in u_meds:
            n_serie, nombre, fecha_cad, stock = u_m
            m.append(n_serie)
            row = f"{str(n_serie):<8} | {nombre:<13} | {fecha_cad} | {stock:^10}"
            print(row)

        print()
        n_serie = ""
        valido = False
        while not valido:
            n_serie = input("No de serie: ")
            if n_serie.isdigit():
                n_serie = int(n_serie)
                if n_serie in m:
                    valido = True
                else:
                    print("\n<x> No. Serie inexistente, intente de nuevo. <x>")
            else:
                print("\n<x> Error, intente de nuevo <x>")

        return n_serie

    @staticmethod
    def exit():
        print("\n</> Sistema Finalizado </>")
