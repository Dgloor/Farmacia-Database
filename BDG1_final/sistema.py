from database import DataBase


class Sistema:
    m = """\n-- SISTEMA FARMACIA --\n 1. Ingreso Bodega\n 2. Egreso Bodega\n 3. Salir"""

    def __init__(self):
        self.op = ''
        self.options = {'1': self.ingreso, '2': self.egreso, '3': self.exit}
        self.db = DataBase()

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

        meds = self.db.getMedicamentos()
        self.mostrar_meds(meds)

        # solicitante = input("Solicitante: ")
        # bodeguero = input("Bodeguero: ")
        # justificativo = input("Justificativo: ")
        # medicina = input("Medicina: ")
        # n_serie = input("Número de Serie: ")
        # fecha_cad = input("Fecha de caducidad: ")
        # cantidad = input("Cantidad: ")
        # self.db.ingreso(solicitante=solicitante, bodeguero=bodeguero, justificativo=justificativo, medicina=medicina,
        #                 n_serie=n_serie, fecha_cad=fecha_cad, cantidad=cantidad)

    def egreso(self):
        print("\n-- Egreso Bodega -- ")
        bodeguero = input("Bodeguero: ")
        justificativo = input("Justificativo: ")
        farmacia = input("Farmacia destino: ")
        n_serie = input("N. serie medicamento: ")
        cantidad = input("Cantidad: ")
        self.db.egreso(bodeguero=bodeguero, justificativo=justificativo, farmacia=farmacia, n_serie=n_serie,
                       cantidad=cantidad)

    def mostrar_meds(self, medicamentos):
        for infoMed in medicamentos:
            print(infoMed)


    @staticmethod
    def exit():
        print("\n</> Sistema Finalizado </>")
