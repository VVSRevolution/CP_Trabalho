#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

# define VAL_INI 10 //valor inicial
# define LIM_SUP 200000 //limite superior (até onde vamos para calcular os numeros primos)

int main(){


    int i, j, cont;
    long long int p, q; //variaveis para armazenar dois primos (para gerar a chave publica)
    long long int n; //Multiplicação de p e q
    long long int div, numero, phi_n,e,d,tam;
    long long int *primo;
    cudaMallocManaged(&primo, 100000*sizeof(long long int)); //vetor q vai aramazenar todos os numero primos

    FILE *temporPrimo;
    temporPrimo = fopen("tempoPorPrimo.txt", "a");
    

    //iniciamos nosso vetor de primos com alguns valores
    
    primo[0] = 2;
    primo[1] = 3;
    primo[2] = 5;
    primo[3] = 7;
    
    cont = 4; //contador vai ser responsavel pelos indices do nosso vetor de primos


    time_t begin = time(NULL); //função para calcular o tempo de execução


//TEST para grafico
    struct timeval stop, start;
    gettimeofday(&start, NULL);
    char int_str[20];
    sprintf(int_str, "%s", "TIMES");
    fprintf(temporPrimo, "%s\n", int_str); 


    //DESCOBRINDO NUMEROS PRIMOS
    for(numero = VAL_INI; numero < LIM_SUP; numero ++)
    {
        tam = numero/2;
        //faz a divisão do numero (n) pelos primos armazenados no vetor (primo)
        for(div = 2; div < tam; div++)
        {
            //se um dos valores primos conseguir dividir o numero ja saimos do laço.
            if(numero % div == 0)
                
                break;

            //se chegar até o fim do vetor de primos, significa q esse valor é um novo numero primo então, armazenamos ele no vetor
            if (div == tam-1){
                primo[cont] = numero;
                cont++;
                gettimeofday(&stop, NULL);
                sprintf(int_str, "%ld", (stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec);
                fprintf(temporPrimo, "%s\n", int_str); //microsecond

            }
        }
    }
    time_t end = time(NULL); //função para calcular o tempo de execução



    printf("Quantidade de numeros primos = %d\n", cont);  //Printa a quantidade de numeros primos entre 2 e o LIM_SUP  
    printf("Tempo de execução para descobrir os numeros primos: %ld segundos\n", (end - begin)); //printa o tempo de execução em segundos para descobrir os numeros primos


    //DESCOBRINDO A CHAVE PUBLICA
    p = primo[cont-500]; // primo escolhido para ser usado na descoberta da chave primaria
    q = primo[cont-73]; // primo escolhido para ser usado na descoberta da chave primaria  

    printf("P = %lld - Q = %lld \n", p, q); 

    n = p * q;
    printf("N = %lld\n", n);

    phi_n = (p-1) * (q-1);
    printf("Phi(N) = %lld\n", phi_n);

    e = 0;
    //procura um numero primo de Phi(N) -> [numeros primos entre si são aqueles q não possuem um divisor em comum, alem do 1. Por exemplo, 25 e 9 são primos entre si]
    for(i = 10; i < phi_n; i++)
    {
        for(j = 2; j < (i + 1); j++)
        {
            if(phi_n % j == 0 && i % j == 0)
                break;

            if(j == i)
                e = i;
        }

        //E vai receber o primeiro numero primo com Phi(n) [o algoritimo em si é um numero aleatorio mas o primeiro serve]
        if(e != 0)
            break;
    }

    printf("E = %lld\n", e);

    printf("CHAVE PUBLICA: [%lld, %lld]\n", n, e);
    


    time_t begin_2 = time(NULL); //função para calcular o tempo de execução
    for (d = 1; d <= phi_n; d++)
    {
        if((d*e) % phi_n == 1)
            break;
    }
    time_t end_2 = time(NULL); //função para calcular o tempo de execução

    printf("Tempo de execução para calcular a chave privada: %ld segundos\n", (end_2 - begin_2)); //printa o tempo de execução em segundos para descobrir os numeros primos

    printf("CHAVE PRIVADA: [%lld]\n", d);
    
    cudaFree(primo);
    fclose(temporPrimo);
    return 0;
}