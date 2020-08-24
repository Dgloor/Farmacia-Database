from database import DataBase
from collections import namedtuple


class Sistema:
    m = """\n-- SISTEMA FARMACIA --\n 1. Ingreso Bodega\n 2. Egreso Bodega\n 3. Salir\n 4. test"""

    def __init__(self, host, user, password, db_name):
        self.op = ''
        self.options = {'1': self.ingreso, '2': self.egreso, '3': self.exit, '4': self.test}
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

        solicitante = input("Solicitante: ")
        bodeguero = input("Bodeguero: ")
        justificativo = input("Justificativo: ")
        medicina = input("Medicina: ")
        n_serie = input("Número de Serie: ")
        fecha_cad = input("Fecha de caducidad: ")
        cantidad = input("Cantidad: ")

        data = self.validar_ingreso(solicitante=solicitante, bodeguero=bodeguero,
                                    justificativo=justificativo, medicina=medicina,
                                    n_serie=n_serie, fecha_cad=fecha_cad,
                                    cantidad=cantidad)
        if data != -1:
            print("\n</> Procesando transacción. </>")
            print(data)
        else:
            print("\n<X> Datos incorrectos, intente nuevamente <X>")

    def egreso(self):
        print("\n-- Egreso Bodega -- ")

        bodeguero = input("Bodeguero: ")
        justificativo = input("Justificativo: ")
        farmacia = input("Farmacia destino: ")
        n_serie = input("N. serie medicamento: ")
        cantidad = input("Cantidad: ")

        data = self.validar_egreso(bodeguero=bodeguero, justificativo=justificativo,
                                   farmacia=farmacia, n_serie=n_serie,
                                   cantidad=cantidad)
        if data != -1:
            print("\n</> Procesando transacción. </>")
            print(data)
        else:
            print("\n<X> Datos incorrectos, intente nuevamente <X>")

    @staticmethod
    def validar_ingreso(**kwargs):
        for dato in kwargs.values():
            if dato == '':
                return -1
        return kwargs

    @staticmethod
    def validar_egreso(**kwargs):
        for dato in kwargs.values():
            if dato == '':
                return -1
        return kwargs

    def mostrar_meds(self):
        meds = self.db.get_medicamentos()
        print(meds)

    def mostrar_farmacias(self):
        pass

    def mostrar_admins(self):
        pass

    def mostrar_bodegueros(self):
        pass

    @staticmethod
    def exit():
        print("\n</> Sistema Finalizado </>")

    def test(self):
        self.mostrar_meds()

