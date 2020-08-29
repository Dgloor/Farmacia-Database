def tieneLlave(linea):
    condicion1 = linea.find("{") != -1
    condicion2 = linea.find("}") != -1
    if condicion1:
        return 1
    if condicion2:
        return -1
    return 0


def esDeclaracion(linea0):
    if tieneLlave(linea0) == 1:
        return True
    return False


def extract(line):
    line = line.replace(" ", "")
    nombre_tipo = line.split(",")
    tipado = dict()
    for n_t in nombre_tipo:

        nombre, tipo = n_t.split(":")
        tipado[nombre] = tipo
    return tipado


def isData(tipado, condicion):
    return len(tipado.keys()) and not condicion


def makeQuery(tablename, rows, value):
    query = "INSERT INTO " + tablename + " ("
    for k in rows.keys():
        query += k
        query += ","
    query = query[:-1]
    query += ") VALUES("
    query += value
    query += ")"
    return query


def columnString(line):

    line = line.replace(" ", "")
    nombre_tipo = line.split(",")
    tipes = []
    names = []

    for n_t in nombre_tipo:

        nombre, tipo = n_t.split(":")
        names.append(nombre)
        tipes.append(tipo)
    names = ",".join(names)
    names = "(" + names + ")"
    return names, tipes


def getValores(line, tipos):
    if "date" in tipos:
        pos = tipos.index("date")
        segmentos = line.split(",")
        segmentos[
            pos] = "STR_TO_DATE(\'" + segmentos[pos] + "\', \'%Y-%m-%d\')"
        line = ",".join(segmentos)
    return "VALUES(" + line + ");"


def parse(filename):
    f = open(filename)

    lines = f.readlines()
    f.close()
    f = open("in.sql", "w")
    tipado = dict()
    tipo = ""
    lineaAnterior = ""
    tablename = ""
    for line in lines:
        line = line.replace("\n", "")
        line = line.replace("\t", "")
        if line == "":
            lineaAnterior = ""
            continue

        isDeclaration = esDeclaracion(lineaAnterior)
        if tieneLlave(line) == -1:
            tipado = dict()
        if isDeclaration:
            tipado = extract(line)
            nombres, tipos = columnString(line)
        seDebeLeer = isData(tipado, isDeclaration)
        if seDebeLeer:
            valores = getValores(line, tipos)
            query = "INSERT INTO " + tablename + " " + nombres + " " + valores
            f.write(query + "\n")
            print(query)
        elif (isDeclaration == False and tieneLlave(line) == 1):

            tablename = line.split("=")[0]
            #print(tablename)

        lineaAnterior = line


if __name__ == "__main__":
    parse("gist.txt")
