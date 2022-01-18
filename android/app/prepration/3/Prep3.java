import java.util.*;

class Prep3
{
	static Scanner sc = new Scanner(System.in);

	public static void main(String args[])
	{
		int count = sc.nextInt();

		for(int i=0;i<count;i++)
		{
			int no = sc.nextInt();
			int data[] = new int[no];
			for(int j = 0;j<no;j++)
			{
				data[j] = sc.nextInt();
				System.out.println(data[j]);
			}
			getSort(data);
		}
	}

	static int getSort(int a[])
	{
		System.out.println(a[0]);

		return 0;
	}
}