#include<iostream>

using namespace std;


void quicksort(int *a,int left,int right){
	int i=left;
	int j=right;
	int p=a[(i+j)/2];
	while(i<=j){
		while(a[i] < p) i++;
		while(p < a[j]) j--;
		if(i<=j){
			int temp=a[i];
			a[i]=a[j];
			a[j]=temp;
			i++;
			j--;
		}
	}
	if(i<right) quicksort(a,i,right);
	if(left<j) quicksort(a,left,j);
}


int main(){
	char str[1000];
	int a[100];
	int st[10000];
	cin.getline(str,1000);
	int i=0,j=0,num=0;
	while(str[i]!=NULL){
		if(str[i]==' '){
			a[j]=num;
			j++;
			num=0;
		}else{
			num=10*num+str[i]-'0';
		}
		i++;
	}
	a[j]=num;
	int top=0;
	st[top++]=0;
	st[top++]=j;
	
	do{

		int R = st[--top];
		int L = st[--top];
	
		do{
		
			int l=L;
			int r=R;
			int p=a[(l+r)/2];
		
			do{
				while(a[l]<p) l++;
				while(a[r]>p) r--;
				if(l<=r){
					st[top++]=a[l];
					st[top++]=a[r];
					a[l]=st[--top];
					a[r]=st[--top];
					l++;
					r--;
				}
				
			}while(l<=r);
			if(l<R){
				st[top++]=l;
				st[top++]=R;
			}
			R=r;
		}while(L<R);
	}while(top>0);
	
	//quicksort(a,0,j);
	
	for(int i=0;i<=j;i++)
		cout << a[i] <<' ';

}
