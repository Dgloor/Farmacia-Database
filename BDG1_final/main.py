# import pip
# pip.main(['install', 'package_name'])

class Sistema:
    m = """\n-- SISTEMA FARMACIA --\n 1. Ingreso Bodega\n 2. Egreso Bodega\n 3. Salir"""

    def __init__(self):
        self.op = ''
        self.options = {'1': self.ingreso, '2': self.egreso, '3': self.exit}

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

    @staticmethod
    def ingreso():
        print("Ingreso Bodega")

    @staticmethod
    def egreso():
        print("Egreso Bodega")

    @staticmethod
    def exit():
        print("\n</> Sistema Finalizado </>")


if __name__ == '__main__':
    s = Sistema()
    s.menu()
