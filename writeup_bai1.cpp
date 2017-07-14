#include<iostream>
#include <stdio.h>
using namespace std;
char mem[26] = { 0x62 ,0x64 ,0x6e ,0x70 ,0x51 ,0x61 ,0x69 ,0x7c ,0x6e ,0x75 ,0x66 ,0x69 ,0x6d ,0x6e ,0x75 ,0x67 ,0x60 ,0x6e ,0x7b ,0x46 ,0x61 ,0x66 ,0x68 ,0x72 ,0x57 ,0x4 };
int key[5];
void run()
{
	printf("enter key : ");
	cin >> key[0] >> key[1] >> key[2] >> key[3] >> key[4];
	printf("flag is : ");
	for (int i = 0; i < 26; i++)
		printf("%c", mem[i] ^ key[i % 5]);
}
void writeup()
{
	char flag[] = "flag{";
	for (int i = 0; i < 5; i++)
		key[i] = flag[i] ^ mem[i];
	printf("key is :");
	for (int i = 0; i < 5; i++)
		printf("%d ", key[i]);
	printf("\n");
	for (int i = 0; i < 26; i++)
		printf("%c", mem[i] ^ key[i % 5]);
}
int main()
{
	//run();
	writeup();
	cin.get();
}
