int main(){

	int a = 1;
	int b = 11;
	int c = 4;
	int const d = 100;


	while(a < 10){

		a = b + c;

	}


	if(a > 0){

		c = b;

		a = 2;

		b = a + 8;



	}

	if (a == 2){

		b = a + 2;

		a = c + 5;

		c = 1;

		c = (5 + 2) * (8 * 9);

	}

	else{

		a = 2;

	}

	printf(a);

	printf(b);

	printf(c);

	printf(d);
}


