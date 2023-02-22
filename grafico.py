import pandas as pd
import matplotlib.pyplot as plt

Tabela = pd.read_csv("tempoPorPrimo.txt", sep=" ")
Tabela2 = pd.read_csv("tempoPorPrimoOMP.txt", sep=" ")
print (len(Tabela.index))
print (len(Tabela2.index))

Tabela["TIMES"] = ((Tabela["TIMES"].astype(int))/1000)#.astype(str)
Tabela2["TIMES"] = ((Tabela2["TIMES"].astype(int))/1000)#.astype(str)

Tabela.reset_index().plot(x='TIMES', y='index',label='Sequencial',xlabel="milissegundos", ylabel= "números de primos encontrados" )
Tabela2.reset_index().plot(x='TIMES', y='index',label='OMP',xlabel="milissegundos", ylabel= "números de primos encontrados")

plt.show()
