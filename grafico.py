import pandas as pd
import matplotlib.pyplot as plt

Tabela = pd.read_csv("tempoPorPrimo.txt", sep=" ")

print(Tabela)

ax = plt.gca()

Tabela.reset_index().plot(x='TIMES', y='index')
plt.show()