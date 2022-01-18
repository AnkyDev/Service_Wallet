// maximum and minimum in array

class Prep2
{
	public static void main(String args[])
	{
		int a[] = {20,12,10,15,2};

		for(int i=0;i<a.length-1;i++)
		{
			if(a[i] < a[i+1])
			{
				int temp = a[i];
				a[i] = a[i+1];
				a[i+1] = temp;


				for(int j=i;j>0;j--)
				{
					if(a[j]>a[j-1])
					{
						int tep = a[j];
						a[j] = a[j-1];
						a[j-1] = tep;
					}
					else
					{
						break;
					}
				}

			}
		}
		System.out.println("maximum = "+a[0]);
		System.out.println("minimum = "+a[a.length-1]);
	}
}