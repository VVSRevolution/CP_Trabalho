#include <stdio.h>
#include <omp.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

# define VAL_INI 10 //valor inicial
# define LIM_SUP 200000 //limite superior (até onde vamos para calcular os numeros primos)

int main(){

    long long int numero; 
    long long int primo [100000]; //vetor q vai aramazenar todos os numero primos
    int i, j, cont;
    long long int p, q; //variaveis para armazenar dois primos (para gerar a chave publica)
    long long int n; //Multiplicação de p e q
    long long int phi_n;
    long long int e;
    long long int d;
    int tam;
    int flag;

    //iniciamos nosso vetor de primos com alguns valores
    primo[0] = 2;
    primo[1] = 3;
    primo[2] = 5;
    primo[3] = 7;

    cont = 4; //contador vai ser responsavel pelos indices do nosso vetor de primos

    time_t begin = time(NULL); //função para calcular o tempo de execução

    struct timeval stop;
    struct timeval start;
    gettimeofday(&start, NULL);


    //DESCOBRINDO NUMEROS PRIMOS
    #pragma omp parallel for private (tam, flag) num_threads(16) 
        for(long long int nume = VAL_INI; nume < LIM_SUP; nume ++)
        {
            tam = nume/2;
            for(long long int div = 2; div < tam; div++)
            {
                //se um dos valores primos conseguir dividir o numero ja saimos do laço.
                if(nume % div == 0){
                    flag = 0;
                    break;
                }

                //se chegar até o fim do vetor de primos, significa q esse valor é um novo numero primo então, armazenamos ele no vetor
                if (div == tam-1){
                    flag = 1;
                }
            }

            if(flag == 1){
                /*if(omp_get_thread_num() == 14)
                    p = nume;
                if(omp_get_thread_num() == 15)
                    q = nume;*/
                #pragma omp atomic
                    cont = cont + 1;
            }
        }

    gettimeofday(&stop, NULL);
    time_t end = time(NULL); //função para calcular o tempo de execução

    printf("Quantidade de numeros primos = %d\n", cont);  //Printa a quantidade de numeros primos entre 2 e o LIM_SUP  
    printf("Tempo de execução para descobrir os numeros primos: %ld microssegundos\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec)); //printa o tempo de execução em segundos para descobrir os numeros primos

    p = 193847;
    q = 199049;

    //DESCOBRINDO A CHAVE PUBLICA
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
    
    
    long long int D;
    int sair = 0;
    time_t begin_2 = time(NULL); //função para calcular o tempo de execução
    #pragma omp parallel for num_threads(16)
        for (d = 1; d <= phi_n; d++)
        {
            if((d*e) % phi_n == 1){
                D = d;
                sair = 1;
            }
        }
    time_t end_2 = time(NULL); //função para calcular o tempo de execução

    printf("Tempo de execução para calcular a chave privada: %ld segundos\n", (end_2 - begin_2)); //printa o tempo de execução em segundos para descobrir os numeros primos

    printf("CHAVE PRIVADA: [%lld]\n", D);

    return 0;
}