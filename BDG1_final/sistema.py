from database import DataBase
import datetime


class Sistema:
    m = """\n-- SISTEMA FARMACIA --\n 1. Ingreso Bodega\n 2. Egreso Bodega\n 3. Salir"""

    def __init__(self, host, user, password, db_name):
        self.op = ''
        self.options = {'1': self.ingreso, '2': self.egreso, '3': self.exit}
        self.db = -1
        try:
            pass
            self.db = DataBase(host, user, password, db_name)
        except ValueError:
            print("<X> Conexión a base no establecida <X>")

    def validar_op(self):
        self.op = 0
        while self.op not in self.options.keys():
            print(self.m)
            self.op = input("Ingrese una opción: ")
            if self.op not in self.options.keys():
                print("<x> Opción incorrecta, intente de nuevo. <x>")

    def menu(self):
        while self.op != '3':
            self.validar_op()
            self.options[self.op]()

    def ingreso(self):
        print("\n-- Ingreso Bodega --")
        solicitante = self.select_emp('Admins Bodega')
        bodeguero = self.select_emp('Bodegueros')
        justificativo = input("Justificativo: ")
        medicamento = self.select_med()
        n_serie = int(input("Número de Serie (6 cifras): "))
        f = input("Fecha de caducidad (yyyy-mm-dd): ").split('-')
        fecha_cad = datetime.date(int(f[0]), int(f[1]), int(f[2]))
        cantidad = int(input("Cantidad: "))

        data = self.validar_ingreso(solicitante=solicitante, bodeguero=bodeguero,
                                    justificativo=justificativo, medicamento=medicamento,
                                    n_serie=n_serie, fecha_cad=fecha_cad,
                                    cantidad=cantidad)
        if data != -1:
            print("\nProcesando transacción...")
            self.db.ingreso(data)
        else:
            print("\n<X> Datos incorrectos, intente nuevamente <X>")

    def egreso(self):
        print("\n-- Egreso Bodega -- ")
        bodeguero = self.select_emp('Bodegueros')
        justificativo = input("Justificativo: ")
        farmacia = self.select_farmacia()
        n_serie = self.select_unidad_med(bodeguero)
        cantidad = int(input("Cantidad: "))

        data = self.validar_egreso(bodeguero=bodeguero, justificativo=justificativo,
                                   farmacia=farmacia, n_serie=n_serie,
                                   cantidad=cantidad)
        if data != -1:
            print("\nProcesando transacción...")
            self.db.egreso(data)
        else:
            print("\n<X> Datos incorrectos, intente nuevamente <X>")

    def select_emp(self, tipo) -> str:
        emps = self.db.get_empleados(tipo)
        print(f'\n== {tipo.upper()} ==')
        print(f'n | Cedula {" " * 4}| Nombre')
        print('-' * 36)
        for i, info_emp in enumerate(emps):
            cedula, nombre = info_emp
            print(str(i + 1) + ' | ' + cedula + ' | ' + nombre)

        t = 'Solicitante'
        if tipo == 'Bodegueros':
            t = 'Bodeguero'
        pos = int(input(f"{t} (n): "))

        return emps[pos - 1][0]

    def select_farmacia(self) -> int:
        farmacias = self.db.get_farmacias()
        print('\n== Farmacias ==')
        print(f'n | Nombre')
        print('-' * 18)
        for info in farmacias:
            i_d, nombre = info
            print(str(i_d) + ' | ' + nombre)

        pos = int(input("Farmacia destino (n): "))
        return pos

    def select_med(self) -> int:
        meds = self.db.get_medicamentos()
        print('\n== CATALOGO MEDICAMENTOS ==')
        print(f'n | Nombre')
        print('-' * 20)
        for m in meds:
            id_med, nombre = m
            row = f"{str(id_med)} | {nombre}"
            print(row)

        pos = int(input("Medicamento (n): "))
        return pos

    def select_unidad_med(self, id_bodeguero) -> int:
        u_meds = self.db.get_unidad_medicamentos(id_bodeguero)
        print('\n== CATALOGO UNIDAD MEDICAMENTOS ==')
        print(f'N. Serie | {"Nombre":^13} | {"Caducidad":^10} | {"Stock bodega":^10}')
        print('-' * 53)
        for u_m in u_meds:
            n_serie, nombre, fecha_cad, stock = u_m
            row = f"{str(n_serie):<8} | {nombre:<13} | {fecha_cad} | {stock:^10}"
            print(row)

        n_serie = int(input("Numero de serie medicamento: "))
        return n_serie

    @staticmethod
    def validar_ingreso(**kwargs) -> [dict, int]:
        for dato in kwargs.values():
            if dato == '':
                return -1
        return kwargs

    @staticmethod
    def validar_egreso(**kwargs) -> [dict, int]:
        for dato in kwargs.values():
            if dato == '':
                return -1
        return kwargs



    @staticmethod
    def exit():
        print("\n</> Sistema Finalizado </>")


